import React from 'react';

export default function Footbar({hoveredCell,selectedLawState}) {
  
  let cellLT = "?"
  let cellGK = "?"
  if (hoveredCell) {
    cellLT = hoveredCell.lt_sign
    cellGK = hoveredCell.GKLayer ? hoveredCell.GKLayer.gk_sign : "?"
  }
    
  const removeCurrentLaw = () => {
    selectedLawState.setSelectedLaw({law_name: null,cells:[],id_type: null})
  }

  const download = (image) => {
    const a = document.createElement("a");
    a.href = image;
    a.download = "представление.jpg";
    a.click();
  };

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
          <div className="btn-sm btn-primary btn" aria-current="page" onClick={removeCurrentLaw}>Скачать pdf</div>

        </div>
    </div>
  </nav>
    );
}