import React,{useEffect,useState, useContext, useRef} from 'react';

import TableUI from '../components/Table';
import Draggable from 'react-draggable';
import setStateFromGetAPI, { postData, putData, patchData, deleteData, 
  getDataFromAPI, postDataToAPI, putDataToAPI,patchDataToAPI,deleteDataFromAPI,getAllCellDataFromAPI} from '../misc/api.js';
import { ToastContainer, toast } from 'react-toastify';
import { UserProfile,TableContext } from '../misc/contexts.js';
import { EditorState, convertToRaw , ContentState } from 'draft-js';
import { Editor } from 'react-draft-wysiwyg';
import { Cell } from '../components/Table.js';
import Footbar from '../components/FootBar';
import { useDownloadableScreenshot } from '../misc/Screenshot.js';
import draftToMarkdown from 'draftjs-to-markdown';
import htmlToDraft from 'html-to-draftjs';
import { isResponseSuccessful } from '../misc/api';

import {IntlProvider} from 'react-intl'
import {FormattedMessage,createIntl,useIntl} from 'react-intl'
// const Color = require('color');

import translationEN from '../compiled-lang/en.json';
import translationRU from '../compiled-lang/ru.json';

function getTranslationMessages(locale) {


  if (locale === "en") {
    return translationEN
  }
  if (locale === "ru") {
    return translationRU
  }
}

