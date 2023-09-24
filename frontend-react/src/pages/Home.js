import React,{useEffect,useState, useContext, useRef} from 'react';
import TableUI from '../components/Table';
import Draggable from 'react-draggable';
import setStateFromGetAPI, { postData, putData, patchData, deleteData, getAllCellData, 
  getDataFromAPI, postDataToAPI, putDataToAPI,patchDataToAPI,patchAllLayerData,deleteDataFromAPI} from '../misc/api';
import { ToastContainer, toast } from 'react-toastify';
import { UserProfile } from '../misc/contexts.js';
import { EditorState, convertToRaw , ContentState } from 'draft-js';
import { Editor } from 'react-draft-wysiwyg';
import { TableContext } from '../misc/contexts.js';
import { Cell } from '../components/Table.js';
import Footbar from '../components/FootBar';

import draftToMarkdown from 'draftjs-to-markdown';
import htmlToDraft from 'html-to-draftjs';

const Color = require('color');

export default function Home() {

    const [isRegModalVisible, setRegModalVisibility] = useState(false);
    const regModalVisibility = {isVisible: isRegModalVisible, setVisibility: setRegModalVisibility}

    const [isEditProfileModalVisible, setEditProfileModalVisibility] = useState(false);
    const editProfileModalVisibility = {isVisible: isEditProfileModalVisible, setVisibility: setEditProfileModalVisibility}

    const [isEditCellModalVisible, setEditCellModalVisibility] = useState(false);
    const editCellModalVisibility = {isVisible: isEditCellModalVisible, setVisibility: setEditCellModalVisibility}

    const [isLawsModalVisible, setLawsModalVisibility] = useState(false);
    const lawsModalVisibility = {isVisible: isLawsModalVisible, setVisibility: setLawsModalVisibility}

    const [isTableViewsModalVisible, setTableViewsModalVisibility] = useState(false);
    const tableViewsModalVisibility = {isVisible: isTableViewsModalVisible, setVisibility: setTableViewsModalVisibility}

    const [isLawsGroupsModalVisible, setLawsGroupsModalVisibility] = useState(false);
    const lawsGroupsModalVisibility = {isVisible: isLawsGroupsModalVisible, setVisibility: setLawsGroupsModalVisibility}
        
    const [isGKColorsEditModalVisible, setGKColorsEditModalVisibility] = useState(false);
    const GKColorsEditModalVisibility = {isVisible: isGKColorsEditModalVisible, setVisibility: setGKColorsEditModalVisibility}

    const modalsVisibility={regModalVisibility,editProfileModalVisibility,
                            editCellModalVisibility,lawsModalVisibility,
                            tableViewsModalVisibility,lawsGroupsModalVisibility,GKColorsEditModalVisibility}


    const [tableData, setTableData] = useState([]);
    const tableState = {tableData,setTableData}
    const [GKLayers, setGKLayers] = useState([]);
    const GKLayersState = {gkColors: GKLayers, setGkColors: setGKLayers}

    const [tableView, setTableView] = useState({id_repr:1,title:"Базовое"}); 
    const tableViewState = {tableView,setTableView}

    // get table and layers when page is loaded
    useEffect(() => {
      setStateFromGetAPI(setTableData,`${process.env.REACT_APP_API_LINK}/active_view`)
      setStateFromGetAPI(setGKLayers,`${process.env.REACT_APP_API_LINK}/gk`)

      async function logInByLocalStorage() {
        
        const storageToken = localStorage.getItem('token');
        if (storageToken) {
          const headers = {
            Authorization: `Bearer ${storageToken}`
          }   
  
          const profileResponseData = await getDataFromAPI(`${process.env.REACT_APP_API_LINK}/users/profile`,headers)
          if (!isResponseSuccessful(profileResponseData)) {
            localStorage.removeItem('token')
            return
          }
          showMessage("Авторизация успешна")

          setUserToken(storageToken)

        }


      }
      logInByLocalStorage()
  
    }, []);

  

    const [selectedCell, setSelectedCell] = useState(null);
    const selectedCellState={selectedCell, setSelectedCell}

    
    const [hoveredCell, setHoveredCell] = useState(null);
    const hoveredCellState = {hoveredCell, setHoveredCell}

    const [undoStack, setUndoStack] = useState([]);
    const [redoStack, setRedoStack] = useState([]);
    const revStates = {undoStack,setUndoStack,redoStack,setRedoStack}




    const [cellNameEditor, setCellNameEditor] = useState(EditorState.createEmpty());
    const cellNameEditorState = {value: cellNameEditor, set: setCellNameEditor}
    const [cellSymbolEditor, setCellSymbolEditor] = useState(EditorState.createEmpty());
    const cellSymbolEditorState = {value: cellSymbolEditor, set: setCellSymbolEditor}
    const [cellUnitEditor, setCellUnitEditor] = useState(EditorState.createEmpty());
    const cellUnitEditorState = {value: cellUnitEditor, set: setCellUnitEditor}
    const [cellMLTIEditor, setCellMLTIEditor] = useState(EditorState.createEmpty());
    const cellMLTIEditorState = {value: cellMLTIEditor, set: setCellMLTIEditor}

    const [cellLEditor, setCellLEditor] = useState(0)
    const cellLEditorState = {value: cellLEditor, set: setCellLEditor}
    const [cellTEditor, setCellTEditor] = useState(0)
    const cellTEditorState = {value: cellTEditor, set: setCellTEditor}
    const cellEditorsStates = {cellNameEditorState,cellSymbolEditorState,cellUnitEditorState,cellLEditorState,cellTEditorState,cellMLTIEditorState}

    const [tableViews, setTableViews] = useState(null)
    const [laws, setLaws] = useState(null)
    const lawsState = {laws, setLaws}

    const [selectedLaw, setSelectedLaw] = useState({law_name: null,cells:[],id_type: null})
    const selectedLawState = {selectedLaw, setSelectedLaw}

    const [lawsGroups, setLawsGroups] = useState([])
    const lawsGroupsState = {lawsGroups, setLawsGroups}

    useEffect(() => {

      // add key handler for special actions
      const keyDownHandler = event => {
        //console.log('User pressed: ', event.key);

        // when escape pressed deselect any law
        if (event.key === 'Escape') {
          event.preventDefault();
          setSelectedLaw({law_name: null,cells:[],id_type: null})
        }
      };
      document.addEventListener('keydown', keyDownHandler);
  
      return () => {
        document.removeEventListener('keydown', keyDownHandler);
      };

    }, []);

    useEffect(() => {

      // if selected cell changed
      async function setSelectedCell() {
        if (selectedCell) {
          setStateFromGetAPI(null, `${process.env.REACT_APP_API_LINK}/quantities/${selectedCell.id_value}`)
  
          // get full data about cell
          const cellResponseData = await getDataFromAPI(`${process.env.REACT_APP_API_LINK}/quantities/${selectedCell.id_value}`)
          if (!isResponseSuccessful(cellResponseData)) {
            showMessage(cellResponseData.data.error,"error")
            return
          }
          const cellData = cellResponseData.data.data
  
          // set cell editor for this cell
          convertMarkdownToEditorState(setCellNameEditor, cellData.value_name) 
          convertMarkdownToEditorState(setCellSymbolEditor, cellData.symbol) 
          convertMarkdownToEditorState(setCellUnitEditor, cellData.unit) 
          document.getElementById("inputL3").value = cellData.l_indicate
          document.getElementById("inputT3").value = cellData.t_indicate
          document.getElementById("inputGK3").value = cellData.id_gk
        }  
      }
      setSelectedCell()

    }, [selectedCell]);

    const [userToken, setUserToken] = useState(null)
    const [userProfile, setUserProfile] = useState(null)
    
    const userInfoState = {userToken, setUserToken,userProfile, setUserProfile}

    useEffect(() => {

      if (userToken) {

        // set header for API queries
        const headers = {
          Authorization: `Bearer ${userToken}`
        }    

        // get all required data
        setStateFromGetAPI(setUserProfile, `${process.env.REACT_APP_API_LINK}/users/profile`, undefined, headers )
        setStateFromGetAPI(setGKLayers,`${process.env.REACT_APP_API_LINK}/gk`,undefined,headers)
        setStateFromGetAPI(setTableViews, `${process.env.REACT_APP_API_LINK}/represents`,undefined,headers)
        // fix later
        setStateFromGetAPI(undefined, `${process.env.REACT_APP_API_LINK}/laws`,testShow,headers)
        setStateFromGetAPI(setLawsGroups, `${process.env.REACT_APP_API_LINK}/law_types`,undefined,headers)

        // set up localstorage to authenticate automatically
        localStorage.setItem('token', userToken);

      } else {
        // if there is no user token delete user profile
        setUserProfile(null)
      }

    }, [userToken]);

    useEffect(() => {

      // if user profile is not null set edit form
      if (userProfile) {
        document.getElementById("InputEmail3").value = userProfile.email
        document.getElementById("InputFirstName3").value = userProfile.first_name
        document.getElementById("InputLastName3").value = userProfile.last_name
        document.getElementById("InputPatronymic3").value = userProfile.patronymic
      } else {
        document.getElementById("InputEmail3").value = ""
        document.getElementById("InputFirstName3").value = ""
        document.getElementById("InputLastName3").value = ""
        document.getElementById("InputPatronymic3").value = ""
      }
    }, [userProfile]);

    // DELETE LATER <------------------------
    const testShow = (result,_,info) => {

      console.log("result:",result,"input:",info)
    }

    return (
        <UserProfile.Provider value={userInfoState}>
          <TableContext.Provider value={tableState}>

                <TableUI modalsVisibility={modalsVisibility} selectedCellState={selectedCellState} revStates={revStates} gkState={GKLayersState} selectedLawState={selectedLawState} hoveredCellState={hoveredCellState}/>
                <Footbar hoveredCell={hoveredCell} selectedLawState={selectedLawState}/>

                <div id="modal-mask" className='hidden'></div>                  
                <RegModal modalVisibility={modalsVisibility.regModalVisibility} setUserToken={setUserToken}/>               
                <EditCellModal modalVisibility={modalsVisibility.editCellModalVisibility} selectedCell={selectedCell} cellEditorsStates={cellEditorsStates} gkColors={GKLayers}/>
                <EditProfileModal modalsVisibility={modalsVisibility} userInfoState={userInfoState}/>
                <LawsModal modalsVisibility={modalsVisibility} lawsState={lawsState} selectedLawState={selectedLawState} lawsGroupsState={lawsGroupsState}/>
                <TableViewsModal modalsVisibility={modalsVisibility} tableViews={tableViews} setTableViews={setTableViews} tableViewState={tableViewState}/>
                <LawsGroupsModal modalsVisibility={modalsVisibility} lawsGroupsState={lawsGroupsState}/>
                <GKColorModal modalsVisibility={modalsVisibility} GKLayersState={GKLayersState}/>

                <ToastContainer />
          </TableContext.Provider>
        </UserProfile.Provider>
    );
}

