import React,{useEffect,useState} from 'react';
import { TableContext } from './Contexts.js';
import { useContext } from 'react';


export default function Navbar({revStates, getImage, modalsVisibility}) {
  
    const tableState = useContext(TableContext)
    //console.log(tableState)
    const undoStack = revStates.undoStack
    const setUndoStack = revStates.setUndoStack
    const redoStack = revStates.redoStack
    const setRedoStack = revStates.setRedoStack
    const setData = tableState.setTableData
    const data = tableState.tableData
    const currentData = data;    

    const undo = () => {
        if (undoStack.length > 0) {
            const previousData = undoStack[undoStack.length - 1];

            setRedoStack([...redoStack, currentData]);
            setUndoStack(undoStack.slice(0, undoStack.length - 1));
            setData(previousData);
        }
    };

    const redo = () => {
        if (redoStack.length > 0) {
            const nextData = redoStack[redoStack.length - 1];

            setUndoStack([...undoStack, currentData]);
            setRedoStack(redoStack.slice(0, redoStack.length - 1));
            setData(nextData);
        }
    };

    const openRegistrationForm = () => {

        document.querySelector('#nav-tab button[data-bs-target="#register"]').click()
        modalsVisibility.regModalVisibility.setVisibility(true)
    }

    const openLoginForm = () => {

        document.querySelector('#nav-tab button[data-bs-target="#login"]').click()
        modalsVisibility.regModalVisibility.setVisibility(true)
    }

    return (
        <nav className="navbar navbar-expand-lg fixed-top bg-body-tertiary">

            <div className="container-fluid">
                <a className="navbar-brand">ФВиЗ</a>
                <button className="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                    <span className="navbar-toggler-icon"></span>
                </button>
                <div className="collapse navbar-collapse" id="navbarSupportedContent">
                    <div className="navbar-nav">
                        <div className={`nav-link ${undoStack.length === 0 ? "" : "active"}`} aria-current="page" onClick={undo}>↺Undo</div>
                        <div className={`nav-link ${redoStack.length === 0 ? "" : "active"}`} aria-current="page" onClick={redo}>↻Redo</div>
                        <div className="nav-link active" aria-current="page" onClick={getImage}>Screenshot</div>
                        <div className="nav-link active" aria-current="page">Anyway</div>
                    </div>
                </div>
                <div className="navbar-text">
                    <span onClick={() => openLoginForm()} style={{cursor: "pointer"}}>Login</span>
                    <span style={{margin:10}}>/</span>
                    <span onClick={() => openRegistrationForm()} style={{cursor: "pointer"}}>Register</span>
                </div>
            </div>
        </nav>
    );
}

