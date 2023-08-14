import React,{useEffect,useState, useContext} from 'react';
import TableUI from '../components/Table2';
import Draggable from 'react-draggable';
import getData, { postData, putData} from '../components/api';
import { ToastContainer, toast } from 'react-toastify';
import { UserProfile } from '../components/Contexts.js';
import { EditorState, convertToRaw,  convertFromRaw  } from 'draft-js';
import { Editor } from 'react-draft-wysiwyg';
import draftToHtml from 'draftjs-to-html';
import htmlToDraft from 'html-to-draftjs';
import { TableContext } from '../components/Contexts.js';


export default function Home() {

    const [isRegModalVisible, setRegModalVisibility] = useState(false);
    const regModalVisibility = {isVisible: isRegModalVisible, setVisibility: setRegModalVisibility}

    const [isEditProfileModalVisible, setEditProfileModalVisibility] = useState(false);
    const editProfileModalVisibility = {isVisible: isEditProfileModalVisible, setVisibility: setEditProfileModalVisibility}

    const [isEditCellModalVisible, setEditCellModalVisibility] = useState(false);
    const editCellModalVisibility = {isVisible: isEditCellModalVisible, setVisibility: setEditCellModalVisibility}

    const modalsVisibility={regModalVisibility,editProfileModalVisibility,editCellModalVisibility}


    const [tableData, setTableData] = useState([]);
    const tableState = {tableData,setTableData}
    const [gkColors, setGkColors] = useState([]);
    const gkState = {gkColors, setGkColors}

    useEffect(() => {
      getData(setTableData, process.env.REACT_APP_QUANTITIES_LINK)
      getData(setGkColors,process.env.REACT_APP_GK_SETTINGS_LINK)
  
    }, []);
  

    const [selectedCell, setSelectedCell] = useState(null);
    const selectedCellState={selectedCell, setSelectedCell}

    const [undoStack, setUndoStack] = useState([]);
    const [redoStack, setRedoStack] = useState([]);
    const revStates = {undoStack,setUndoStack,redoStack,setRedoStack}





    const [userToken, setUserToken] = useState(null)
    const [userProfile, setUserProfile] = useState(null)
    
    const userInfoState = {userToken, setUserToken,userProfile, setUserProfile}

    return (
        <UserProfile.Provider value={userInfoState}>
          <TableContext.Provider value={tableState}>
                <TableUI modalsVisibility={modalsVisibility} selectedCellState={selectedCellState} revStates={revStates} gkState={gkState}/>

                <div id="modal-mask" className='hidden'></div>                  
                  <RegModal modalsVisibility={modalsVisibility} setUserToken={setUserToken} setUserProfile={setUserProfile}/>               
                  {/* <EditProfileModal modalsVisibility={modalsVisibility}/> */}
                  <EditCellModal modalsVisibility={modalsVisibility} selectedCell={selectedCell}/>
            

                <ToastContainer />
          </TableContext.Provider>
        </UserProfile.Provider>
    );
}

function EditCellModal({modalsVisibility, selectedCell}) {


  const [cellNameEditor, setCellNameEditor] = useState(EditorState.createEmpty());
  const [cellSymbolEditor, setCellSymbolEditor] = useState(EditorState.createEmpty());
  const [cellUnitEditor, setCellUnitEditor] = useState(EditorState.createEmpty());

  

  console.log(getTextFromState(cellNameEditor))

  return  (  
    <Modal
    modalVisibility={modalsVisibility.editCellModalVisibility}
    title={"Edit profile"}
    hasBackground={false}
    sizeX={750}
    >
    <div className="modal-content2">

      <label className="form-label">Name</label>
      <CellEditor editorState={cellNameEditor} setEditorState={setCellNameEditor}/>
      <label className="form-label">Symbol</label>
      <CellEditor editorState={cellSymbolEditor} setEditorState={setCellSymbolEditor}/>
      <label htmlFor="InputFirstName3" className="form-label">Unit</label>
      <CellEditor editorState={cellUnitEditor} setEditorState={setCellUnitEditor}/>
          
    </div>

    </Modal>
  )
}

