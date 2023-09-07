import React,{useEffect,useState, useContext} from 'react';
import TableUI from '../components/Table2';
import Draggable from 'react-draggable';
import getData, { postData, putData, patchData, deleteData, getAllCellData} from '../components/api';
import { ToastContainer, toast } from 'react-toastify';
import { UserProfile } from '../components/Contexts.js';
import { EditorState, convertToRaw,  convertFromRaw , ContentState } from 'draft-js';
import { Editor } from 'react-draft-wysiwyg';
import { TableContext } from '../components/Contexts.js';

import draftToMarkdown from 'draftjs-to-markdown';
import htmlToDraft from 'html-to-draftjs';

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

    const modalsVisibility={regModalVisibility,editProfileModalVisibility,editCellModalVisibility,lawsModalVisibility,tableViewsModalVisibility}


    const [tableData, setTableData] = useState([]);
    const tableState = {tableData,setTableData}
    const [gkColors, setGkColors] = useState([]);
    const gkState = {gkColors, setGkColors}

    const [tableView, setTableView] = useState({id_repr:1,title:"Базовое"}); 
    const tableViewState = {tableView,setTableView}

    useEffect(() => {
      getData(setTableData, process.env.REACT_APP_QUANTITIES_LINK)
      getData(setGkColors,process.env.REACT_APP_GK_SETTINGS_LINK)
  
    }, []);

  

    const [selectedCell, setSelectedCell] = useState(null);
    const selectedCellState={selectedCell, setSelectedCell}

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
      const keyDownHandler = event => {
        //console.log('User pressed: ', event.key);
  
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

      if (selectedCell) {

        getData(null, `http://localhost:5000/api/quantities/${selectedCell.id_value}`, setEditorFromSelectedCell)
      }

    }, [selectedCell]);



    const setEditorFromSelectedCell = (cellData) => {


      convertMarkdownToEditorState(setCellNameEditor, cellData.value_name) 
      convertMarkdownToEditorState(setCellSymbolEditor, cellData.symbol) 
      convertMarkdownToEditorState(setCellUnitEditor, cellData.unit) 
      document.getElementById("inputL3").value = cellData.l_indicate
      document.getElementById("inputT3").value = cellData.t_indicate
      document.getElementById("inputGK3").value = cellData.id_gk

    }

    const convertMarkdownToEditorState = (stateFunction, markdown) => {


      const blocksFromHtml = htmlToDraft(markdown);
      const { contentBlocks, entityMap } = blocksFromHtml;
      const contentState = ContentState.createFromBlockArray(contentBlocks, entityMap);
      stateFunction(EditorState.createWithContent(contentState))

    }

    const [userToken, setUserToken] = useState(null)
    const [userProfile, setUserProfile] = useState(null)
    
    const userInfoState = {userToken, setUserToken,userProfile, setUserProfile}

    useEffect(() => {

      if (userProfile) {
        document.getElementById("InputEmail3").value = userProfile.email
        document.getElementById("InputFirstName3").value = userProfile.first_name
        document.getElementById("InputLastName3").value = userProfile.last_name
        document.getElementById("InputPatronymic3").value = userProfile.patronymic

        const headers = {
          Authorization: `Bearer ${userInfoState.userToken}`
        }    




        //getData(null, `http://localhost:5000/api/active_view`,testShow,headers)
        //getData(null, `http://localhost:5000/api/represents`,testShow,headers)

        getData(setTableViews, `http://localhost:5000/api/represents`,undefined,headers)
        getData(setLaws, `http://localhost:5000/api/laws`,testShow,headers)
        getData(setLawsGroups, `http://localhost:5000/api/law_types`,undefined,headers)
      }

    }, [userProfile]);


    const testShow = (result) => {

      console.log(result)
    }

    return (
        <UserProfile.Provider value={userInfoState}>
          <TableContext.Provider value={tableState}>
                <TableUI modalsVisibility={modalsVisibility} selectedCellState={selectedCellState} revStates={revStates} gkState={gkState} selectedLawState={selectedLawState}/>

                <div id="modal-mask" className='hidden'></div>                  
                  <RegModal modalsVisibility={modalsVisibility} setUserToken={setUserToken} setUserProfile={setUserProfile}/>               
                  {/* <EditProfileModal modalsVisibility={modalsVisibility}/> */}
                  <EditCellModal modalsVisibility={modalsVisibility} selectedCell={selectedCell} cellEditorsStates={cellEditorsStates} gkColors={gkColors}/>
                  <EditProfileModal modalsVisibility={modalsVisibility} userInfoState={userInfoState}/>
                  <LawsModal modalsVisibility={modalsVisibility} lawsState={lawsState} selectedLawState={selectedLawState} lawsGroupsState={lawsGroupsState}/>
                  <TableViewsModal modalsVisibility={modalsVisibility} tableViews={tableViews} setTableViews={setTableViews} tableViewState={tableViewState}/>
                  <LawsGroupsModal modalsVisibility={modalsVisibility} lawsGroupsState={lawsGroupsState}/>


                <ToastContainer />
          </TableContext.Provider>
        </UserProfile.Provider>
    );
}