function EditCellModal({modalVisibility, selectedCell, cellEditorsStates, gkColors}) {

  const tableState = useContext(TableContext)
  const userInfoState = useContext(UserProfile) 
  const headers = {
    Authorization: `Bearer ${userInfoState.userToken}`
  }  

  const updateCell = async () => {

    // get all MLTI parameters
    const id_gk = parseInt(document.getElementById("inputGK3").value)

    const G_indicate = gkColors.find(gkLevel => gkLevel.id_gk === id_gk).g_indicate
    const K_indicate = gkColors.find(gkLevel => gkLevel.id_gk === id_gk).k_indicate
    const l_indicate = parseInt(document.getElementById("inputL3").value)
    const t_indicate = parseInt(document.getElementById("inputT3").value)

    const M_indicate = 0 - (G_indicate*-1+K_indicate)
    const L_indicate = l_indicate - G_indicate*3
    const T_indicate = t_indicate - G_indicate*-2
    const I_indicate = 0 - K_indicate*-1

    // create new cell
    const newCell = {
      quantity: {
        value_name: convertMarkdownFromEditorState(cellEditorsStates.cellNameEditorState.value).split("/n").join(""),
        symbol: convertMarkdownFromEditorState(cellEditorsStates.cellSymbolEditorState.value).split("/n").join(""),
        unit: convertMarkdownFromEditorState(cellEditorsStates.cellUnitEditorState.value).split("/n").join(""),
        l_indicate: l_indicate,
        t_indicate: t_indicate,
        id_gk: id_gk,
        m_indicate_auto: M_indicate,
        l_indicate_auto: L_indicate,
        t_indicate_auto: T_indicate,
        i_indicate_auto: I_indicate,
        mlti_sign: convertToMLTI(M_indicate,L_indicate,T_indicate,I_indicate)
      }

    }

    // send cell update request
    const changedCellResponseData = await putDataToAPI(`${process.env.REACT_APP_API_LINK}/quantities/${selectedCell.id_value}`, newCell, headers)
    if (!isResponseSuccessful(changedCellResponseData)) {
      showMessage(changedCellResponseData.data.error,"error")
      return
    }
    const cellData = changedCellResponseData.data.data

    // show message
    showMessage("Ячейка была изменена")

    // remove old cell and set new one
    tableState.setTableData(tableState.tableData.filter(cell => cell.id_lt !== cellData.id_lt).concat(cellData))

    // send request to replace missing cell
    const cellAlternativesResponseData = await getDataFromAPI(`${process.env.REACT_APP_API_LINK}//layers/${selectedCell.id_lt}`,headers)
    if (!isResponseSuccessful(cellAlternativesResponseData)) {
      showMessage(cellAlternativesResponseData.data.error,"error")
      return
    }

    const cellAlternatives = cellAlternativesResponseData.data.data

    // replace missing cell if there is alternative
    if (cellAlternatives.length > 0 && cellData.id_lt !== selectedCell.id_lt) {
      tableState.setTableData(tableState.tableData.filter(cell => cell.id_value !== selectedCell.id_value).concat(cellAlternatives[0]))
    }

    // hide modal
    modalVisibility.setVisibility(false)

  }

  const deleteCell = async () => {


    const cellDeleteResponseData = await deleteDataFromAPI(`${process.env.REACT_APP_API_LINK}//quantities/${selectedCell.id_value}`,headers)
    if (!isResponseSuccessful(cellDeleteResponseData)) {
      showMessage(cellDeleteResponseData.data.error,"error")
      return
    }
    // selectedCell.id_value
    showMessage("Ячейка была удалена")



  }

  // generate gk layer list
  const cellList = gkColors.map(gkLevel => {

    const shownText = `${gkLevel.gk_name}  ${gkLevel.gk_sign}`

    return (
      <option key={gkLevel.id_gk} value={gkLevel.id_gk} dangerouslySetInnerHTML={{__html: shownText}}/>
    );

  });

  const [previewCell, setPreviewCell] = useState({
    cellFullId:9999,
    cellData:{value_name:"не выбрано",symbol:"",unit:"",mlti_sign:""},
    cellColor:undefined
  })

  const [GKoption, setGKoption] = useState(null)

  useEffect(() => {

    // update preview cell when input happens
    updatePreviewCell()
  
    }, [cellEditorsStates,GKoption,selectedCell]);

    const updatePreviewCell = () => {
    
    const id_gk = parseInt(document.getElementById("inputGK3").value)
    if (id_gk) {
    
    const cellColor = gkColors.find((setting) => setting.id_gk === id_gk).color

    const G_indicate = gkColors.find(gkLevel => gkLevel.id_gk === id_gk).g_indicate
    const K_indicate = gkColors.find(gkLevel => gkLevel.id_gk === id_gk).k_indicate
    const l_indicate = parseInt(document.getElementById("inputL3").value)
    const t_indicate = parseInt(document.getElementById("inputT3").value)

    const M_indicate = 0 - (G_indicate*-1+K_indicate)
    const L_indicate = l_indicate - G_indicate*3
    const T_indicate = t_indicate - G_indicate*-2
    const I_indicate = 0 - K_indicate*-1

    setPreviewCell(

      {
        cellFullId:9999,
        cellData:{
          value_name: convertMarkdownFromEditorState(cellEditorsStates.cellNameEditorState.value),
          symbol: convertMarkdownFromEditorState(cellEditorsStates.cellSymbolEditorState.value),
          unit: convertMarkdownFromEditorState(cellEditorsStates.cellUnitEditorState.value),
          mlti_sign: convertToMLTI(M_indicate,L_indicate,T_indicate,I_indicate),
        },
        cellColor: cellColor,
      }

    )
    }

    }

  return  (  
    <Modal
    modalVisibility={modalVisibility}
    title={"Edit cell"}
    hasBackground={false}
    sizeX={650}
    >
    <div className="modal-content2">
    <div className="row">
      <details>
        <summary>Превью</summary>
        <Cell cellFullData={previewCell} />
      </details>
    </div>
      <div className="row">
      <div className="col-6">
        <label className="form-label">Имя</label>
        <RichTextEditor editorState={cellEditorsStates.cellNameEditorState.value} setEditorState={cellEditorsStates.cellNameEditorState.set}/>
      </div>
      <div className="col-6">
        <label className="form-label">Условное обозначение</label>
        <RichTextEditor editorState={cellEditorsStates.cellSymbolEditorState.value} setEditorState={cellEditorsStates.cellSymbolEditorState.set}/>
      </div>
      </div>
      <div className="row">
      <div className="col-6">
      <label htmlFor="InputFirstName3" className="form-label">Единица измерения</label>
      <RichTextEditor editorState={cellEditorsStates.cellUnitEditorState.value} setEditorState={cellEditorsStates.cellUnitEditorState.set}/>
      </div>
      <div className="col">
      <label htmlFor="InputFirstName3" className="form-label">Уровень GK</label>
      <select className="form-select" aria-label="Default select example" id='inputGK3' onChange={() => setGKoption(parseInt(document.getElementById("inputGK3").value))}>
        {cellList}
      </select>

      </div>

      </div>
      <div className="row">
      <div className="col">
      <label className="form-label">L</label>
      <input type="number" min="-10" max="10" step="1" className="form-control" id="inputL3" onChange={() => updatePreviewCell()}/>
      </div>

      <div className="col">
      <label className="form-label">T</label>
      <input type="number" min="-10" step="1" className="form-control" id="inputT3" onChange={() => updatePreviewCell()}/>
      </div>

      </div>

    </div>
    <div className="modal-footer2">
      <button type="button" className="btn btn-danger" onClick={() => deleteCell()}>Удалить</button>
      <button type="button" className="btn btn-primary" onClick={() => updateCell()}>Сохранить</button>
    </div>

    </Modal>
  )
}

