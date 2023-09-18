import React from 'react';
import { TableContext } from './Contexts.js';
import { useContext } from 'react';

export default function Footbar({hoveredCell}) {
  
  let cellLT = "?"
  let cellGK = "?"
  if (hoveredCell) {
    cellLT = hoveredCell.lt_sign
    cellGK = hoveredCell.GKLayer ? hoveredCell.GKLayer.gk_sign : "?"
  }
    

  return (
  <nav className="navbar navbar-expand fixed-bottom bg-body-tertiary">
    <div className="container-fluid">
        <div className="navbar-nav">
          <div className="diminput" id="outLT" dangerouslySetInnerHTML={{__html: cellLT}}/> 
          <div className="diminput" id="outGK" dangerouslySetInnerHTML={{__html: cellGK}}/> 
        </div>
    </div>
  </nav>
    );
}