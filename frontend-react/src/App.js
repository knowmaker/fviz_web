// import React, { useEffect, useState } from 'react';
// import MathJax from 'react-mathjax';
//
// function Card({ id_value, val_name, symbol, M_indicate, L_indicate, T_indicate, I_indicate, unit, id_lt, id_gk, mlti_sign }) {
//   return (
//       <MathJax.Provider>
//       <div className="card">
//         <div>id_value: {id_value}</div>
//         <div style={{width: '5' + 'px'}}>val_name: <MathJax.Node inline formula={val_name} /></div>
//         <div>symbol: <MathJax.Node inline formula={symbol} /></div>
//         <div>unit: <MathJax.Node inline formula={unit} /></div>
//         <div>id_lt: {id_lt}</div>
//         <div>id_gk: {id_gk}</div>
//         <div>mlti_sign: <MathJax.Node inline formula={mlti_sign} /></div>
//       </div>
//       </MathJax.Provider>
//   );
// }
//
// function App() {
//   const [data, setData] = useState([]);
//
//   useEffect(() => {
//     fetch('http://127.0.0.1:5000/api/represents')
//         .then(response => response.json())
//         .then(jsonData => setData(jsonData));
//   }, []);
//
//   return (
//       <div className="App">
//         {data.map(item => (
//             <Card key={item.id_value} {...item} />
//         ))}
//       </div>
//   );
// }
//
// export default App;

import React, { useEffect, useState } from 'react';
import './App.css'; // Импорт файла стилей
import MathJax from 'react-mathjax';
import axios from 'axios';

function Table() {
    const [data, setData] = useState([]);
    const [gkSettings, setGkSettings] = useState([]);
    let id = 0;

    useEffect(() => {
        // Запрос к API для получения данных из 'http://127.0.0.1:5000/api/represents'
        axios.get('http://127.0.0.1:5000/api/represents')
            .then(response => {
                setData(response.data);
            })
            .catch(error => {
                console.error(error);
            });

        // Запрос к API для получения данных из 'http://127.0.0.1:5000/api/gk_settings'
        axios.get('http://127.0.0.1:5000/api/gk_settings')
            .then(response => {
                setGkSettings(response.data);
            })
            .catch(error => {
                console.error(error);
            });
    }, []);

    const convertColor = (color) => {
        if (color.length === 6) {
            return `#${color}`;
        }
        return color;
    };

    const getCellColor = (id_gk) => {
        const gkSetting = gkSettings.find(setting => setting.id_gk === id_gk);
        return gkSetting ? convertColor(gkSetting.gk_color) : '';
    };

    return (
        <MathJax.Provider>
            <div className="table">
                {[...Array(19)].map((_, rowIndex) => {
                    const isOddRow = rowIndex % 2 === 0;
                    const cellCount = isOddRow ? 20 : 19;

                    return (
                        <div key={rowIndex} className="row">
                            {[...Array(cellCount)].map((_, cellIndex) => {
                                id = id + 1;
                                const cellData = data.find(item => item.id_lt === id);
                                const cellContent_name = cellData ? cellData.val_name : '';
                                const cellContent_symbol = cellData ? cellData.symbol : '';
                                const cellContent_unit = cellData ? cellData.unit : '';
                                const cellContent_mlti = cellData ? cellData.mlti_sign : '';
                                const cellColor = getCellColor(cellData ? cellData.id_gk : '');

                                return (
                                    <div
                                        key={cellIndex}
                                        className={cellData ? "cell" : 'cell-invisible'}
                                        id={`cell-${id - 1}`}
                                        style={{ backgroundColor: cellColor }}
                                    >
                                        {cellContent_name && (
                                            <div>
                                                <MathJax.Node inline formula={cellContent_name} />
                                                <br />
                                            </div>
                                        )}
                                        {cellContent_symbol && (
                                            <div className="su-pos">
                                                <MathJax.Node inline formula={cellContent_symbol} />
                                                {cellContent_unit && (
                                                    <>{',  '}<MathJax.Node inline formula={cellContent_unit} /></>
                                                )}
                                                <br />
                                            </div>
                                        )}
                                        {cellContent_mlti && (
                                            <div className="mlti-pos">
                                                <MathJax.Node inline formula={cellContent_mlti} />
                                            </div>
                                        )}
                                    </div>
                                );
                            })}
                        </div>
                    );
                })}
            </div>
        </MathJax.Provider>
    );

}

export default Table;