export default function Home() {

  const [userToken, setUserToken] = useState(null)
  const [userProfile, setUserProfile] = useState(null)
  
  const userInfoState = {userToken, setUserToken,userProfile, setUserProfile}

  const [currentLocale, setCurrentLocale] = useState("ru")
  
  const currentLocaleState = {currentLocale, setCurrentLocale}
  const translatedMessages = getTranslationMessages(currentLocale)
  //console.log(currentLocale,translatedMessages)

  const intl = createIntl({
    locale: currentLocale,
    messages: translatedMessages,
  })

  useEffect(() => {

    if (userToken) {

      // set header for API queries
      const headers = {
        Authorization: `Bearer ${userToken}`
      }    

      // get all required data
      setStateFromGetAPI(setUserProfile, `${process.env.REACT_APP_API_LINK}/${intl.locale}/users/profile`, undefined, headers )
      setStateFromGetAPI(setGKLayers,`${process.env.REACT_APP_API_LINK}/${intl.locale}/gk`,undefined,headers)
      setStateFromGetAPI(setTableViews, `${process.env.REACT_APP_API_LINK}/${intl.locale}/represents`,undefined,headers)
      // fix later
      setStateFromGetAPI(setLaws, `${process.env.REACT_APP_API_LINK}/${intl.locale}/laws`,undefined,headers)
      setStateFromGetAPI(setLawsGroups, `${process.env.REACT_APP_API_LINK}/${intl.locale}/law_types`,undefined,headers)
      setStateFromGetAPI(setFullTableData,`${process.env.REACT_APP_API_LINK}/${intl.locale}/active_view`,undefined,headers)

      // set up localstorage to authenticate automatically
      localStorage.setItem('token', userToken);

    } else {
      // if there is no user token delete user profile
      setUserProfile(null)
    }

  }, [userToken]);

  useEffect(() => {

    if (currentLocale && userToken) {

      // set header for API queries
      const headers = {
        Authorization: `Bearer ${userToken}`
      }    

      console.log(intl.locale)
      // get all required localized data
      setStateFromGetAPI(setGKLayers,`${process.env.REACT_APP_API_LINK}/${intl.locale}/gk`,undefined,headers)
      setStateFromGetAPI(setTableViews, `${process.env.REACT_APP_API_LINK}/${intl.locale}/represents`,undefined,headers)
      setStateFromGetAPI(setLaws, `${process.env.REACT_APP_API_LINK}/${intl.locale}/laws`,undefined,headers)
      setStateFromGetAPI(setLawsGroups, `${process.env.REACT_APP_API_LINK}/${intl.locale}/law_types`,undefined,headers)
      setStateFromGetAPI(setFullTableData,`${process.env.REACT_APP_API_LINK}/${intl.locale}/active_view`,testShow,headers)


    }

  }, [currentLocale]);



  useEffect(() => {

    // if user profile is not null set edit form
    if (userProfile) {
      document.getElementById("InputEmail3").value = userProfile.email
      document.getElementById("InputFirstName3").value = userProfile.first_name
      document.getElementById("InputLastName3").value = userProfile.last_name
      document.getElementById("InputPatronymic3").value = userProfile.patronymic
      setCurrentLocale(userProfile.locale)
    } else {
      document.getElementById("InputEmail3").value = ""
      document.getElementById("InputFirstName3").value = ""
      document.getElementById("InputLastName3").value = ""
      document.getElementById("InputPatronymic3").value = ""
    }
  }, [userProfile]);



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

    const [isGKLayersImageModalVisible, setGKLayersImageModalVisibility] = useState(false);
    const GKLayersImageModalVisibility = {isVisible: isGKLayersImageModalVisible, setVisibility: setGKLayersImageModalVisibility}


    const modalsVisibility={regModalVisibility,editProfileModalVisibility,
                            editCellModalVisibility,lawsModalVisibility,
                            tableViewsModalVisibility,lawsGroupsModalVisibility
                            ,GKColorsEditModalVisibility,GKLayersImageModalVisibility}


    const [tableData, setTableData] = useState([]);
    const tableState = {tableData,setTableData}
    const [GKLayers, setGKLayers] = useState([]);
    const GKLayersState = {gkColors: GKLayers, setGkColors: setGKLayers}

    const [tableView, setTableView] = useState({id_repr:1,title:intl.formatMessage({id:`Базовое`,defaultMessage: `Базовое`})}); 
    const tableViewState = {tableView,setTableView}



    const setFullTableData = (result) => {

      setTableData(result.active_quantities)
      setTableView({id_repr:result.id_repr,title:result.title})
    }
    // get table and layers when page is loaded
    useEffect(() => {
      setStateFromGetAPI(setFullTableData,`${process.env.REACT_APP_API_LINK}/${intl.locale}/active_view`)
      setStateFromGetAPI(setGKLayers,`${process.env.REACT_APP_API_LINK}/${intl.locale}/gk`)

      async function logInByLocalStorage() {
        
        const storageToken = localStorage.getItem('token');
        if (storageToken) {
          const headers = {
            Authorization: `Bearer ${storageToken}`
          }   
  
          const profileResponseData = await getDataFromAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/users/profile`,headers)
          if (!isResponseSuccessful(profileResponseData)) {
            localStorage.removeItem('token')
            return
          }
          showMessage(intl.formatMessage({id:`Авторизация успешна`,defaultMessage: `Авторизация успешна`}))

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
         
          // if it is an empty cell
          if (selectedCell.id_value === -1) {

            convertMarkdownToEditorState(setCellNameEditor, "") 
            convertMarkdownToEditorState(setCellSymbolEditor, "") 
            convertMarkdownToEditorState(setCellUnitEditor, "") 
            document.getElementById("inputL3").value = selectedCell.l_indicate
            document.getElementById("inputT3").value = selectedCell.t_indicate
            document.getElementById("inputGK3").value = 0

            return
          }

          // get full data about cell
          const cellResponseData = await getDataFromAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/quantities/${selectedCell.id_value}`)
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


    const { ref, getImage } = useDownloadableScreenshot(intl);

    // DELETE LATER <------------------------
    
    const testShow = (result,_,info) => {

      // 
      console.log("input:",info)
      console.log("result:",result)
    }



    return (
      <IntlProvider
      locale={currentLocale}
      defaultLocale="ru"
      messages={translatedMessages}
      >
        <UserProfile.Provider value={userInfoState}>
          <TableContext.Provider value={tableState}>

                <TableUI modalsVisibility={modalsVisibility} selectedCellState={selectedCellState} revStates={revStates} gkState={GKLayersState} selectedLawState={selectedLawState} hoveredCellState={hoveredCellState} refTable={ref} lawsGroupsState={lawsGroupsState} lawsState={lawsState} currentLocaleState={currentLocaleState}/>
                <Footbar hoveredCell={hoveredCell} selectedLawState={selectedLawState} getImage={getImage} tableViewState={tableViewState} setTableViews={setTableViews} modalsVisibility={modalsVisibility}/>

                <div id="modal-mask" className='hidden'></div>                  
                <RegModal modalVisibility={modalsVisibility.regModalVisibility} setUserToken={setUserToken} currentLocaleState={currentLocaleState}/>               
                <EditCellModal modalVisibility={modalsVisibility.editCellModalVisibility} selectedCell={selectedCell} cellEditorsStates={cellEditorsStates} gkColors={GKLayers}/>
                <EditProfileModal modalsVisibility={modalsVisibility} userInfoState={userInfoState} currentLocaleState={currentLocaleState}/>
                <LawsModal modalsVisibility={modalsVisibility} lawsState={lawsState} selectedLawState={selectedLawState} lawsGroupsState={lawsGroupsState}/>
                <TableViewsModal modalsVisibility={modalsVisibility} tableViews={tableViews} setTableViews={setTableViews} tableViewState={tableViewState}/>
                <LawsGroupsModal modalsVisibility={modalsVisibility} lawsGroupsState={lawsGroupsState}/>
                <GKColorModal modalsVisibility={modalsVisibility} GKLayersState={GKLayersState}/>
                <GKLayersImageModal modalVisibility={modalsVisibility.GKLayersImageModalVisibility} />

                <ToastContainer />
          </TableContext.Provider>
        </UserProfile.Provider>
      </IntlProvider>
    );
}

function EditCellModal({modalVisibility, selectedCell, cellEditorsStates, gkColors}) {

  const tableState = useContext(TableContext)
  const userInfoState = useContext(UserProfile) 
  const headers = {
    Authorization: `Bearer ${userInfoState.userToken}`
  }  

  const intl = useIntl()

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
    const changedCellResponseData = await putDataToAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/quantities/${selectedCell.id_value}`, newCell, headers)
    if (!isResponseSuccessful(changedCellResponseData)) {
      showMessage(changedCellResponseData.data.error,"error")
      return
    }
    const cellData = changedCellResponseData.data.data

    // show message
    showMessage(intl.formatMessage({id:`Ячейка была изменена`,defaultMessage: `Ячейка была изменена`}))

    // remove old cell and set new one
    tableState.setTableData(tableState.tableData.filter(cell => cell.id_lt !== cellData.id_lt).concat(cellData))

    // send request to replace missing cell
    const cellAlternativesResponseData = await getDataFromAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/layers/${selectedCell.id_lt}`,headers)
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
    if (!window.confirm(intl.formatMessage({id:`Подтверждение действия`,defaultMessage: `Вы уверены что хотите это сделать? Это приведёт к последствиям для других пользователей.`}))) {
      return
    }

    // send delete request
    const cellDeleteResponseData = await deleteDataFromAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/quantities/${selectedCell.id_value}`,undefined,headers)
    if (!isResponseSuccessful(cellDeleteResponseData)) {
      showMessage(cellDeleteResponseData.data.error,"error")
      return
    }

    tableState.setTableData(tableState.tableData.filter(cell => cell.id_value !== selectedCell.id_value))

    // send request to replace missing cell
    const cellAlternativesResponseData = await getDataFromAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/layers/${selectedCell.id_lt}`,headers)
    if (!isResponseSuccessful(cellAlternativesResponseData)) {
      showMessage(cellAlternativesResponseData.data.error,"error")
      return
    }

    const cellAlternatives = cellAlternativesResponseData.data.data

    // replace missing cell if there is alternative
    if (cellAlternatives.length > 0) {
      tableState.setTableData(tableState.tableData.filter(cell => cell.id_value !== selectedCell.id_value).concat(cellAlternatives[0]))
    }


    // selectedCell.id_value
    showMessage(intl.formatMessage({id:`Ячейка удалена`,defaultMessage: `Ячейка удалена`}))

    // hide modal
    modalVisibility.setVisibility(false)

  }

  // generate gk layer list
  const cellList = gkColors.map(gkLevel => {


    const shownText = `${gkLevel.gk_name} G<sup>${gkLevel.g_indicate}</sup>K<sup>${gkLevel.k_indicate}</sup>`

    return (
      <option key={gkLevel.id_gk} value={gkLevel.id_gk} dangerouslySetInnerHTML={{__html: shownText}}/>
    );

  });

  const [previewCell, setPreviewCell] = useState({
    cellFullId:-1,
    cellData:{value_name:intl.formatMessage({id:`не выбрано`,defaultMessage: `не выбрано`}),symbol:"",unit:""},
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
          cellFullId:-1,
          cellData:{
            value_name: convertMarkdownFromEditorState(cellEditorsStates.cellNameEditorState.value),
            symbol: convertMarkdownFromEditorState(cellEditorsStates.cellSymbolEditorState.value),
            unit: convertMarkdownFromEditorState(cellEditorsStates.cellUnitEditorState.value),
            m_indicate_auto:M_indicate,
            l_indicate_auto:L_indicate,
            t_indicate_auto:T_indicate,
            i_indicate_auto:I_indicate,
            
          },
          cellColor: cellColor,
        }
      )

    }

  }

  return  (  
    <Modal
    modalVisibility={modalVisibility}
    title={intl.formatMessage({id:`Редактирование величины`,defaultMessage: `Редактирование величины`})}
    hasBackground={false}
    sizeX={650}
    >
    <div className="modal-content2">
    <div className="row">
      <details>
        <summary><FormattedMessage id='Превью' defaultMessage="Превью"/></summary>
        <Cell cellFullData={previewCell} />
      </details>
    </div>
      <div className="row">
      <div className="col-6">
        <label className="form-label"><FormattedMessage id='Имя' defaultMessage="Имя"/></label>
        <RichTextEditor editorState={cellEditorsStates.cellNameEditorState.value} setEditorState={cellEditorsStates.cellNameEditorState.set}/>
      </div>
      <div className="col-6">
        <label className="form-label"><FormattedMessage id='Условное обозначение' defaultMessage="Условное обозначение"/></label>
        <RichTextEditor editorState={cellEditorsStates.cellSymbolEditorState.value} setEditorState={cellEditorsStates.cellSymbolEditorState.set}/>
      </div>
      </div>
      <div className="row">
      <div className="col-6">
      <label htmlFor="InputFirstName3" className="form-label"><FormattedMessage id='Единица измерения' defaultMessage="Единица измерения"/></label>
      <RichTextEditor editorState={cellEditorsStates.cellUnitEditorState.value} setEditorState={cellEditorsStates.cellUnitEditorState.set}/>
      </div>
      <div className="col">
      <label htmlFor="InputFirstName3" className="form-label"><FormattedMessage id='Уровень' defaultMessage="Уровень"/> GK</label>
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
      <button type="button" className="btn btn-danger" onClick={() => deleteCell()}><FormattedMessage id='Удалить' defaultMessage="Удалить"/></button>
      <button type="button" className="btn btn-success" onClick={() => updateCell()}><FormattedMessage id='Сохранить' defaultMessage="Сохранить"/></button>
    </div>

    </Modal>
  )
}