function RichTextEditor({editorState,setEditorState}) {



  const onEditorStateChange = (editorState) => {
    setEditorState(editorState)
  };

  // settings for editor
  return (
    <Editor
          editorState={editorState}
          onEditorStateChange={onEditorStateChange}
          wrapperClassName=""
          editorClassName="form-control"
          toolbarClassName="toolbar-class"

          toolbar={{
            options: [ 'emoji', 'inline', 'remove'],
            inline: {
              options: ['superscript', 'subscript'],
            },
            emoji: {
                icon: '/svg.svg',
                title: 'Алфавит',
                emojis: [
                    "Α", "Β", "Γ", "Δ", "Ε", "Ζ", "Η", "Θ", "Ι", "Κ", "Λ", "Μ",
                    "Ν", "Ξ", "Ο", "Π", "Ρ", "Σ", "Τ", "Υ", "Φ", "Χ", "Ψ", "Ω",
                    "α", "β", "γ", "δ", "ε", "ζ", "η", "θ", "ι", "κ", "λ", "μ",
                    "ν", "ξ", "ο", "π", "ρ", "ς", "σ", "τ", "υ", "φ", "χ", "ψ",
                    "ω", "∀", "∁", "∂", "∃", "∄", "∅", "∆", "∇"
                ],
            }
        }}
        />
  )
}

