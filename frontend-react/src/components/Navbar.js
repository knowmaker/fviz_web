import React from 'react';

function Navbar({ undo, redo, isUndoDisabled, isRedoDisabled }) {
    return (
        <div className="navbar">
            <div className="buttons">
                <button onClick={undo} disabled={isUndoDisabled}>
                    Undo
                </button>
                <button onClick={redo} disabled={isRedoDisabled}>
                    Redo
                </button>
            </div>
        </div>
    );
}

export default Navbar;
