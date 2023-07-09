import React, { useEffect, useState, useRef } from 'react';
import MathJax from 'react-mathjax';
import axios from 'axios';
import Navbar from './Navbar';

function Table() {
    const [data, setData] = useState([]);
    const [gkSettings, setGkSettings] = useState([]);
    const [isLoading, setIsLoading] = useState(false);
    const [selectedCell, setSelectedCell] = useState(null);
    const [ltData, setLtData] = useState([]);
    const [isDataWindowVisible, setIsDataWindowVisible] = useState(false);
    const [undoStack, setUndoStack] = useState([]);
    const [redoStack, setRedoStack] = useState([]);
    const mathJaxRef = useRef(null);

    useEffect(() => {
        setIsLoading(true);

        axios
            .get('http://127.0.0.1:5000/api/represents')
            .then((response) => {
                setData(response.data);
                setIsLoading(false);
            })
            .catch((error) => {
                console.error(error);
                setIsLoading(false);
            });
            

        axios
            .get('http://127.0.0.1:5000/api/gk_settings')
            .then((response) => {
                setGkSettings(response.data);
            })
            .catch((error) => {
                console.error(error);
            });
    }, []);

    useEffect(() => {
        if (isDataWindowVisible && mathJaxRef.current) {
            mathJaxRef.current.typeset();
        }
    }, [isDataWindowVisible]);

    const convertColor = (color) => {
        if (color.length === 6) {
            return `#${color}`;
        }
        return color;
    };

    const getCellColor = (id_gk) => {
        const gkSetting = gkSettings.find((setting) => setting.id_gk === id_gk);
        return gkSetting ? convertColor(gkSetting.gk_color) : '';
    };

    const splitLatexText = (text) => {
        return text.split(' ').map((word, index) => (
            <React.Fragment key={index}>
                <MathJax.Node inline formula={word} />
                {' '}
            </React.Fragment>
        ));
    };

    const handleCellRightClick = (event, cellId) => {
        event.preventDefault();
        console.log(cellId)
        axios.get(`http://127.0.0.1:5000/api/cell/${cellId}`)
            .then((response) => {
                console.log(response.data);
                setLtData(response.data);
                setSelectedCell(cellId);
                setIsDataWindowVisible(true);
            })
            .catch((error) => {
                console.error(error);
            });
    };

    const handleCellClick = (event, extid) => {
        event.preventDefault();

        const cellData = ltData.find((item) => item.id_value === extid);
        if (cellData) {
            const updatedData = data.map((item) => {
                if (item.id_lt === selectedCell) {
                    return {
                        ...item,
                        ...cellData
                    };
                }
                return item;
            });

            setUndoStack([...undoStack, data]);
            setRedoStack([]);
            setData(updatedData);
        }

        setSelectedCell(null);
        setLtData([]);
        setIsDataWindowVisible(false);
    };

    const renderDataWindow = () => {
        if (isDataWindowVisible && selectedCell && ltData && ltData.length > 0) {
            return (
                <div className="data-window">
                    {ltData.map((dataItem, index) => {
                        const extid = dataItem.id_value;
                        const extcellContent_name = dataItem.val_name;
                        const extcellContent_symbol = dataItem.symbol;
                        const extcellContent_unit = dataItem.unit;
                        const extcellContent_mlti = dataItem.mlti_sign;
                        const extcellColor = getCellColor(dataItem ? dataItem.id_gk : '');

                        return (
                            <div
                                key={index}
                                className="cell"
                                id={`extcell-${extid}`}
                                style={{ backgroundColor: extcellColor }}
                                onClick={(event) => handleCellClick(event, extid)}
                            >
                                {extcellContent_name && (
                                    <div>
                                        {splitLatexText(extcellContent_name)}
                                        <br />
                                    </div>
                                )}
                                {extcellContent_symbol && (
                                    <div className="su-pos">
                                        <MathJax.Node inline formula={extcellContent_symbol} />
                                        {extcellContent_unit && (
                                            <>
                                                {', '}
                                                <MathJax.Node inline formula={extcellContent_unit} />
                                            </>
                                        )}
                                        <br />
                                    </div>
                                )}
                                {extcellContent_mlti && (
                                    <div className="mlti-pos">
                                        <MathJax.Node inline formula={extcellContent_mlti} />
                                    </div>
                                )}
                            </div>
                        );
                    })}
                </div>
            );
        }
        return null;
    };

    const undo = () => {
        if (undoStack.length > 0) {
            const previousData = undoStack[undoStack.length - 1];
            const currentData = data;

            setRedoStack([...redoStack, currentData]);
            setUndoStack(undoStack.slice(0, undoStack.length - 1));
            setData(previousData);
        }
    };

    const redo = () => {
        if (redoStack.length > 0) {
            const nextData = redoStack[redoStack.length - 1];
            const currentData = data;

            setUndoStack([...undoStack, currentData]);
            setRedoStack(redoStack.slice(0, redoStack.length - 1));
            setData(nextData);
        }
    };

    return (
        <>
            <Navbar
            undo={undo}
            redo={redo}
            isUndoDisabled={undoStack.length === 0}
            isRedoDisabled={redoStack.length === 0}
        />
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
                                    const id = rowIndex * 19 + (rowIndex % 2 === 0 ? 0 : 1) + cellIndex + 1 + Math.floor(rowIndex / 2);
                                    const cellData = data.find((item) => item.id_lt === id);
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
                                            onContextMenu={event => handleCellRightClick(event, id)}
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
                                                        <>
                                                            {', '}
                                                            <MathJax.Node inline formula={cellContent_unit} />
                                                        </>
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
                    {renderDataWindow()}
                </div>
            </MathJax.Provider>
        </>
    );
}

export default Table;