function EditProfileModal({modalsVisibility}) {

  const modalVisibility = modalsVisibility.editProfileModalVisibility
  const userInfoState = useContext(UserProfile) 
  const headers = {
    Authorization: `Bearer ${userInfoState.userToken}`
  }      

  const editProfile = async () => {

    // get values from fields
    const firstName = document.getElementById("InputFirstName3").value
    const lastName = document.getElementById("InputLastName3").value 
    const patronymic = document.getElementById("InputPatronymic3").value
    const password = document.getElementById("InputPassword3").value

    let newUserData = {
      user: {
        last_name: lastName,
        first_name: firstName,
        patronymic: patronymic,
      }
      
    }

    // if new password field is not empty add it to json
    if (password !== "") {
      newUserData.user.password = password
    }

    // send profile update request
    const editUserResponse = await patchDataToAPI(`${process.env.REACT_APP_API_LINK}/update`,newUserData,headers)
    if (!isResponseSuccessful(editUserResponse)) {
      showMessage(editUserResponse.data.error,"error")
      return
    }
   
    // hide modal
    modalVisibility.setVisibility(false)
    showMessage("Профиль обновлён")

    // empty input fields
    document.getElementById("InputEmail2").value = ""
    document.getElementById("InputPassword2").value = ""
    document.getElementById("InputEmail1").value = ""
    document.getElementById("InputPassword1").value = ""

  }

  const deleteUser = async () => {

    // send delete request
    const deleteUserResponse = await deleteDataFromAPI(`${process.env.REACT_APP_API_LINK}/delete`,undefined,headers)
    if (!isResponseSuccessful(deleteUserResponse)) {
      showMessage(deleteUserResponse.data.error,"error")
      return
    }
    // show message and delete user token
    showMessage("Аккаунт удалён")
    userInfoState.setUserToken(null)

  }

  return (
    <Modal
      modalVisibility={modalVisibility}
      title={"Редактирование профиля"}
      hasBackground={true}
      >
      <div className="modal-content2">

        <label htmlFor="InputEmail3" className="form-label">Почта</label>
        <input type="email" className="form-control" id="InputEmail3" aria-describedby="emailHelp" placeholder="name@example.com" disabled={true}/>
        <label htmlFor="InputLastName3" className="form-label">Новый пароль</label>
        <input type="password" className="form-control" id="InputPassword3" placeholder="Пароль"/>
        <label htmlFor="InputLastName3" className="form-label">Фамилия</label>
        <input type="text" className="form-control" id="InputLastName3" placeholder="Воронин"/>
        <label htmlFor="InputFirstName3" className="form-label">Имя</label>
        <input type="text" className="form-control" id="InputFirstName3" placeholder="Александр"/>
        <label htmlFor="InputPatronymic3" className="form-label">Отчество</label>
        <input type="text" className="form-control" id="InputPatronymic3" placeholder="Максимович"/>
            
      </div>
      <div className="modal-footer2">
        <button type="button" className="btn btn-danger" onClick={() => deleteUser()}>Удалить аккаунт</button>
        <button type="button" className="btn btn-primary" onClick={() => editProfile()}>Редактировать</button>
      </div>

      </Modal>
  )
}