function RichTextEditor({editorState,setEditorState}) {

  const intl = useIntl()

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
                title: intl.formatMessage({id:`Алфавит`,defaultMessage: `Алфавит`}),
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

function EditProfileModal({modalsVisibility,currentLocaleState}) {

  const modalVisibility = modalsVisibility.editProfileModalVisibility
  const userInfoState = useContext(UserProfile) 
  const headers = {
    Authorization: `Bearer ${userInfoState.userToken}`
  }      

  const intl = useIntl()

  const editProfile = async () => {

    // get values from fields
    const firstName = document.getElementById("InputFirstName3").value
    const lastName = document.getElementById("InputLastName3").value 
    const patronymic = document.getElementById("InputPatronymic3").value
    const password = document.getElementById("InputPassword3").value
    const locale = currentLocaleState.currentLocale

    let newUserData = {
      user: {
        last_name: lastName,
        first_name: firstName,
        patronymic: patronymic,
        locale: locale,
      }
      
    }

    // if new password field is not empty add it to json
    if (password !== "") {
      newUserData.user.password = password
    }

    // send profile update request
    const editUserResponse = await patchDataToAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/users/update`,newUserData,headers)
    if (!isResponseSuccessful(editUserResponse)) {
      showMessage(editUserResponse.data.error,"error")
      return
    }
   
    // hide modal
    modalVisibility.setVisibility(false)
    showMessage(intl.formatMessage({id:`Профиль обновлён`,defaultMessage: `Профиль обновлён`}))

    // empty input fields
    document.getElementById("InputEmail2").value = ""
    document.getElementById("InputPassword2").value = ""
    document.getElementById("InputEmail1").value = ""
    document.getElementById("InputPassword1").value = ""

  }

  const deleteUser = async () => {
    if (!window.confirm("Вы уверены что хотите удалить аккаунт? Это приведёт к потере всех ваших данных.")) {
      return
    }

    // send delete request
    const deleteUserResponse = await deleteDataFromAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/delete`,undefined,headers)
    if (!isResponseSuccessful(deleteUserResponse)) {
      showMessage(deleteUserResponse.data.error,"error")
      return
    }
    // show message and delete user token
    showMessage(intl.formatMessage({id:`Аккаунт удалён`,defaultMessage: `Аккаунт удалён`}))
    userInfoState.setUserToken(null)

  }

  return (
    <Modal
      modalVisibility={modalVisibility}
      title={intl.formatMessage({id:`Редактирование профиля`,defaultMessage: `Редактирование профиля`})}
      hasBackground={true}
      >
      <div className="modal-content2">

        <label htmlFor="InputEmail3" className="form-label"><FormattedMessage id='Почта' defaultMessage="Почта"/></label>
        <input type="email" className="form-control" id="InputEmail3" aria-describedby="emailHelp" placeholder="name@example.com" disabled={true}/>
        <label htmlFor="InputLastName3" className="form-label"><FormattedMessage id='Новый пароль' defaultMessage="Новый пароль"/></label>
        <input type="password" className="form-control" id="InputPassword3"/>
        <label htmlFor="InputLastName3" className="form-label"><FormattedMessage id='Фамилия' defaultMessage="Фамилия"/></label>
        <input type="text" className="form-control" id="InputLastName3"/>
        <label htmlFor="InputFirstName3" className="form-label"><FormattedMessage id='Имя' defaultMessage="Имя"/></label>
        <input type="text" className="form-control" id="InputFirstName3"/>
        <label htmlFor="InputPatronymic3" className="form-label"><FormattedMessage id='Отчество' defaultMessage="Отчество"/></label>
        <input type="text" className="form-control" id="InputPatronymic3" />
            
      </div>
      <div className="modal-footer2">
        <button type="button" className="btn btn-danger" onClick={() => deleteUser()}><FormattedMessage id='Удалить аккаунт' defaultMessage="Удалить аккаунт"/></button>
        <button type="button" className="btn btn-success" onClick={() => editProfile()}><FormattedMessage id='Сохранить' defaultMessage="Сохранить"/></button>
      </div>

      </Modal>
  )
}