function EditCellModal({modalsVisibility, selectedCell, cellEditorsStates, gkColors}) {

  const tableState = useContext(TableContext)

  const convertMarkdownFromEditorState = (state) => {

    let html = draftToMarkdown(convertToRaw(state.getCurrentContent()));
    return html
  }

  const applyChangesToCell = () => {

    modalsVisibility.editCellModalVisibility.setVisibility(false)

    const id_gk = parseInt(document.getElementById("inputGK3").value)

  
    const G_indicate = gkColors.find(gkLevel => gkLevel.id_gk === id_gk).g_indicate
    const K_indicate = gkColors.find(gkLevel => gkLevel.id_gk === id_gk).k_indicate
    const l_indicate = parseInt(document.getElementById("inputL3").value)
    const t_indicate = parseInt(document.getElementById("inputT3").value)

    const M_indicate = 0 - (G_indicate*-1+K_indicate)
    const L_indicate = l_indicate - G_indicate*3
    const T_indicate = t_indicate - G_indicate*-2
    const I_indicate = 0 - K_indicate*-1

    const newCell = {
      quantity: {
        val_name: convertMarkdownFromEditorState(cellEditorsStates.cellNameEditorState.value),
        symbol: convertMarkdownFromEditorState(cellEditorsStates.cellSymbolEditorState.value),
        unit: convertMarkdownFromEditorState(cellEditorsStates.cellUnitEditorState.value),
        l_indicate: l_indicate,
        t_indicate: t_indicate,
        id_gk: id_gk,
        m_indicate_auto: M_indicate,
        l_indicate_auto: L_indicate,
        t_indicate_auto: T_indicate,
        i_indicate_auto: I_indicate,
      }

    }


    //console.log(newCell)
    putData(null, `http://localhost:5000/api/quantities/${selectedCell.id_value}`, newCell, null, afterChangesToCell)
  }

  const afterChangesToCell = (cellData) => {

    //console.log(cellData)
    tableState.setTableData(tableState.tableData.filter(cell => cell.id_lt !== cellData.id_lt).filter(cell => cell.id_value !== selectedCell.id_value).concat(cellData))


   
  }

  const cellList = gkColors.map(gkLevel => {

    const shownText = `${gkLevel.gk_name}  ${gkLevel.gk_sign}`

    return (
      <option key={gkLevel.id_gk} value={gkLevel.id_gk} dangerouslySetInnerHTML={{__html: shownText}}/>
    );

  });

  return  (  
    <Modal
    modalVisibility={modalsVisibility.editCellModalVisibility}
    title={"Edit cell"}
    hasBackground={false}
    sizeX={650}
    >
    <div className="modal-content2">

      <div className="row">
      <div className="col-6">
        <label className="form-label">Name</label>
        <CellEditor editorState={cellEditorsStates.cellNameEditorState.value} setEditorState={cellEditorsStates.cellNameEditorState.set}/>
      </div>
      <div className="col-6">
        <label className="form-label">Symbol</label>
        <CellEditor editorState={cellEditorsStates.cellSymbolEditorState.value} setEditorState={cellEditorsStates.cellSymbolEditorState.set}/>
      </div>
      </div>
      <div className="row">
      <div className="col-6">
      <label htmlFor="InputFirstName3" className="form-label">Unit</label>
      <CellEditor editorState={cellEditorsStates.cellUnitEditorState.value} setEditorState={cellEditorsStates.cellUnitEditorState.set}/>
      </div>
      <div className="col">
      <label htmlFor="InputFirstName3" className="form-label">GK level</label>
      <select className="form-select" aria-label="Default select example" id='inputGK3'>
        {cellList}
      </select>

      </div>

      </div>
      <div className="row">
      <div className="col">
      <label className="form-label">L</label>
      <input type="number" min="-10" max="10" step="1" className="form-control" id="inputL3"/>
      </div>

      <div className="col">
      <label className="form-label">T</label>
      <input type="number" min="-10" step="1" className="form-control" id="inputT3"/>
      </div>

      </div>

    </div>
    <div className="modal-footer2">
      {/* <button type="button" className="btn btn-secondary" onClick={() => modalsVisibility.setCellModalVisibility(false)}>Close</button> */}
      <button type="button" className="btn btn-primary" onClick={() => applyChangesToCell()}>Edit</button>
    </div>

    </Modal>
  )
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

          toolbar={{
            options: ['inline', 'emoji', 'remove'],
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

function EditProfileModal({modalsVisibility, userInfoState}) {


  const editProfile = () => {

    const firstName = document.getElementById("InputFirstName3").value
    const lastName = document.getElementById("InputLastName3").value 
    const patronymic = document.getElementById("InputPatronymic3").value
    let password = document.getElementById("InputPassword3").value




    let newUserData = {
      user: {
        last_name: firstName,
        first_name: lastName,
        patronymic: patronymic,
      }
      
    }

    if (password !== "") {
      newUserData.user.password = password
    }

    //console.log(newUserData)

    const headers = {
      Authorization: `Bearer ${userInfoState.userToken}`
    }

    patchData(userInfoState.setUserProfile,`http://localhost:5000/api/update`,newUserData, headers , afterEditProfile)

  }

  const afterEditProfile = (newUserData) => {

    modalsVisibility.editProfileModalVisibility.setVisibility(false)

  }

  return (
    <Modal
      modalVisibility={modalsVisibility.editProfileModalVisibility}
      title={"Edit profile"}
      hasBackground={true}
      >
      <div className="modal-content2">

        <label htmlFor="InputEmail3" className="form-label">Email address</label>
        <input type="email" className="form-control" id="InputEmail3" aria-describedby="emailHelp" placeholder="name@example.com" disabled={true}/>
        <label htmlFor="InputLastName3" className="form-label">New password</label>
        <input type="password" className="form-control" id="InputPassword3" placeholder="Пароль"/>
        <label htmlFor="InputLastName3" className="form-label">Last name</label>
        <input type="text" className="form-control" id="InputLastName3" placeholder="Воронин"/>
        <label htmlFor="InputFirstName3" className="form-label">First name</label>
        <input type="text" className="form-control" id="InputFirstName3" placeholder="Александр"/>
        <label htmlFor="InputPatronymic3" className="form-label">Patronymic</label>
        <input type="text" className="form-control" id="InputPatronymic3" placeholder="Максимович"/>
            
      </div>
      <div className="modal-footer2">
                  {/* <button type="button" className="btn btn-secondary" onClick={() => modalsVisibility.setRegModalVisibility(false)}>Close</button> */}
                  <button type="button" className="btn btn-primary" onClick={() => editProfile()}>Edit</button>
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
    postData(undefined, `http://localhost:5000/api/laws`, newLaw, headers, afterCreateLaw)
    

  }
  
  const afterCreateLaw = () => {

    //console.log("success")
    getData(lawsState.setLaws, `http://localhost:5000/api/laws`,undefined,headers)
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
    patchData(undefined, `http://localhost:5000/api/laws/${selectedLawState.selectedLaw.id_law}`, newLaw, headers, afterCreateLaw)
    
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

    deleteData(undefined,`http://localhost:5000/api/laws/${law.id_law}`,headers,afterDeleteLaw)
  }

  const afterDeleteLaw = () => {
    getData(lawsState.setLaws, `http://localhost:5000/api/laws`,undefined,headers)
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
  if (lawsState.laws) {
    lawsMarkup = lawsState.laws.map(law => {
    lawsCounter += 1 

    // const lawCellsIds = [law.first_element,law.second_element,law.third_element,law.fourth_element]
    // const selectedLawCellIds = selectedLawState.selectedLaw.cells.map(cell => cell.id_value)
    //const isCurrent = false

    //console.log(selectedLawState.selectedLaw.id_type,law.id_type)
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
    getData(undefined, `http://localhost:5000/api/active_view/${tableView.id_repr}`,afterSelectTableView,headers,tableView.id_repr)
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

    putData(undefined,`http://localhost:5000/api/represents/${tableViewState.tableView.id_repr}`,newTableView,headers,afterCreateTableView)
  }

  const deleteTableView = (tableView) => {
    
    deleteData(undefined,`http://localhost:5000/api/represents/${tableView.id_repr}`,headers,afterDeleteTableView)
  }

  const afterDeleteTableView = () => {
    getData(setTableViews, `http://localhost:5000/api/represents`,undefined,headers)
  }

  const createTableView = () => {
    

    const cellIds = Object.values(tableState)[0].map(cell => cell.id_value)
    //console.log(cellIds)

    const tableViewTitle = document.getElementById("InputTableViewName3").value

    const newTableView = {
      title: tableViewTitle,
      active_quantities: cellIds,
    }

    postData(undefined, `http://localhost:5000/api/represents`, newTableView, headers, afterCreateTableView)

  }

  const afterCreateTableView = () => {
    getData(setTableViews, `http://localhost:5000/api/represents`,undefined,headers)
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

function LawsGroupsModal({modalsVisibility}) {

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

    //postData(setUserToken, process.env.REACT_APP_GK_LOGIN_LINK, userData, undefined, afterLogin)
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

    getData(setUserProfile, process.env.REACT_APP_GK_PROFILE_LINK, undefined, headers )
  }


  const register = () => {

      const email = document.getElementById("InputEmail1").value
      const password = document.getElementById("InputPassword1").value

      const userData = {
        user: {
          email: email,
          password: password,

        }
      }

      //console.log(userData)

      postData(undefined, process.env.REACT_APP_GK_REGISTER_LINK, userData, undefined, afterRegister)
      

  }

  const login = () => {


    const email = document.getElementById("InputEmail2").value
    const password = document.getElementById("InputPassword2").value
    const userLoginData = {
      user: {
        email: email,
        password: password,
      }
    }

    postData(setUserToken, process.env.REACT_APP_GK_LOGIN_LINK, userLoginData, undefined, afterLogin)
  }

  const forgotPassword = () => {

    const email = document.getElementById("InputEmail5").value

    const userData = {
      user: {
        email: email,
      }
    }

    //console.log(userData)
    postData(undefined, `http://localhost:5000/api/reset`, userData, undefined, afterForgotPassword)

   


  }

  const afterForgotPassword = () => {

    toast.success('Recovery email sent', {
      position: "top-center",
      autoClose: 5000,
      hideProgressBar: true,
      closeOnClick: true,
      pauseOnHover: true,
      progress: undefined,
      theme: "colored",
    });
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
              <button className="nav-link" id="nav-forgot-password-tab" data-bs-toggle="tab" data-bs-target="#forgot-password" type="button" role="tab" aria-controls="forgot-password" aria-selected="false">Forgot password?</button>
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
          <div className="tab-pane fade" id="forgot-password" role="tabpanel" aria-labelledby="forgot-password-tab" tabIndex="0">

          <div className="modal-content2">
              <label htmlFor="InputEmail5" className="form-label">Email address</label>
              <input type="email" className="form-control" id="InputEmail5" aria-describedby="emailHelp" placeholder="name@example.com"/>
          </div>

          <div className="modal-footer2">
              <button type="button" className="btn btn-primary" onClick={() => forgotPassword()}>Send</button>
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