function LawsModal({modalsVisibility, lawsState, selectedLawState, lawsGroupsState}) {

  const userInfoState = useContext(UserProfile) 
  const headers = {
    Authorization: `Bearer ${userInfoState.userToken}`
  }      

  const createLaw = () => {

    if (selectedLawState.selectedLaw.cells.length !== 4) {
      return
    }
    if (!checkLaw(selectedLawState.selectedLaw.cells)) {
      return
    }
    const selectedLawCellId = selectedLawState.selectedLaw.cells.map(cell => cell.id_value)



    //console.log(selectedLawCellId)

    const newLaw = {
      law: {
        law_name: document.getElementById("InputLawName3").value,
        first_element: selectedLawCellId[0],
        second_element: selectedLawCellId[1],
        third_element: selectedLawCellId[2],
        fourth_element: selectedLawCellId[3],
        id_type: document.getElementById("inputLawGroup3").value
      }
    }
    //console.log(newLaw)
    postData(undefined, `${process.env.REACT_APP_API_LINK}/laws`, newLaw, headers, afterCreateLaw)
    

  }
  
  const afterCreateLaw = () => {

    //console.log("success")
    setStateFromGetAPI(lawsState.setLaws, `${process.env.REACT_APP_API_LINK}/laws`,undefined,headers)
  }


  const updateLaw = () => {
    if (selectedLawState.selectedLaw.cells.length !== 4) {
      return
    }
    if (!checkLaw(selectedLawState.selectedLaw.cells)) {
      return
    }
    const selectedLawCellId = selectedLawState.selectedLaw.cells.map(cell => cell.id_value)



    //console.log(selectedLawCellId)

    const newLaw = {
      law: {
        law_name: document.getElementById("InputLawName3").value,
        first_element: selectedLawCellId[0],
        second_element: selectedLawCellId[1],
        third_element: selectedLawCellId[2],
        fourth_element: selectedLawCellId[3],
        id_type: document.getElementById("inputLawGroup3").value
      }
    }
    //console.log(newLaw)
    patchData(undefined, `${process.env.REACT_APP_API_LINK}/laws/${selectedLawState.selectedLaw.id_law}`, newLaw, headers, afterCreateLaw)
    
  }

  const selectLaw = (selectedLaw) => {


    //console.log(selectedLaw)

    const lawCells = [selectedLaw.first_element,selectedLaw.second_element,selectedLaw.third_element,selectedLaw.fourth_element]

    getAllCellData(lawCells,headers,afterSelectSearch,selectedLaw)
  }

  const afterSelectSearch = (cells,selectedLaw) => {

    selectedLawState.setSelectedLaw({law_name: selectedLaw.law_name,cells:cells,id_type:selectedLaw.id_type,id_law:selectedLaw.id_law})
  }

  const deleteLaw = (law) => {

    deleteData(undefined,`${process.env.REACT_APP_API_LINK}/laws/${law.id_law}`,headers,afterDeleteLaw)
  }

  const afterDeleteLaw = () => {
    setStateFromGetAPI(lawsState.setLaws, `${process.env.REACT_APP_API_LINK}/laws`,undefined,headers)
  }

  // dublicate, remove later
  const checkLaw = (cells) => {


    //console.log(cells)

    const firstThirdCellsMLTI = {
      M: cells[0].m_indicate_auto + cells[2].m_indicate_auto,
      L: cells[0].l_indicate_auto + cells[2].l_indicate_auto,
      T: cells[0].t_indicate_auto + cells[2].t_indicate_auto,
      I: cells[0].i_indicate_auto + cells[2].i_indicate_auto
    }



    const secondFourthCellsMLTI = {
      M: cells[1].m_indicate_auto + cells[3].m_indicate_auto,
      L: cells[1].l_indicate_auto + cells[3].l_indicate_auto,
      T: cells[1].t_indicate_auto + cells[3].t_indicate_auto,
      I: cells[1].i_indicate_auto + cells[3].i_indicate_auto
    }

    const sameMLTI = JSON.stringify(firstThirdCellsMLTI) === JSON.stringify(secondFourthCellsMLTI)

    return(sameMLTI)
  }

  const lawGroupsList = lawsGroupsState.lawsGroups.map(lawGroup => {

    const shownText = `${lawGroup.type_name}`

    return (
      <option key={lawGroup.id_type} value={lawGroup.id_type} dangerouslySetInnerHTML={{__html: shownText}}/>
    );

  });

  let lawsMarkup
  let lawsCounter = 0
  //console.log(lawsState.laws)
  if (lawsState.laws) {
    lawsMarkup = lawsState.laws.map(law => {
    lawsCounter += 1 

    const isCurrent = selectedLawState.selectedLaw.id_law === law.id_law

    return ( 
      <tr key={law.id_law}>
        <th scope="row" className='small-cell'>{isCurrent ? lawsCounter + `+` : lawsCounter}</th>
        <td>{law.law_name}</td>
        <td className='small-cell'><button type="button" className="btn btn-primary btn-sm" onClick={() => selectLaw(law)}>↓</button></td>
        <td className='small-cell'><button type="button" className="btn btn-danger btn-sm" onClick={() => deleteLaw(law)}>🗑</button></td>
      </tr>
    );
  })
  } else {lawsMarkup = null}

  return (
    <Modal
      modalVisibility={modalsVisibility.lawsModalVisibility}
      title={"Laws"}
      hasBackground={false}
      sizeX={600}
      >
      <div className="modal-content2">
        <div className="row">
          <div className="col-5">
            <input type="text" className="form-control" id="InputLawName3" placeholder="Law 1"/>
          </div>
          <div className="col-3">
          <button type="button" className="btn btn-primary" onClick={() => createLaw()}>create new</button>
          </div>
          <div className="col-4">
          <button type="button" className="btn btn-success" onClick={() => updateLaw()}>update current</button>
          </div>
        </div>
        <div className="row">
          <div className="col">
          <select className="form-select" aria-label="Default select example" id='inputLawGroup3'>
              {lawGroupsList}
            </select>
          </div>
        </div>

        <table className="table">
          <thead>
            <tr>
              <th scope="col">#</th>
              <th scope="col">Name</th>
              <th scope="col">Select</th>
              <th scope="col">Delete</th>
            </tr>
          </thead>
          <tbody>
            {lawsMarkup}
          </tbody>
        </table>
      </div>
      <div className="modal-footer2">
        <button type="button" className="btn btn-primary" onClick={() => modalsVisibility.lawsModalVisibility.setVisibility(false)}>Close</button>
      </div>

      </Modal>
  )
}