function LawsModal({modalsVisibility, lawsState, selectedLawState, lawsGroupsState}) {

  const tableState = useContext(TableContext)
  const userInfoState = useContext(UserProfile) 
  const headers = {
    Authorization: `Bearer ${userInfoState.userToken}`
  }  

  const intl = useIntl()

  const createLaw = () => {

    if (lawsState.lawsGroups === undefined) {
      setStateFromGetAPI(undefined, `${process.env.REACT_APP_API_LINK}/${intl.locale}/laws`,undefined,headers)

    }

    if (selectedLawState.selectedLaw.cells.length !== 4) {
      return
    }
    if (!checkLaw(selectedLawState.selectedLaw.cells)) {
      return
    }
    const selectedLawCellId = selectedLawState.selectedLaw.cells.map(cell => cell.id_value)



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

    postData(undefined, `${process.env.REACT_APP_API_LINK}/${intl.locale}/laws`, newLaw, headers, afterCreateLaw)
    



  }
  
  const afterCreateLaw = () => {


    setStateFromGetAPI(lawsState.setLaws, `${process.env.REACT_APP_API_LINK}/${intl.locale}/laws`,undefined,headers)
  }


  const updateLaw = () => {
    if (selectedLawState.selectedLaw.cells.length !== 4) {
      return
    }
    if (!checkLaw(selectedLawState.selectedLaw.cells)) {
      return
    }
    const selectedLawCellId = selectedLawState.selectedLaw.cells.map(cell => cell.id_value)





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

    patchData(undefined, `${process.env.REACT_APP_API_LINK}/${intl.locale}/laws/${selectedLawState.selectedLaw.id_law}`, newLaw, headers, afterCreateLaw)
    
  }



  const selectLaw = async (selectedLaw) => {


    const lawCellsIds = [selectedLaw.first_element,selectedLaw.second_element,selectedLaw.third_element,selectedLaw.fourth_element]
   
    const lawCellsResponse = await getAllCellDataFromAPI(lawCellsIds,headers)
    if (!isResponseSuccessful(lawCellsResponse[0])) {
      showMessage(lawCellsResponse[0].data.error,"error")
      return
    }
    const lawCells = lawCellsResponse.map(cellResponse => cellResponse.data.data)

    selectedLawState.setSelectedLaw({law_name: selectedLaw.law_name,cells:lawCells,id_type:selectedLaw.id_type,id_law:selectedLaw.id_law})


    let newTable = tableState.tableData
    lawCells.forEach(cellData => {

      newTable = newTable.filter(cell => cell.id_lt !== cellData.id_lt).concat(cellData)
    })

    tableState.setTableData(newTable)
  }

  const deleteLaw = (law) => {

    deleteData(undefined,`${process.env.REACT_APP_API_LINK}/${intl.locale}/laws/${law.id_law}`,headers,afterDeleteLaw)
  }

  const afterDeleteLaw = () => {
    setStateFromGetAPI(lawsState.setLaws, `${process.env.REACT_APP_API_LINK}/${intl.locale}/laws`,undefined,headers)
  }

  // dublicate, remove later
  const checkLaw = (cells) => {




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

  const chooseOption = <option key={-1} value={-1} dangerouslySetInnerHTML={{__html: intl.formatMessage({id:`Выберите опцию`,defaultMessage: `Выберите опцию`})}}/>

  const lawsGroupList = lawsGroupsState.lawsGroups.map(lawGroup => {

    const shownText = `${lawGroup.type_name}`

    return (
      <option key={lawGroup.id_type} value={lawGroup.id_type} dangerouslySetInnerHTML={{__html: shownText}}/>
    );

  });
  const allOptions = [chooseOption,...lawsGroupList]

  let lawsMarkup
  if (lawsState.laws) {
    lawsMarkup = lawsState.laws.map(law => {

    const isCurrent = selectedLawState.selectedLaw.id_law === law.id_law

    return ( 
      <tr key={law.id_law}>
        <th scope="row" className='small-cell'>{isCurrent ?  `+` : ''}</th>
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
      title={intl.formatMessage({id:`Законы`,defaultMessage: `Законы`})}
      hasBackground={false}
      sizeX={600}
      >
      <div className="modal-content2">
        <div className="row">
          <div className="col-2">
            <FormattedMessage id='Название' defaultMessage="Название"/>:
          </div>
          <div className="col-5">
            <input type="text" className="form-control" id="InputLawName3" placeholder="Мой закон"/>
          </div>
          <div className="col-2">
          <button type="button" className="btn btn-success" onClick={() => createLaw()}><FormattedMessage id='Создать' defaultMessage="Создать"/></button>
          </div>
          <div className="col-3">
          <button type="button" className="btn btn-info" onClick={() => updateLaw()}><FormattedMessage id='Обновить' defaultMessage="Обновить"/></button>
          </div>
        </div>
        <div className="row">
        <div className="col-2">
          <FormattedMessage id='Группы' defaultMessage="Группы"/>:
        </div>
          <div className="col-5">
          <select className="form-select" aria-label="Default select example" id='inputLawGroup3'>
              {allOptions}
            </select>
          </div>
        </div>

        <table className="table">
          <thead>
            <tr>
              <th scope="col">#</th>
              <th scope="col"><FormattedMessage id='Название' defaultMessage="Название"/></th>
              <th scope="col"><FormattedMessage id='Выбрать' defaultMessage="Выбрать"/></th>
              <th scope="col"><FormattedMessage id='Удалить' defaultMessage="Удалить"/></th>
            </tr>
          </thead>
          <tbody>
            {lawsMarkup}
          </tbody>
        </table>
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

  const intl = useIntl()
  
  const [tableViewEditorState, setTableViewEditorState] = useState(EditorState.createEmpty())

  const selectTableView = async (tableView) => {

    // send full table view data request
    const tableViewDataResponse = await getDataFromAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/active_view/${tableView.id_repr}`,headers)
    if (!isResponseSuccessful(tableViewDataResponse)) {
      showMessage(tableViewDataResponse.data.error,"error")
      return
    }
    const tableViewData = tableViewDataResponse.data.data

    // set it as selected
    tableViewState.setTableView({id_repr:tableView.id_repr,title:tableViewData.title})
    tableState.setTableData(tableViewData.active_quantities)

    // change input to current table view name
    convertMarkdownToEditorState(setTableViewEditorState, tableViewData.title) 

  }

  const updateTableView = async () => {

    // get all current visible cells ids
    const cellIds = Object.values(tableState)[0].map(cell => cell.id_value)

    // get new table view name
    const tableViewTitle = convertMarkdownFromEditorState(tableViewEditorState)

    const newTableView = {
      title: tableViewTitle,
      active_quantities: cellIds,
    }
  
    // send table view update request
    const changedTableViewResponseData = await putDataToAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/represents/${tableViewState.tableView.id_repr}`,newTableView,headers)
    if (!isResponseSuccessful(changedTableViewResponseData)) {
      showMessage(changedTableViewResponseData.data.error,"error")
      return
    }

    // update current table views
    setStateFromGetAPI(setTableViews, `${process.env.REACT_APP_API_LINK}/${intl.locale}/represents`,undefined,headers)

    // show message
    showMessage(intl.formatMessage({id:`Представление обновлено`,defaultMessage: `Представление обновлено`}))
  
  }

  const deleteTableView = async (tableView) => {

    // send delete request
    const tableViewDeleteResponseData = await deleteDataFromAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/represents/${tableView.id_repr}`,undefined,headers)
    if (!isResponseSuccessful(tableViewDeleteResponseData)) {
      showMessage(tableViewDeleteResponseData.data.error,"error")
      return
    }

    // update current table views
    setStateFromGetAPI(setTableViews, `${process.env.REACT_APP_API_LINK}/${intl.locale}/represents`,undefined,headers)

    // show message
    showMessage(intl.formatMessage({id:`Представление удалено`,defaultMessage: `Представление удалено`}))
  
  }

  const createTableView = async () => {
    
    // fix filter later
    // get all current visible cells ids
    const cellIds = Object.values(tableState)[0].map(cell => cell.id_value).filter(id => id !== -1)

    // get new table view name
    const tableViewTitle = convertMarkdownFromEditorState(tableViewEditorState)

    const newTableView = {
      title: tableViewTitle,
      active_quantities: cellIds,
    }
    // send table view create request
    const newTableViewResponseData = await postDataToAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/represents`, newTableView, headers)
    if (!isResponseSuccessful(newTableViewResponseData)) {
      showMessage(newTableViewResponseData.data.error,"error")
      return
    }

    // update current table views
    setStateFromGetAPI(setTableViews, `${process.env.REACT_APP_API_LINK}/${intl.locale}/represents`,undefined,headers)

    // show message
    showMessage(intl.formatMessage({id:`Представление создано`,defaultMessage: `Представление создано`}))

  }

  
  let tableViewsMarkup = null
  if (tableViews) {
    tableViewsMarkup = tableViews.map(tableView => {

    const isCurrent = tableView.id_repr === tableViewState.tableView.id_repr

    return (
      <tr key={tableView.id_repr}>
        <th scope="row" className='small-cell'>{isCurrent ?  `+` : ''}</th>
        <td dangerouslySetInnerHTML={{__html: tableView.title}}></td>
        <td className='small-cell'><button type="button" className="btn btn-primary btn-sm" onClick={() => selectTableView(tableView)}>↓</button></td>
        <td className='small-cell'><button type="button" className="btn btn-danger btn-sm" onClick={() => deleteTableView(tableView)}>🗑</button></td>
      </tr>
    );
  })
  }



  return (
    <Modal
      modalVisibility={modalsVisibility.tableViewsModalVisibility}
      title={intl.formatMessage({id:`Представления ФВ`,defaultMessage: `Представления ФВ`})}
      hasBackground={false}
      sizeX={600}
      >
      <div className="modal-content2">

      <div className="row">
      <div className="col-2">
            <FormattedMessage id='Название' defaultMessage="Название"/>:
      </div>
        <div className="col-5">
          <RichTextEditor editorState={tableViewEditorState} setEditorState={setTableViewEditorState}/>
        </div>
        <div className="col-2">
        <button type="button" className="btn btn-success" onClick={() => createTableView()}><FormattedMessage id='Создать' defaultMessage="Создать"/></button>
        </div>
        <div className="col-3">
        <button type="button" className="btn btn-info" onClick={() => updateTableView()}><FormattedMessage id='Обновить' defaultMessage="Обновить"/></button>
        </div>
      </div>
      <table className="table">
        <thead>
          <tr>
            <th scope="col">#</th>
            <th scope="col"><FormattedMessage id='Название' defaultMessage="Название"/></th>
            <th scope="col"><FormattedMessage id='Выбрать' defaultMessage="Выбрать"/></th>
            <th scope="col"><FormattedMessage id='Удалить' defaultMessage="Удалить"/></th>
          </tr>
        </thead>
        <tbody>
          {tableViewsMarkup}
        </tbody>
      </table>
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

  // define current law group and editor state
  const [selectedLawGroup, setSelectedLawGroup] = useState({ type_name:null,id_type:null})
  const [lawGroupEditorState, setLawGroupEditorState] = useState(EditorState.createEmpty())

  const intl = useIntl()

  const selectLawGroup = (group) => {
   
    // set this group as selected
    setSelectedLawGroup(group)

    // set input to this group values
    convertMarkdownToEditorState(setLawGroupEditorState, group.type_name) 
    document.getElementById("InputLawGroupColor3").value = group.color

  }

  const updateLawGroup = async () => {

    // get current input values
    const lawGroupName = convertMarkdownFromEditorState(lawGroupEditorState)
    const lawGroupColor = document.getElementById("InputLawGroupColor3").value

    const newLawGroup = {
      law_type: {
        type_name: lawGroupName,
        color: lawGroupColor,
      }
    }
  
    // send group update request
    const changedGroupResponseData = await putDataToAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/law_types/${selectedLawGroup.id_type}`,newLawGroup,headers)
    if (!isResponseSuccessful(changedGroupResponseData)) {
      showMessage(changedGroupResponseData.data.error,"error")
      return
    }

    // update current groups
    setStateFromGetAPI(setLawsGroups, `${process.env.REACT_APP_API_LINK}/${intl.locale}/law_types`,undefined,headers)

    // show message
    showMessage(intl.formatMessage({id:`Группа была обновлена`,defaultMessage: `Группа была обновлена`}))

  }

  const deleteLawGroup = async (group) => {
    if (!window.confirm(intl.formatMessage({id:`Подтверждение действия`,defaultMessage: `Вы уверены что хотите это сделать? Это приведёт к последствиям для других пользователей.`}))) {
      return
    }
    
    //deleteData(undefined,`${process.env.REACT_APP_API_LINK}/${intl.locale}/law_types/${group.id_type}`,headers,afterDeleteLawGroup)
  
    // send delete group request
    const groupDeleteResponseData = await deleteDataFromAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/law_types/${group.id_type}`,undefined,headers)
    if (!isResponseSuccessful(groupDeleteResponseData)) {
      showMessage(groupDeleteResponseData.data.error,"error")
      return
    }

    // update current groups
    setStateFromGetAPI(setLawsGroups, `${process.env.REACT_APP_API_LINK}/${intl.locale}/law_types`,undefined,headers)
   
    // show message
    showMessage(intl.formatMessage({id:`Группа была удалена`,defaultMessage: `Группа была удалена`}))
  
  }

  const createLawGroup = async () => {
    
    // get current input values
    const lawGroupName = convertMarkdownFromEditorState(lawGroupEditorState)
    const lawGroupColor = document.getElementById("InputLawGroupColor3").value

    const newLawGroup = {
      law_type: {
        type_name: lawGroupName,
        color: lawGroupColor,
      }
    }


    const newGroupResponseData = await postDataToAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/law_types`,newLawGroup,headers)
    if (!isResponseSuccessful(newGroupResponseData)) {
      showMessage(newGroupResponseData.data.error,"error")
      return
    }

    setStateFromGetAPI(setLawsGroups, `${process.env.REACT_APP_API_LINK}/${intl.locale}/law_types`,undefined,headers)

    setLawGroupEditorState(EditorState.createEmpty())
    document.getElementById("InputLawGroupColor3").value = "#FF0000"

    showMessage(intl.formatMessage({id:`Группа была создана`,defaultMessage: `Группа была создана`}))

  }

  let lawsGroupsMarkup
  if (lawsGroups) {
    lawsGroupsMarkup = lawsGroups.map(group => {

    const isCurrent = selectedLawGroup.id_type === group.id_type

    return (
      <tr key={group.id_type}>
        <th scope="row" className='small-cell'>{isCurrent ?  `+` : ''}</th>
        <td dangerouslySetInnerHTML={{__html: group.type_name}}></td>
        <td><input type="color" className="form-control form-control-color disabled" value={group.color} readOnly onClick={(e) => {e.preventDefault()}}/></td>
        <td className='small-cell'><button type="button" className="btn btn-primary btn-sm" onClick={() => selectLawGroup(group)}>↓</button></td>
        <td className='small-cell'><button type="button" className="btn btn-danger btn-sm" onClick={() => deleteLawGroup(group)}>🗑</button></td>
      </tr>
    );
  })
  } else {lawsGroupsMarkup = null}



  return (
    <Modal
      modalVisibility={modalsVisibility.lawsGroupsModalVisibility}
      title={intl.formatMessage({id:`Группы законов`,defaultMessage: `Группы законов`})}
      hasBackground={false}
      sizeX={600}
      >
      <div className="modal-content2">

      <div className="row">
      <div className="col-2">
            <FormattedMessage id='Название' defaultMessage="Название"/>:
      </div>
        <div className="col-5">
          <RichTextEditor editorState={lawGroupEditorState} setEditorState={setLawGroupEditorState}/>

        </div>
        <div className="col-2">
        <button type="button" className="btn btn-success" onClick={() => createLawGroup()}><FormattedMessage id='Создать' defaultMessage="Создать"/></button>
        </div>
        <div className="col-3">
        <button type="button" className="btn btn-info" onClick={() => updateLawGroup()}><FormattedMessage id='Обновить' defaultMessage="Обновить"/></button>
        </div>
      </div>
      <div className="row">
      <div className="col-2">
            <FormattedMessage id='Цвет' defaultMessage="Цвет"/>:
      </div>
        <div className="col-5">
          <input type="color" className="form-control form-control-color"  id="InputLawGroupColor3" />
        </div>
      </div>

        <table className="table">
        <thead>
          <tr>
            <th scope="col">#</th>
            <th scope="col"><FormattedMessage id='Название' defaultMessage="Название"/></th>
            <th scope="col"><FormattedMessage id='Цвет' defaultMessage="Цвет"/></th>
            <th scope="col"><FormattedMessage id='Выбрать' defaultMessage="Выбрать"/></th>
            <th scope="col"><FormattedMessage id='Удалить' defaultMessage="Удалить"/></th>
          </tr>
        </thead>
        <tbody>
          {lawsGroupsMarkup}
        </tbody>
        </table>


      </div>

      </Modal>
  )
}

function GKColorModal({modalsVisibility,GKLayersState}) {

  const userInfoState = useContext(UserProfile)

  const headers = {
    Authorization: `Bearer ${userInfoState.userToken}`
  }    
  const GKLayers = GKLayersState.gkColors
  const setGKLayers = GKLayersState.setGkColors

  const [selectedGKLayer, setSelectedGKLayer] = useState({ type_name:null,id_type:null})
  const [GKLayerEditorState, setGKLayerEditorState] = useState(EditorState.createEmpty())

  const intl = useIntl()

  const selectGKLayer = (layer) => {
   
    // set this group as selected
    setSelectedGKLayer(layer)

    // set input to this group values
    convertMarkdownToEditorState(setGKLayerEditorState, layer.gk_name) 
    document.getElementById("InputGKLayerColor3").value = layer.color

  }

  const updateLawGroup = async () => {

    // get current input values
    const GKLayerName = convertMarkdownFromEditorState(GKLayerEditorState)
    const GKLayerColor = document.getElementById("InputGKLayerColor3").value

    const newLawGroup = {
      gk: {
        gk_name: GKLayerName,
        color: GKLayerColor,
      }
    }
  
    // send group update request
    const changedGKLayerResponseData = await putDataToAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/gk/${selectedGKLayer.id_gk}`,newLawGroup,headers)
    if (!isResponseSuccessful(changedGKLayerResponseData)) {
      showMessage(changedGKLayerResponseData.data.error,"error")
      return
    }

    // update current groups
    setStateFromGetAPI(setGKLayers, `${process.env.REACT_APP_API_LINK}/${intl.locale}/gk`,undefined,headers)

    // show message
    showMessage(intl.formatMessage({id:`Системный уровень обновлен`,defaultMessage: `Системный уровень обновлен`}))

  }

  let GKLayersMarkup
  if (GKLayers) {
    GKLayersMarkup = GKLayers.map(GKLayer => {

    const isCurrent = selectedGKLayer.id_gk === GKLayer.id_gk

    return (
      <tr key={GKLayer.id_gk}>
        <th scope="row" className='small-cell'>{isCurrent ? `+` : ""}</th>
        <td dangerouslySetInnerHTML={{__html: GKLayer.gk_name}}></td>        
        <td>G<sup>{GKLayer.g_indicate}</sup>K<sup>{GKLayer.k_indicate}</sup></td>
        <td><input type="color" className="form-control form-control-color disabled" value={GKLayer.color} readOnly onClick={(e) => {e.preventDefault()}}/></td>
        <td className='small-cell'><button type="button" className="btn btn-primary btn-sm" onClick={() => selectGKLayer(GKLayer)}>↓</button></td>
      </tr>
    );
  })
  } else {GKLayersMarkup = null}



  return (
    <Modal
      modalVisibility={modalsVisibility.GKColorsEditModalVisibility}
      title={intl.formatMessage({id:`Системные уровни`,defaultMessage: `Системные уровни`})}
      hasBackground={false}
      sizeX={600}
      >
      <div className="modal-content2">

      <div className="row">
      <div className="col-2">
            <FormattedMessage id='Название' defaultMessage="Название"/>:
      </div>
        <div className="col-5">
          <RichTextEditor editorState={GKLayerEditorState} setEditorState={setGKLayerEditorState}/>
        </div>
        <div className="col-2">
        <button type="button" className="btn btn-info" onClick={() => updateLawGroup()}><FormattedMessage id='Обновить' defaultMessage="Обновить"/></button>
        </div>
      </div>
      <div className="row">
      <div className="col-2">
            <FormattedMessage id='Цвет' defaultMessage="Цвет"/>:
      </div>
        <div className="col-5">
        <input type="color" className="form-control form-control-color"  id="InputGKLayerColor3" />
        </div>
      </div>

        <table className="table">
        <thead>
          <tr>
            <th scope="col">#</th>
            <th scope="col"><FormattedMessage id='Имя' defaultMessage="Имя"/></th>
            <th scope="col">GK</th>
            <th scope="col"><FormattedMessage id='Цвет' defaultMessage="Цвет"/></th>
            <th scope="col"><FormattedMessage id='Выбрать' defaultMessage="Выбрать"/></th>
          </tr>
        </thead>
        <tbody>
          {GKLayersMarkup}
        </tbody>
        </table>

      </div>

      </Modal>
  )
}

function RegModal({modalVisibility, setUserToken, currentLocaleState}) {

  const intl = useIntl()

  const register = async () => {

    // get email and password from fields
    const email = document.getElementById("InputEmail1").value
    const password = document.getElementById("InputPassword1").value
    const locale = currentLocaleState.currentLocale

    const userData = {
      user: {
        email: email,
        password: password,
        locale: locale,
      }
    }

    // try to register
    const registerResponseData = await postDataToAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/users/register`, userData)
    if (!isResponseSuccessful(registerResponseData)) {
      showMessage(registerResponseData.data.error,"error")
      return
    }

    // hide modal and show message
    modalVisibility.setVisibility(false)
    showMessage(intl.formatMessage({id:`Письмо подтверждения почты`,defaultMessage: `Было выслано письмо подтверждения почты`}))
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
    const loginResponse = await postDataToAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/users/login`, userLoginData)
    
    if (!isResponseSuccessful(loginResponse)) {
      showMessage(loginResponse.data.error,"error")
      return
    }

    // if succesful set user token
    const loginResponseData = loginResponse.data.data
    setUserToken(loginResponseData) 
    
    // hide modal and show message
    modalVisibility.setVisibility(false)
    showMessage(intl.formatMessage({id:`Авторизация успешна`,defaultMessage: `Авторизация успешна`}))    
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
    const resetPasswordResponse = await postDataToAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/users/reset`, userData,)
    if (!isResponseSuccessful(resetPasswordResponse)) {
      showMessage(resetPasswordResponse.data.error,"error")
      return
    }
    // show message
    showMessage(intl.formatMessage({id:`Письмо сброса пароля`,defaultMessage: `Письмо сброса пароля выслано`}))
  }


  return (
    <Modal
      modalVisibility={modalVisibility}
      title={intl.formatMessage({id:`Авторизация / Регистрация`,defaultMessage: `Авторизация / Регистрация`})}
      hasBackground={true}
      >
      <div className="modal-content2">

      <nav>
          <div className="nav nav-tabs" id="nav-tab" role="tablist">
              <button className="nav-link active" id="nav-login-tab" data-bs-toggle="tab" data-bs-target="#login" type="button" role="tab" aria-controls="login" aria-selected="true"><FormattedMessage id='Авторизация' defaultMessage="Авторизация"/></button>
              <button className="nav-link" id="nav-register-tab" data-bs-toggle="tab" data-bs-target="#register" type="button" role="tab" aria-controls="register" aria-selected="false"><FormattedMessage id='Регистрация' defaultMessage="Регистрация"/></button>
              <button className="nav-link" id="nav-forgot-password-tab" data-bs-toggle="tab" data-bs-target="#forgot-password" type="button" role="tab" aria-controls="forgot-password" aria-selected="false"><FormattedMessage id='Сброс пароля' defaultMessage="Сброс пароля"/></button>
          </div>
      </nav>
      <div className="tab-content" id="nav-tabContent">
          <div className="tab-pane fade show active" id="login" role="tabpanel" aria-labelledby="login-tab" tabIndex="0">

              <div className="modal-content2">
                <label htmlFor="InputEmail2" className="form-label"><FormattedMessage id='Почта' defaultMessage="Почта"/></label>
                <input type="email" className="form-control" id="InputEmail2" aria-describedby="emailHelp" placeholder="name@example.com"/>
                <label htmlFor="InputPassword2" className="form-label"><FormattedMessage id='Пароль' defaultMessage="Пароль"/></label>
                <input type="password" className="form-control" id="InputPassword2"/>
              </div>

              <div className="modal-footer2">
                  <button type="button" className="btn btn-primary" onClick={() => login()}><FormattedMessage id='Вход' defaultMessage="Вход"/></button>
              </div>
          </div>
          <div className="tab-pane fade" id="register" role="tabpanel" aria-labelledby="register-tab" tabIndex="0">

              <div className="modal-content2">
                  <label htmlFor="InputEmail1" className="form-label"><FormattedMessage id='Почта' defaultMessage="Почта"/></label>
                  <input type="email" className="form-control" id="InputEmail1" aria-describedby="emailHelp" placeholder="name@example.com"/>
                  <label htmlFor="InputPassword1" className="form-label"><FormattedMessage id='Пароль' defaultMessage="Пароль"/></label>
                  <input type="password" className="form-control" id="InputPassword1"/>
              </div>


              <div className="modal-footer2">
                  <button type="button" className="btn btn-primary" onClick={() => register()}><FormattedMessage id='Регистрация' defaultMessage="Регистрация"/></button>
              </div>
          </div>
          <div className="tab-pane fade" id="forgot-password" role="tabpanel" aria-labelledby="forgot-password-tab" tabIndex="0">

          <div className="modal-content2">
              <label htmlFor="InputEmail5" className="form-label"><FormattedMessage id='Почта' defaultMessage="Почта"/></label>
              <input type="email" className="form-control" id="InputEmail5" aria-describedby="emailHelp" placeholder="name@example.com"/>
          </div>

          <div className="modal-footer2">
              <button type="button" className="btn btn-primary" onClick={() => forgotPassword()}><FormattedMessage id='Сброс' defaultMessage="Сброс"/></button>
          </div>
          </div>
      </div>
      </div>

                   
      </Modal>
  )
}


function GKLayersImageModal({modalVisibility}) {

  const intl = useIntl()

  return (
    <Modal
      modalVisibility={modalVisibility}
      title={intl.formatMessage({id:`Соотношение уровней GK`,defaultMessage: `Соотношение уровней GK`})}
      sizeX={600}
      >
      <div className="modal-content2">
        <img src="/image.png" alt="Loading" className='GK-layers-image'/>
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

export function showMessage(messages,type = "success") {

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

function convertMarkdownToEditorState(stateFunction, markdown) {

  const blocksFromHtml = htmlToDraft(markdown);
  const { contentBlocks, entityMap } = blocksFromHtml;
  const contentState = ContentState.createFromBlockArray(contentBlocks, entityMap);
  stateFunction(EditorState.createWithContent(contentState))

}

function convertMarkdownFromEditorState(state) {

  const html = draftToMarkdown(convertToRaw(state.getCurrentContent())).replace('\n','');
  return html
}

export function convertToMLTI(M,L,T,I) {

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

  if (M === 0 && L === 0 && T === 0 && I === 0) { 
    MLTIHTMLString = 'L<sup>0</sup>T<sup>0</sup>'; 
  }

  return MLTIHTMLString
}


