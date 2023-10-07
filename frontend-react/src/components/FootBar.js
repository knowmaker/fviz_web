import React,{useContext} from 'react';
import { UserProfile,TableContext } from '../misc/contexts.js';
import { showMessage } from '../pages/Home.js';
import setStateFromGetAPI,{ putDataToAPI,isResponseSuccessful } from '../misc/api.js';


export default function Footbar({hoveredCell,selectedLawState,getImage,tableViewState,setTableViews}) {
  
  const userInfoState = useContext(UserProfile) 
  const tableState = useContext(TableContext)  
  const headers = {
    Authorization: `Bearer ${userInfoState.userToken}`
  }      

  let cellLT = "?"
  let cellGK = "?"
  if (hoveredCell) {

    cellLT = hoveredCell.l_indicate !== undefined ? `L<sup>${hoveredCell.l_indicate}</sup>T<sup>${hoveredCell.t_indicate}</sup>` : "?"
    cellGK = hoveredCell.GKLayer ? `G<sup>${hoveredCell.GKLayer.g_indicate}</sup>K<sup>${hoveredCell.GKLayer.k_indicate}</sup>` : "?"
  }
    
  const removeCurrentLaw = () => {
    selectedLawState.setSelectedLaw({law_name: null,cells:[],id_type: null})
  }

  const downloadPDF = async () => {

      const headers = {
        Authorization: `Bearer ${userInfoState.userToken}`,
      };

      const response = await fetch(`${process.env.REACT_APP_API_LINK}/quantities`, {
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
      a.download = 'Величины.pdf';
      document.body.appendChild(a);
      a.click();

      window.URL.revokeObjectURL(url);
  };

  const updateTableView = async () => {

     // get all current visible cells ids
     const cellIds = Object.values(tableState)[0].map(cell => cell.id_value)
 
     const newTableView = {
       title: tableViewState.tableView.title,
       active_quantities: cellIds,
     }
   
     // send table view update request
     const changedTableViewResponseData = await putDataToAPI(`${process.env.REACT_APP_API_LINK}/represents/${tableViewState.tableView.id_repr}`,newTableView,headers)
     if (!isResponseSuccessful(changedTableViewResponseData)) {
       showMessage(changedTableViewResponseData.data.error,"error")
       return
     }
 
     // update current table views
     setStateFromGetAPI(setTableViews, `${process.env.REACT_APP_API_LINK}/represents`,undefined,headers)
 
     // show message
     showMessage("Представление обновлено")
      
  }
  
  return (
  <nav className="navbar navbar-expand fixed-bottom bg-body-tertiary">
    <div className="container-fluid">
        <div className="navbar-nav">
          <div className="diminput" id="outLT"> 
            <div className="v-align" dangerouslySetInnerHTML={{__html: cellLT}}/> 
          </div>
          <div className="diminput" id="outGK"> 
            <div className="v-align" dangerouslySetInnerHTML={{__html: cellGK}}/> 
          </div>
          <div className="nameinput" id="outName"> 
            <div className="v-align" dangerouslySetInnerHTML={{__html: tableViewState.tableView.title}}></div>
          </div>
          <div className="btn-sm btn-primary btn footbar-button" aria-current="page" onClick={updateTableView}>Сохранить представление</div>
          <div className="btn-sm btn-primary btn footbar-button" aria-current="page" onClick={removeCurrentLaw}>Стереть закон</div>

        </div>
        <div className="navbar-text">
          <div className="btn-sm btn-primary btn footbar-button" aria-current="page" onClick={downloadPDF}>Скачать pdf</div>
          <div className="btn-sm btn-primary btn" aria-current="page" onClick={getImage}>Скачать скриншот</div>
        </div>
    </div>
  </nav>
    );
}