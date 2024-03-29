import React,{useContext} from 'react';
import { UserProfile,TableContext } from '../misc/contexts.js';
import { showMessage } from '../misc/message.js';
import setStateFromGetAPI,{ putDataToAPI,isResponseSuccessful } from '../misc/api.js';
import {FormattedMessage,useIntl} from 'react-intl'
import { Button } from '../components/ButtonWithLoad.js';

export default function Footbar({hoveredCell,selectedLawState,getImage,tableViewState,setTableViews,modalsVisibility,showModeState,selectedCellState,GKLayersImageModalVisibility}) {
  
  const userInfoState = useContext(UserProfile) 
  const tableState = useContext(TableContext)  
  const headers = {
    Authorization: `Bearer ${userInfoState.userToken}`
  }     
  let isAdmin = false
  if (userInfoState.userProfile) {
    isAdmin = userInfoState.userProfile.role
  }
  let isAuthorized = false;
  if (userInfoState.userProfile) {
      isAuthorized = true;
  }
  
  const intl = useIntl()

  let cellLT = "-"
  let cellGK = "-"
  if (hoveredCell) {

    cellLT = hoveredCell.l_indicate !== undefined ? `L<sup>${hoveredCell.l_indicate}</sup>T<sup>${hoveredCell.t_indicate}</sup>` : "-"
    cellGK = hoveredCell.GKLayer ? `G<sup>${hoveredCell.GKLayer.g_indicate}</sup>K<sup>${hoveredCell.GKLayer.k_indicate}</sup>` : "-"
  }
    
  const removeCurrentLaw = () => {
    selectedLawState.setSelectedLaw({law_name: null,cells:[],id_type: null})
  }

  const downloadPDF = async () => {

      const headers = {
        Authorization: `Bearer ${userInfoState.userToken}`,
      };

      const response = await fetch(`${process.env.REACT_APP_API_LINK}/${intl.locale}/quantities`, {
        method: 'GET',
        headers: headers,
      });

      if (!response.ok) {
        showMessage(response.data.error,"error")
      }

      const blob = await response.blob();
      const url = window.URL.createObjectURL(blob);

      const a = document.createElement('a');
      a.href = url;
      a.download = `${intl.formatMessage({id:`Величины.pdf`,defaultMessage: `Величины.pdf`})}`;
      document.body.appendChild(a);
      a.click();

      window.URL.revokeObjectURL(url);
  };

  const downloadScreenshot = async (e) => {
    //const selectedCell = selectedCellState.selectedCell
    //await selectedCellState.setSelectedCell(null)
    await getImage(e)
    //await selectedCellState.setSelectedCell(selectedCell)
  }




  const updateTableView = async () => {

     // get all current visible cells ids
     const cellIds = Object.values(tableState)[0].map(cell => cell.id_value)
 
     const newTableView = {
       title: tableViewState.tableView.title,
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

  const showGKLayersImageModal = () => {
    GKLayersImageModalVisibility.setVisibility(true)
  }

  const setShowModeState = () => {
    const isSwitchActive = document.getElementById("flexSwitchCheck").checked
    showModeState.setShowMode(isSwitchActive)
  }
  
  return (
  <nav className="navbar navbar-expand-lg fixed-bottom bg-body-tertiary">
    <div className="container-fluid">
        <button className="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#footerSupportedContent" aria-controls="footerSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span className="navbar-toggler-icon"></span>
        </button>
        <div className="collapse navbar-collapse" id="footerSupportedContent">
            <div className="navbar-nav">
              <div className="diminput footbar-input" id="outLT">
                <div className="v-align" dangerouslySetInnerHTML={{__html: cellLT}}/>
              </div>
              <div className="diminput footbar-input" id="outGK">
                <div className="v-align" dangerouslySetInnerHTML={{__html: cellGK}}/>
              </div>
              {isAuthorized ?
              (<>
              <div className="nameinput footbar-input" id="outName">
                <div className="v-align " dangerouslySetInnerHTML={{__html: tableViewState.tableView.title}}></div>
              </div>
              <Button className="btn-sm btn-primary btn footbar-button" aria-current="page" onClick={(e) => updateTableView(e)}><FormattedMessage id='Сохранить представление' defaultMessage="Сохранить представление"/></Button>
              </>) : (null)}
              <div className="btn-sm btn-primary btn footbar-button" aria-current="page" onClick={showGKLayersImageModal}><FormattedMessage id='Показать уровни GK' defaultMessage="Показать уровни GK"/></div>
              <Button className="btn-sm btn-primary btn footbar-button" aria-current="page" onClick={(e) => downloadScreenshot(e)}><FormattedMessage id='Скачать скриншот' defaultMessage="Скачать скриншот"/></Button>
                {isAdmin ?
                    (<>
                        <Button className="btn-sm btn-primary btn footbar-button" aria-current="page" onClick={(e) => downloadPDF(e)}><FormattedMessage id='Скачать ' defaultMessage="Скачать "/> pdf</Button>
                    </>) : (null)}

                  <label className="form-check-label"><FormattedMessage id='Режим законов' defaultMessage="Режим законов"/></label>
                <div className="form-check form-switch">
                  <input className="form-check-input" type="checkbox" role="switch" id="flexSwitchCheck" onClick={(e) => {setShowModeState(e)}}/>
                  <label className="form-check-label" htmlFor="flexSwitchCheck"><FormattedMessage id='Режим просмотра' defaultMessage="Режим просмотра"/></label>
                </div>  
            </div>
        </div>
        {selectedLawState.selectedLaw.cells.length >= 1 ?
              (<>
        <div className="navbar-text">
            <div className="btn-sm btn-primary btn footbar-button" aria-current="page" onClick={removeCurrentLaw}><FormattedMessage id='Стереть закон' defaultMessage="Стереть закон"/></div>
        </div>
        </>) : (null)}

    </div>
  </nav>
    );
}