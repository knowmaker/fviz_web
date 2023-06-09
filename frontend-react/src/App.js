import React, { useEffect, useState } from 'react';
import './App.css';
import MathJax from 'react-mathjax';
import axios from 'axios';

function Table() {
    const [data, setData] = useState([]);
    const [gkSettings, setGkSettings] = useState([]);
    const [isLoading, setIsLoading] = useState(false);
    let id = 0;

    useEffect(() => {
        setIsLoading(true);

        // Запрос к API для получения данных из 'http://127.0.0.1:5000/api/represents'
        axios.get('http://127.0.0.1:5000/api/represents')
            .then(response => {
                setData(response.data);
                setIsLoading(false);
            })
            .catch(error => {
                console.error(error);
                setIsLoading(false);
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

    const splitLatexText = (text) => {
        return text.split(' ').map((word, index) => (
            <><MathJax.Node key={index} inline formula={word} />{' '}</>
        ));
    };

    return (
        <MathJax.Provider>
            <div className="table">
                {isLoading && (
                    <div className="loading">
                        <img src="/loading.gif" alt="Loading" />
                    </div>
                )}
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
                                        id={`cell-${id}`}
                                        style={{ backgroundColor: cellColor }}
                                    >
                                        {cellContent_name && (
                                            <div>
                                                {splitLatexText(cellContent_name)}
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
