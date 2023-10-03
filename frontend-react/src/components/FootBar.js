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
  

    const headers = {
      Authorization: `Bearer ${userInfoState.userToken}`
    }    
    const PDFFile = await getDataFromAPI(`${process.env.REACT_APP_API_LINK}/quantities`, headers)
    const blob = await new Blob([PDFFile.data]);
    const url = window.URL.createObjectURL(blob);

    // Создаем ссылку для скачивания
    const a = document.createElement('a');
    a.href = url;
    a.download = 'quantities_table.pdf';
    document.body.appendChild(a);

    // Нажимаем на ссылку для скачивания
    a.click();

    // Удаляем ссылку после скачивания
    window.URL.revokeObjectURL(url);
  
  
  }

  

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