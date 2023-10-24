import React,{useEffect,useState} from 'react';

import TableUI from '../components/Table';
import setStateFromGetAPI, {
  getDataFromAPI} from '../misc/api.js';
import { ToastContainer } from 'react-toastify';
import { UserProfile,TableContext } from '../misc/contexts.js';
import { EditorState, convertToRaw } from 'draft-js';
import Footbar from '../components/FootBar';
import { useDownloadableScreenshot } from '../misc/Screenshot.js';
import draftToMarkdown from 'draftjs-to-markdown';
import { isResponseSuccessful } from '../misc/api';

import {IntlProvider} from 'react-intl'
import {createIntl} from 'react-intl'
// const Color = require('color');

import translationEN from '../compiled-lang/en.json';
import translationRU from '../compiled-lang/ru.json';
import { EditCellModal } from '../modals/EditCellModal';
import { EditProfileModal } from '../modals/EditProfileModal';
import { LawsModal } from '../modals/LawsModal';
import { TableViewsModal } from '../modals/TableViewsModal';
import { LawsGroupsModal } from '../modals/LawsGroupsModal';
import { GKColorModal } from '../modals/GKColorModal';
import { RegModal } from '../modals/RegModal';
import { GKLayersImageModal } from '../modals/GKLayersImageModal';
import { convertMarkdownToEditorState } from '../misc/converters';
import { showMessage } from '../misc/message';

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

    // if user profile is not null set edit form
    if (userProfile) {
      document.getElementById("InputEmail3").value = userProfile.email
      document.getElementById("InputFirstName3").value = userProfile.first_name
      document.getElementById("InputLastName3").value = userProfile.last_name
      document.getElementById("InputPatronymic3").value = userProfile.patronymic
      document.getElementById("inputLocale").value = userProfile.locale
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

    const [isLawsMenuVisible, setLawsMenuVisibility] = useState(false);
    const LawsMenuVisibility = {isVisible: isLawsMenuVisible, setVisibility: setLawsMenuVisibility}


    const modalsVisibility={regModalVisibility,editProfileModalVisibility,
                            editCellModalVisibility,lawsModalVisibility,
                            tableViewsModalVisibility,lawsGroupsModalVisibility
                            ,GKColorsEditModalVisibility,GKLayersImageModalVisibility,
                            LawsMenuVisibility}


    const [tableData, setTableData] = useState([]);
    const tableState = {tableData,setTableData}
    const [GKLayers, setGKLayers] = useState([]);
    const GKLayersState = {gkColors: GKLayers, setGkColors: setGKLayers}

    const [tableView, setTableView] = useState({id_repr:1,title:intl.formatMessage({id:`Базовое`,defaultMessage: `Базовое`})}); 
    const tableViewState = {tableView,setTableView}

    useEffect(() => {

      // get all required localized data without authorization
      setStateFromGetAPI(setGKLayers,`${process.env.REACT_APP_API_LINK}/${intl.locale}/gk`,undefined,undefined)
  
      if (userToken) {
  
        // set header for API queries
        const headers = {
          Authorization: `Bearer ${userToken}`
        }    
  
        
        // get all required localized data
        setStateFromGetAPI(setTableViews, `${process.env.REACT_APP_API_LINK}/${intl.locale}/represents`,undefined,headers)
        setStateFromGetAPI(setLaws, `${process.env.REACT_APP_API_LINK}/${intl.locale}/laws`,undefined,headers)
        setStateFromGetAPI(setLawsGroups, `${process.env.REACT_APP_API_LINK}/${intl.locale}/law_types`,undefined,headers)
        setStateFromGetAPI(setFullTableData,`${process.env.REACT_APP_API_LINK}/${intl.locale}/active_view/${tableView.id_repr}`,undefined,headers)
  
  
      } else {
        setStateFromGetAPI(setFullTableData,`${process.env.REACT_APP_API_LINK}/${intl.locale}/active_view`,undefined,undefined)
      }
  
    }, [currentLocale]);


    const setFullTableData = (result) => {

      setTableData(result.active_quantities)
      setTableView({id_repr:result.id_repr,title:result.title})
    }
    // get table and layers when page is loaded
    useEffect(() => {
      
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
            setStateFromGetAPI(setFullTableData,`${process.env.REACT_APP_API_LINK}/${intl.locale}/active_view`)
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

    const [lawNameEditor, setLawNameEditor] = useState(EditorState.createEmpty())
    const lawNameEditorState = {value: lawNameEditor,set: setLawNameEditor}
    const [lawGroupEditor, setLawGroupEditor] = useState(0)
    const lawGroupEditorState = {value: lawGroupEditor,set: setLawGroupEditor}

    const lawEditorsStates = {lawNameEditorState,lawGroupEditorState}
    
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

          let cellData
          // get full data about cell if it isn't requested
          if (selectedCell.g_indicate === undefined) {

            const cellResponseData = await getDataFromAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/quantities/${selectedCell.id_value}`)
            if (!isResponseSuccessful(cellResponseData)) {
              showMessage(cellResponseData.data.error,"error")
              return
            }
            cellData = cellResponseData.data.data
            console.log("update")

          } else {cellData = selectedCell}


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

                <TableUI modalsVisibility={modalsVisibility} selectedCellState={selectedCellState} revStates={revStates} gkState={GKLayersState} selectedLawState={selectedLawState} hoveredCellState={hoveredCellState} refTable={ref} lawsGroupsState={lawsGroupsState} lawsState={lawsState} currentLocaleState={currentLocaleState} lawEditorsStates={lawEditorsStates}/>
                <Footbar hoveredCell={hoveredCell} selectedLawState={selectedLawState} getImage={getImage} tableViewState={tableViewState} setTableViews={setTableViews} modalsVisibility={modalsVisibility}/>

                <div id="modal-mask" className='hidden'></div>                  
                <RegModal modalVisibility={modalsVisibility.regModalVisibility} setUserToken={setUserToken} currentLocaleState={currentLocaleState}/>               
                <EditCellModal modalVisibility={modalsVisibility.editCellModalVisibility} selectedCell={selectedCell} selectedCellState={selectedCellState} cellEditorsStates={cellEditorsStates} gkColors={GKLayers}/>
                <EditProfileModal modalsVisibility={modalsVisibility} userInfoState={userInfoState} currentLocaleState={currentLocaleState}/>
                <LawsModal modalsVisibility={modalsVisibility} lawsState={lawsState} selectedLawState={selectedLawState} lawsGroupsState={lawsGroupsState} lawEditorsStates={lawEditorsStates}/>
                <TableViewsModal modalsVisibility={modalsVisibility} tableViews={tableViews} setTableViews={setTableViews} tableViewState={tableViewState}/>
                <LawsGroupsModal modalsVisibility={modalsVisibility} lawsGroupsState={lawsGroupsState} lawsState={lawsState}/>
                <GKColorModal modalsVisibility={modalsVisibility} GKLayersState={GKLayersState}/>
                <GKLayersImageModal modalVisibility={modalsVisibility.GKLayersImageModalVisibility} />

                <ToastContainer />
          </TableContext.Provider>
        </UserProfile.Provider>
      </IntlProvider>
    );
}

export function convertMarkdownFromEditorState(state) {

  const html = draftToMarkdown(convertToRaw(state.getCurrentContent())).replace('\n','');
  return html
}

export function showPassword(inputElementRef,eyeElementRef) {
  if(inputElementRef.current.getAttribute("type") === "text") {
    inputElementRef.current.setAttribute('type', 'password');
    eyeElementRef.current.classList.add( "fa-eye-slash" );
    eyeElementRef.current.classList.remove( "fa-eye" );
  } else if(inputElementRef.current.getAttribute("type") === "password"){
    inputElementRef.current.setAttribute('type', 'text');
    eyeElementRef.current.classList.remove( "fa-eye-slash" );
    eyeElementRef.current.classList.add( "fa-eye" );
}
}