function TableViewsModal({modalsVisibility, tableViews, setTableViews,tableViewState}) {


  const userInfoState = useContext(UserProfile)
  const tableState = useContext(TableContext)  
  const headers = {
    Authorization: `Bearer ${userInfoState.userToken}`
  }      

  const selectTableView = (tableView) => {
    setStateFromGetAPI(undefined, `${process.env.REACT_APP_API_LINK}/active_view/${tableView.id_repr}`,afterSelectTableView,headers,tableView.id_repr)
  }

  const afterSelectTableView = (fullTableView,id_repr) => {


    tableViewState.setTableView({id_repr:id_repr,title:fullTableView.represent_title})
    tableState.setTableData(fullTableView.active_quantities)

    document.getElementById("InputTableViewName3").value = fullTableView.represent_title

    //modalsVisibility.tableViewsModalVisibility.setVisibility(false)
  }

  const updateTableView = () => {

    const cellIds = Object.values(tableState)[0].map(cell => cell.id_value)

    const tableViewTitle = document.getElementById("InputTableViewName3").value

    const newTableView = {
      title: tableViewTitle,
      active_quantities: cellIds,
    }

    putData(undefined,`${process.env.REACT_APP_API_LINK}/represents/${tableViewState.tableView.id_repr}`,newTableView,headers,afterCreateTableView)
  }

  const deleteTableView = (tableView) => {
    
    deleteData(undefined,`${process.env.REACT_APP_API_LINK}/represents/${tableView.id_repr}`,headers,afterDeleteTableView)
  }

  const afterDeleteTableView = () => {
    setStateFromGetAPI(setTableViews, `${process.env.REACT_APP_API_LINK}/represents`,undefined,headers)
  }

  const createTableView = () => {
    

    const cellIds = Object.values(tableState)[0].map(cell => cell.id_value)
    //console.log(cellIds)

    const tableViewTitle = document.getElementById("InputTableViewName3").value

    const newTableView = {
      title: tableViewTitle,
      active_quantities: cellIds,
    }

    postData(undefined, `${process.env.REACT_APP_API_LINK}/represents`, newTableView, headers, afterCreateTableView)

  }

  const afterCreateTableView = () => {
    setStateFromGetAPI(setTableViews, `${process.env.REACT_APP_API_LINK}/represents`,undefined,headers)
  }
  
  let tableViewsMarkup
  let tableViewsCounter = 0
  if (tableViews) {
    tableViewsMarkup = tableViews.map(tableView => {
    tableViewsCounter += 1 

    const isCurrent = tableView.id_repr === tableViewState.tableView.id_repr

    return (
      <tr key={tableView.id_repr}>
        <th scope="row" className='small-cell'>{isCurrent ? tableViewsCounter + `+` : tableViewsCounter}</th>
        <td>{tableView.title}</td>
        <td className='small-cell'><button type="button" className="btn btn-primary btn-sm" onClick={() => selectTableView(tableView)}>↓</button></td>
        <td className='small-cell'><button type="button" className="btn btn-danger btn-sm" onClick={() => deleteTableView(tableView)}>🗑</button></td>
      </tr>
    );
  })
  } else {tableViewsMarkup = null}



  return (
    <Modal
      modalVisibility={modalsVisibility.tableViewsModalVisibility}
      title={"Table views"}
      hasBackground={false}
      sizeX={600}
      >
      <div className="modal-content2">

      <div className="row">
        <div className="col-5">
          <input type="text" className="form-control" id="InputTableViewName3" placeholder="View 1"/>
        </div>
        <div className="col-3">
        <button type="button" className="btn btn-primary" onClick={() => createTableView()}>create new</button>
        </div>
        <div className="col-4">
        <button type="button" className="btn btn-success" onClick={() => updateTableView()}>update current</button>
        </div>
      </div>

      <table className="table">
        <thead>
          <tr>
            <th scope="col">#</th>
            <th scope="col">Name</th>
            <th scope="col">Select</th>
            <th scope="col">Delete</th>
          </tr>
        </thead>
        <tbody>
          {tableViewsMarkup}
        </tbody>
      </table>
      </div>
      <div className="modal-footer2">
        <button type="button" className="btn btn-primary" onClick={() => modalsVisibility.tableViewsModalVisibility.setVisibility(false)}>Close</button>
      </div>

      </Modal>
  )
}

function LawsGroupsModal({modalsVisibility,lawsGroupsState}) {

  const userInfoState = useContext(UserProfile)

  const headers = {
    Authorization: `Bearer ${userInfoState.userToken}`
  }    
  const lawsGroups = lawsGroupsState.lawsGroups
  const setLawsGroups = lawsGroupsState.setLawsGroups
  //console.log(lawsGroups)

  const [selectedLawGroup, setSelectedLawGroup] = useState({ type_name:null,id_type:null})

  const selectLawGroup = (group) => {
    setSelectedLawGroup(group)

    document.getElementById("InputLawGroupName3").value = group.type_name
  }

  const updateLawGroup = () => {

    const lawGroupName = document.getElementById("InputLawGroupName3").value

    const newLawGroup = {
      law_type: {
        type_name: lawGroupName
      }
    }

    putData(undefined,`${process.env.REACT_APP_API_LINK}/law_types/${selectedLawGroup.id_type}`,newLawGroup,headers,afterCreateLawGroup)
  }

  const deleteLawGroup = (group) => {
    
    deleteData(undefined,`${process.env.REACT_APP_API_LINK}/law_types/${group.id_type}`,headers,afterDeleteLawGroup)
  }

  const afterDeleteLawGroup = () => {

    setStateFromGetAPI(setLawsGroups, `${process.env.REACT_APP_API_LINK}/law_types`,undefined,headers)
  }

  const createLawGroup = () => {
    
    const lawGroupName = document.getElementById("InputLawGroupName3").value

    const newLawGroup = {
      law_type: {
        type_name: lawGroupName
      }
    }

    postData(undefined, `${process.env.REACT_APP_API_LINK}/law_types`, newLawGroup, headers, afterCreateLawGroup)

  }

  const afterCreateLawGroup = () => {
    setStateFromGetAPI(setLawsGroups, `${process.env.REACT_APP_API_LINK}/law_types`,undefined,headers)
  }
  
  let lawsGroupsMarkup
  let lawsGroupsCounter = 0
  if (lawsGroups) {
    lawsGroupsMarkup = lawsGroups.map(group => {
    lawsGroupsCounter += 1 

    const isCurrent = selectedLawGroup.id_type === group.id_type

    return (
      <tr key={group.id_type}>
        <th scope="row" className='small-cell'>{isCurrent ? lawsGroupsCounter + `+` : lawsGroupsCounter}</th>
        <td>{group.type_name}</td>
        <td className='small-cell'><button type="button" className="btn btn-primary btn-sm" onClick={() => selectLawGroup(group)}>↓</button></td>
        <td className='small-cell'><button type="button" className="btn btn-danger btn-sm" onClick={() => deleteLawGroup(group)}>🗑</button></td>
      </tr>
    );
  })
  } else {lawsGroupsMarkup = null}



  return (
    <Modal
      modalVisibility={modalsVisibility.lawsGroupsModalVisibility}
      title={"Laws groups"}
      hasBackground={false}
      sizeX={600}
      >
      <div className="modal-content2">

      <div className="row">
        <div className="col-5">
          <input type="text" className="form-control" id="InputLawGroupName3" placeholder="Group 1"/>
        </div>
        <div className="col-3">
        <button type="button" className="btn btn-primary" onClick={() => createLawGroup()}>create new</button>
        </div>
        <div className="col-4">
        <button type="button" className="btn btn-success" onClick={() => updateLawGroup()}>update current</button>
        </div>
      </div>

      <table className="table">
        <thead>
          <tr>
            <th scope="col">#</th>
            <th scope="col">Name</th>
            <th scope="col">Select</th>
            <th scope="col">Delete</th>
          </tr>
        </thead>
        <tbody>
          {lawsGroupsMarkup}
        </tbody>
      </table>
      </div>
      <div className="modal-footer2">
        <button type="button" className="btn btn-primary" onClick={() => modalsVisibility.lawsGroupsModalVisibility.setVisibility(false)}>Close</button>
      </div>

      </Modal>
  )
}

