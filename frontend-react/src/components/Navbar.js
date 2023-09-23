import React,{useEffect,useState} from 'react';
import { TableContext, UserProfile } from '../misc/contexts.js';
import { useContext } from 'react';
import { toast } from 'react-toastify';
import { getTextFromState, getStateFromText} from '../pages/Home.js'


export default function Navbar({revStates, getImage, modalsVisibility}) {
  
    const tableState = useContext(TableContext)

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

    const userInfo = useContext(UserProfile)    

    const signOut = () => {

        userInfo.setUserProfile(null)
        userInfo.setUserToken(null)

        toast.success('successfully logged off', {
            position: "top-center",
            autoClose: 5000,
            hideProgressBar: true,
            closeOnClick: true,
            pauseOnHover: true,
            progress: undefined,
            theme: "colored",
          });

        localStorage.removeItem('token')

    }

    const openProfileForm = () => {
        modalsVisibility.editProfileModalVisibility.setVisibility(true)
    }

    const openEditForm = () => {
        modalsVisibility.editCellModalVisibility.setVisibility(true)

    }

    const openTableViewsForm = () => {
        modalsVisibility.tableViewsModalVisibility.setVisibility(true)
    }

    const openLawsForm = () => {
        modalsVisibility.lawsModalVisibility.setVisibility(true)
    }

    const openLawsGroupsForm = () => {
        modalsVisibility.lawsGroupsModalVisibility.setVisibility(true)
    }

    const openGKColorsEditForm = () => {
        modalsVisibility.GKColorsEditModalVisibility.setVisibility(true)
    }


    let loginButtons;

    if (userInfo.userProfile) {
        loginButtons = (
            <>
                <span onClick={() => openProfileForm()} style={{cursor: "pointer"}}>{userInfo.userProfile.email} (Открыть профиль)</span>
                <span style={{margin:10}}>/</span>
                <span onClick={() => signOut()} style={{cursor: "pointer"}}>Выйти</span>
            </>
        )
    }   
    else
    {
        loginButtons = (
            <>
                <span onClick={() => openLoginForm()} style={{cursor: "pointer"}}>Войти</span>
                <span style={{margin:10}}>/</span>
                <span onClick={() => openRegistrationForm()} style={{cursor: "pointer"}}>Зарегистрироваться</span>
            </>
        )
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
                        <div className={`nav-link ${undoStack.length === 0 ? "" : "active"}`} aria-current="page" onClick={undo}>↺Отменить</div>
                        <div className={`nav-link ${redoStack.length === 0 ? "" : "active"}`} aria-current="page" onClick={redo}>↻Вернуть</div>
                        <div className="nav-link active" aria-current="page" onClick={getImage}>Снимок текущего представления</div>
                        <div className="nav-link active" aria-current="page" onClick={openEditForm}>Редактирование ячейки</div>
                        <div className="nav-link active" aria-current="page" onClick={openTableViewsForm}>Представления</div>
                        <div className="nav-link active" aria-current="page" onClick={openLawsForm}>Законы</div>
                        <div className="nav-link active" aria-current="page" onClick={openLawsGroupsForm}>Группы законов</div>
                        <div className="nav-link active" aria-current="page" onClick={openGKColorsEditForm}>Цвета ячеек</div>
                    </div>
                </div>
                <div className="navbar-text">
                    {loginButtons}
                </div>
            </div>
        </nav>
    );
}