export function getTextFromState(editorState) {
  return draftToHtml(convertToRaw(editorState.getCurrentContent()))
}

export function getStateFromText(html) {

  const blocksFromHtml = htmlToDraft(html);
  const { contentBlocks, entityMap } = blocksFromHtml;
  const contentState = ContentState.createFromBlockArray(contentBlocks, entityMap);
  const editorState = EditorState.createWithContent(contentState);

  return editorState
}

function CellEditor({editorState,setEditorState}) {



  const onEditorStateChange = (editorState) => {

    setEditorState(editorState)

  };

  return (
    <Editor
          editorState={editorState}
          onEditorStateChange={onEditorStateChange}
          wrapperClassName=""
          editorClassName="form-control"
          toolbarClassName="toolbar-class"
         
          toolbarOnFocus
          toolbar={{
            options: ['inline', 'emoji', 'remove', 'history'],
            inline: {
              options: ['bold', 'italic', 'underline','superscript', 'subscript'],
            },
            emoji: {
            emojis: [
              "Α", "α" , "Β", "β" // someone please write greek alphabet here
            ],
            }
        }}
        />
  )
}

function EditProfileModal({modalsVisibility}) {


  return (
    <Modal
      modalVisibility={modalsVisibility.editProfileModalVisibility}
      title={"Edit profile"}
      hasBackground={true}
      >
      <div className="modal-content2">

        <label htmlFor="InputEmail3" className="form-label">Email address</label>
        <input type="email" className="form-control" id="InputEmail3" aria-describedby="emailHelp" placeholder="name@example.com"/>
        <label htmlFor="InputPassword3" className="form-label">Password</label>
        <input type="password" className="form-control" id="InputPassword3"/>
        <label htmlFor="InputFirstName3" className="form-label">First name</label>
        <input type="text" className="form-control" id="InputFirstName3"/>
        <label htmlFor="InputLastName3" className="form-label">Last name</label>
        <input type="text" className="form-control" id="InputLastName3"/>
        <label htmlFor="InputPatronymic3" className="form-label">Patronymic</label>
        <input type="text" className="form-control" id="InputPatronymic3"/>
            
      </div>

      </Modal>
  )
}

function LawsModal() {

  return null;
}

