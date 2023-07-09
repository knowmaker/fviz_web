import React from 'react';

export default function Navbar({tableState,revStates}) {
  
    const undoStack = revStates.undoStack
    const setUndoStack = revStates.setUndoStack
    const redoStack = revStates.redoStack
    const setRedoStack = revStates.setRedoStack
    const setData = tableState.setTableData
    const data = tableState.tableData

    const undo = () => {
        if (undoStack.length > 0) {
            const previousData = undoStack[undoStack.length - 1];
            const currentData = data;

            setRedoStack([...redoStack, currentData]);
            setUndoStack(undoStack.slice(0, undoStack.length - 1));
            setData(previousData);
            console.log(revStates.undoStack)
            console.log(revStates.redoStack)
        }
    };

    const redo = () => {
        if (redoStack.length > 0) {
            const nextData = redoStack[redoStack.length - 1];
            const currentData = data;

            setUndoStack([...undoStack, currentData]);
            setRedoStack(redoStack.slice(0, redoStack.length - 1));
            setData(nextData);
            console.log(revStates.undoStack)
            console.log(revStates.redoStack)
        }
    };

    return (
        <div className="navbar">
            <div className="buttons">
                <button onClick={undo} disabled={undoStack.length === 0}>
                    Undo
                </button>
                <button onClick={redo} disabled={redoStack.length === 0}>
                    Redo
                </button>
            </div>
        </div>
    );
}

