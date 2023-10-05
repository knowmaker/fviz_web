import React,{useContext} from 'react';
import { UserProfile } from '../misc/contexts.js';
import  { getDataFromAPI} from '../misc/api.js';


export default function Footbar({hoveredCell,selectedLawState,getImage}) {
  
  const userInfoState = useContext(UserProfile) 

  let cellLT = "?"
  let cellGK = "?"
  if (hoveredCell) {
    cellLT = hoveredCell.lt_sign ? hoveredCell.lt_sign : "?"
    cellGK = hoveredCell.GKLayer ? hoveredCell.GKLayer.gk_sign : "?"
  }
    
  const removeCurrentLaw = () => {
    selectedLawState.setSelectedLaw({law_name: null,cells:[],id_type: null})
  }

  const downloadPDF = async () => {
    try {
      const headers = {
        Authorization: `Bearer ${userInfoState.userToken}`,
      };

      const response = await fetch(`${process.env.REACT_APP_API_LINK}/quantities`, {
        method: 'GET',
        headers: headers,
      });

      if (!response.ok) {
        throw new Error('Network response was not ok');
      }

      const blob = await response.blob();
      const url = window.URL.createObjectURL(blob);

      const a = document.createElement('a');
      a.href = url;
      a.download = 'quantities_table.pdf';
      document.body.appendChild(a);
      a.click();

      window.URL.revokeObjectURL(url);
    } catch (error) {
      console.error('Error downloading PDF:', error);
    }
  };


  

  // function downloadByURL(dataurl, filename) {
  //   const link = document.createElement("a");
  //   link.href = dataurl;
  //   link.download = filename;
  //   link.click();
  // }

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
          <div className="btn-sm btn-primary btn" aria-current="page" onClick={removeCurrentLaw}>Стереть закон</div>

        </div>
        <div className="navbar-text">
          <div className="btn-sm btn-primary btn" aria-current="page" onClick={downloadPDF}>Скачать pdf</div>
          <div className="btn-sm btn-primary btn" aria-current="page" onClick={getImage}>Скачать скриншот</div>
        </div>
    </div>
  </nav>
    );
}