function RegModal({modalsVisibility, setUserToken, setUserProfile}) {

  const afterRegister = (userData) => {

    modalsVisibility.regModalVisibility.setVisibility(false)

    toast.success('Registration successful', {
      position: "top-center",
      autoClose: 5000,
      hideProgressBar: true,
      closeOnClick: true,
      pauseOnHover: true,
      progress: undefined,
      theme: "colored",
      });

    postData(setUserToken, process.env.REACT_APP_GK_LOGIN_LINK, userData, undefined, afterLogin)
  }

  const afterLogin = (token) => {

    modalsVisibility.regModalVisibility.setVisibility(false)
    
    toast.success('Login successful', {
      position: "top-center",
      autoClose: 5000,
      hideProgressBar: true,
      closeOnClick: true,
      pauseOnHover: true,
      progress: undefined,
      theme: "colored",
    });

    const headers = {
      Authorization: `Bearer ${token}`
    }

    putData(setUserProfile, process.env.REACT_APP_GK_PROFILE_LINK, undefined, headers )
  }


  const register = () => {

      const email = document.getElementById("InputEmail1").value
      const password = document.getElementById("InputPassword1").value

      const userData = {
        user: {
          email: email,
          password: password,
          last_name: "test",
          first_name: "test",
          patronymic: "test"
        }
      }



      postData(undefined, process.env.REACT_APP_GK_REGISTER_LINK, userData, undefined, afterRegister)
      

  }

  const login = () => {


    const email = document.getElementById("InputEmail2").value
    const password = document.getElementById("InputPassword2").value
    const userLoginData = {
      email: email,
      password: password,
    }

    postData(setUserToken, process.env.REACT_APP_GK_LOGIN_LINK, userLoginData, undefined, afterLogin)
  }


  return (
    <Modal
      modalVisibility={modalsVisibility.regModalVisibility}
      title={"Register/Login"}
      hasBackground={true}
      >
      <div className="modal-content2">

      <nav>
          <div className="nav nav-tabs" id="nav-tab" role="tablist">
              <button className="nav-link active" id="nav-login-tab" data-bs-toggle="tab" data-bs-target="#login" type="button" role="tab" aria-controls="login" aria-selected="true">Login</button>
              <button className="nav-link" id="nav-register-tab" data-bs-toggle="tab" data-bs-target="#register" type="button" role="tab" aria-controls="register" aria-selected="false">Register</button>
          </div>
      </nav>
      <div className="tab-content" id="nav-tabContent">
          <div className="tab-pane fade show active" id="login" role="tabpanel" aria-labelledby="login-tab" tabIndex="0">

              <div className="modal-content2">
                <label htmlFor="InputEmail2" className="form-label">Email address</label>
                <input type="email" className="form-control" id="InputEmail2" aria-describedby="emailHelp" placeholder="name@example.com"/>
                <label htmlFor="InputPassword2" className="form-label">Password</label>
                <input type="password" className="form-control" id="InputPassword2"/>
              </div>

              <div className="modal-footer2">

                  <button type="button" className="btn btn-secondary" onClick={() => modalsVisibility.setRegModalVisibility(false)}>Close</button>
                  <button type="button" className="btn btn-primary" onClick={() => login()}>Send</button>
              </div>
          </div>
          <div className="tab-pane fade" id="register" role="tabpanel" aria-labelledby="register-tab" tabIndex="0">

              <div className="modal-content2">
                  <label htmlFor="InputEmail1" className="form-label">Email address</label>
                  <input type="email" className="form-control" id="InputEmail1" aria-describedby="emailHelp" placeholder="name@example.com"/>
                  <label htmlFor="InputPassword1" className="form-label">Password</label>
                  <input type="password" className="form-control" id="InputPassword1"/>
                  <div id="passwordHelpBlock" className="form-text">
                      Your password must be 8-20 characters long.
                  </div>
              </div>


              <div className="modal-footer2">
                  <button type="button" className="btn btn-secondary" onClick={() => modalsVisibility.setRegModalVisibility(false)}>Close</button>
                  <button type="button" className="btn btn-primary" onClick={() => register()}>Send</button>
              </div>
          </div>
      </div>
      </div>

                   
      </Modal>
  )
}

function Modal({ children, modalVisibility, title, hasBackground = false, sizeX = 500 }) {

    const modalStartPos = (window.innerWidth / 2) - Math.min(sizeX/2,window.innerWidth/2)
  
    useEffect(() => {

    if (modalVisibility.isVisible && hasBackground) {
      document.getElementById("modal-mask").classList.remove("hidden")
    } else
    {
      document.getElementById("modal-mask").classList.add("hidden")
    }
    }, [modalVisibility.isVisible,hasBackground])
  
    const nodeRef = React.useRef(null);
      return (
        <Draggable
          handle=".modal-title2"
          defaultPosition={{x: modalStartPos, y: -600}}
          bounds="html"
          nodeRef={nodeRef}
          scale={1}
          >
          <div className={`drag-modal ${modalVisibility.isVisible ? "" : "hidden"}`} ref={nodeRef} style={{maxWidth: sizeX}}>
  
            <div className="modal-title2">
              <span>{title}</span>
              <button type="button" className="btn-close" onClick={() => modalVisibility.setVisibility(false)}></button>
            </div>
                {children}
          </div>
        </Draggable>
      );
  }