function GKColorModal({modalsVisibility,GKLayersState}) {

  const userInfoState = useContext(UserProfile)
  //const tableState = useContext(TableContext)  
  const headers = {
    Authorization: `Bearer ${userInfoState.userToken}`
  }    
  const GKLayers = GKLayersState.gkColors
  const setGKLayers = GKLayersState.setGkColors
  //console.log(gkColors)

  const [selectedBrightness, setSelectedBrightness] = useState([])

  useEffect(() => {

    if (GKLayers) {

      //console.log(GKLayers)
      setSelectedBrightness(GKLayers.map(layer => ({brightness: layer.gk_bright, id:layer.id_gk})))
    }

  }, [GKLayers]);

  //console.log(selectedColors)

  const updateGKLayers = () => {

    const changedLayersBright = selectedBrightness
      .filter(brightness => brightness.brightness !== GKLayers.find(layer => layer.id_gk === brightness.id).gk_bright)
    //const 
    const fullChangedLayers = GKLayers.map(layer => {

      const brightChange = changedLayersBright.find(brightness => brightness.id === layer.id_gk)
      if (brightChange !== undefined) {

        return {
          ...layer,
          gk_bright: brightChange.brightness
        }
      } else {return layer}

    })
    //console.log(fullChangedLayers)
    setGKLayers(fullChangedLayers)

    patchAllLayerData(changedLayersBright,headers,afterUpdateGKLayers)
    //putData(undefined,`${process.env.REACT_APP_API_LINK}/law_types/${selectedLawGroup.id_type}`,newLawGroup,headers,afterCreateLawGroup)
  }

  const afterUpdateGKLayers = (result) => {
    console.log(result)

  }

  let GKLayersMarkup
  let GKLayersCounter = 0
  if (GKLayers && selectedBrightness.length !== 0) {
    GKLayersMarkup = GKLayers.map(layer => {
    GKLayersCounter += 1 
    //console.log(selectedColors)

    //const inputColorRef = useRef(undefined)
    //const inputBrightnessElement = document.getElementById(`GKLayersRange${layer.id_gk}`)
    //const inputBrightness = inputBrightnessElement ? inputBrightnessElement.value : 50

    const layerBrightness = selectedBrightness.find(color => color.id === layer.id_gk)
    const adjustedSelectedColor = Color(layer.color).lighten(layerBrightness.brightness/50-1)

    const handleBrightnessChanges = (input,id_gk) => {
      console.log(input.target.value,id_gk)
      //console.log(selectedColors)
      setSelectedBrightness(selectedBrightness.filter(selectedColor => selectedColor.id !== id_gk).concat({brightness: parseInt(input.target.value), id:id_gk}))
    }



    return (
      <tr key={layer.id_gk}>
        <th scope="row" className='small-cell'>{GKLayersCounter}</th>
        <td>{layer.gk_name}</td>
        <td dangerouslySetInnerHTML={{__html: layer.gk_sign}}></td>
        <td><input type="color" className="form-control form-control-color disabled" value={`${adjustedSelectedColor.hex()}`} readOnly/></td>
        <td><input type="range" className="form-range" min="0" max="100" onChange={(input) => handleBrightnessChanges(input,layer.id_gk)} /></td>
      </tr>
    );
  })
  } else {GKLayersMarkup = null}



  return (
    <Modal
      modalVisibility={modalsVisibility.GKColorsEditModalVisibility}
      title={"GK Layers"}
      hasBackground={false}
      sizeX={600}
      >
      <div className="modal-content2">

      <table className="table">
        <thead>
          <tr>
            <th scope="col">#</th>
            <th scope="col">Name</th>
            <th scope="col">GK</th>
            <th scope="col">Current color</th>
            <th scope="col">Change color</th>
          </tr>
        </thead>
        <tbody>
          {GKLayersMarkup}
        </tbody>
      </table>
      </div>
      <div className="modal-footer2">
      <button type="button" className="btn btn-primary" onClick={() => updateGKLayers()}>Save</button>
        <button type="button" className="btn btn-primary" onClick={() => modalsVisibility.GKColorsEditModalVisibility.setVisibility(false)}>Close</button>
      </div>

      </Modal>
  )
}

function RegModal({modalVisibility, setUserToken}) {



  const register = async () => {

    // get email and password from fields
    const email = document.getElementById("InputEmail1").value
    const password = document.getElementById("InputPassword1").value

    const userData = {
      user: {
        email: email,
        password: password,

      }
    }

    // try to register
    const registerResponseData = await postDataToAPI(`${process.env.REACT_APP_API_LINK}/users/register`, userData)
    if (!isResponseSuccessful(registerResponseData)) {
      showMessage(registerResponseData.data.error,"error")
      return
    }

    // hide modal and show message
    modalVisibility.setVisibility(false)
    showMessage("Было выслано письмо подтверждения почты")
  }

  // on login function
  const login = async () => {

    // get email and password from fields
    const email = document.getElementById("InputEmail2").value
    const password = document.getElementById("InputPassword2").value
    const userLoginData = {
      user: {
        email: email,
        password: password,
      }
    }

    // try to log in 
    const loginResponse = await postDataToAPI(`${process.env.REACT_APP_API_LINK}/users/login`, userLoginData)
    console.log(loginResponse, loginResponse.data.error)     
    if (!isResponseSuccessful(loginResponse)) {
      showMessage(loginResponse.data.error,"error")
      return
    }

    // if succesful set user token
    const loginResponseData = loginResponse.data.data
    setUserToken(loginResponseData) 
    
    // hide modal and show message
    modalVisibility.setVisibility(false)
    showMessage("Авторизация успешна")    
  }


  const forgotPassword = async () => {

    // get email field
    const email = document.getElementById("InputEmail5").value

    const userData = {
      user: {
        email: email,
      }
    }

    // send password reset request
    const resetPasswordResponse = await postDataToAPI(`${process.env.REACT_APP_API_LINK}/users/reset`, userData,)
    if (!isResponseSuccessful(resetPasswordResponse)) {
      showMessage(resetPasswordResponse.data.error,"error")
      return
    }
    // show message
    showMessage("Письмо сброса пароля выслано")
  }


  return (
    <Modal
      modalVisibility={modalVisibility}
      title={"Регитстрация / Авторизация"}
      hasBackground={true}
      >
      <div className="modal-content2">

      <nav>
          <div className="nav nav-tabs" id="nav-tab" role="tablist">
              <button className="nav-link active" id="nav-login-tab" data-bs-toggle="tab" data-bs-target="#login" type="button" role="tab" aria-controls="login" aria-selected="true">Авторизация</button>
              <button className="nav-link" id="nav-register-tab" data-bs-toggle="tab" data-bs-target="#register" type="button" role="tab" aria-controls="register" aria-selected="false">Регистрация</button>
              <button className="nav-link" id="nav-forgot-password-tab" data-bs-toggle="tab" data-bs-target="#forgot-password" type="button" role="tab" aria-controls="forgot-password" aria-selected="false">Сброс пароля</button>
          </div>
      </nav>
      <div className="tab-content" id="nav-tabContent">
          <div className="tab-pane fade show active" id="login" role="tabpanel" aria-labelledby="login-tab" tabIndex="0">

              <div className="modal-content2">
                <label htmlFor="InputEmail2" className="form-label">Почта</label>
                <input type="email" className="form-control" id="InputEmail2" aria-describedby="emailHelp" placeholder="name@example.com"/>
                <label htmlFor="InputPassword2" className="form-label">Пароль</label>
                <input type="password" className="form-control" id="InputPassword2"/>
              </div>

              <div className="modal-footer2">
                  <button type="button" className="btn btn-primary" onClick={() => login()}>Отправить</button>
              </div>
          </div>
          <div className="tab-pane fade" id="register" role="tabpanel" aria-labelledby="register-tab" tabIndex="0">

              <div className="modal-content2">
                  <label htmlFor="InputEmail1" className="form-label">Почта</label>
                  <input type="email" className="form-control" id="InputEmail1" aria-describedby="emailHelp" placeholder="name@example.com"/>
                  <label htmlFor="InputPassword1" className="form-label">Пароль</label>
                  <input type="password" className="form-control" id="InputPassword1"/>
                  {/* <div id="passwordHelpBlock" className="form-text">
                      Your password must be 8-20 characters long.
                  </div> */}
              </div>


              <div className="modal-footer2">
                  <button type="button" className="btn btn-primary" onClick={() => register()}>Отправить</button>
              </div>
          </div>
          <div className="tab-pane fade" id="forgot-password" role="tabpanel" aria-labelledby="forgot-password-tab" tabIndex="0">

          <div className="modal-content2">
              <label htmlFor="InputEmail5" className="form-label">Почта</label>
              <input type="email" className="form-control" id="InputEmail5" aria-describedby="emailHelp" placeholder="name@example.com"/>
          </div>

          <div className="modal-footer2">
              <button type="button" className="btn btn-primary" onClick={() => forgotPassword()}>Отправить</button>
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

function showMessage(messages,type = "success") {

  // check if passed argument is array and if not then put it into array
  const messagesArray = Array.isArray(messages) ? messages : [messages]

  messagesArray.forEach(message => {
    if (type == "success") {
      toast.success(message, {
      position: "top-center",
      autoClose: 5000,
      hideProgressBar: true,
      closeOnClick: true,
      pauseOnHover: true,
      progress: undefined,
      theme: "colored",
    });
    }

    if (type == "error") {
      toast.error(message, {
      position: "top-center",
      autoClose: 5000,
      hideProgressBar: true,
      closeOnClick: true,
      pauseOnHover: true,
      progress: undefined,
      theme: "colored",
    });
    }

  })



}

function isResponseSuccessful(response) {
  if (response.status < 300) {return true}
  return false
}

function convertMarkdownToEditorState(stateFunction, markdown) {

  const blocksFromHtml = htmlToDraft(markdown);
  const { contentBlocks, entityMap } = blocksFromHtml;
  const contentState = ContentState.createFromBlockArray(contentBlocks, entityMap);
  stateFunction(EditorState.createWithContent(contentState))

}

function convertMarkdownFromEditorState(state) {

  const html = draftToMarkdown(convertToRaw(state.getCurrentContent()));
  return html
}

function convertToMLTI(M,L,T,I) {

  let MLTIHTMLString = ""
  if (M !== 0) {
    MLTIHTMLString += `M<sup>${M}</sup>`
  }
  if (L !== 0) {
    MLTIHTMLString += `L<sup>${L}</sup>`
  }
  if (T !== 0) {
    MLTIHTMLString += `T<sup>${T}</sup>`
  }
  if (I !== 0) {
    MLTIHTMLString += `I<sup>${I}</sup>`
  }
  return MLTIHTMLString
}


