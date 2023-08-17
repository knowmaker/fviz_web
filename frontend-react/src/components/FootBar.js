import React from 'react';
import { TableContext } from './Contexts.js';
import { useContext } from 'react';

export default function Footbar({hoveredCell,gkColors}) {

  const tableState = useContext(TableContext)

    const cellData = tableState ? tableState.tableData.find(cell => cell.id_lt === hoveredCell) : undefined
    const cellDataGK = gkColors ? gkColors.find(GK => GK.id_gk === (cellData ? cellData.id_gk : "")) : undefined

    const cellLT = cellData ? cellData.lt_sign : "?"
    const cellGK = cellDataGK ? cellDataGK.gk_sign : "?"

    


  return (
  <nav className="navbar navbar-expand fixed-bottom bg-body-tertiary">
    <div className="container-fluid">
        <div className="navbar-nav">
          <input className="diminput" type="text" id="outLT" placeholder="LT размерность" value={cellLT} readOnly={true}/> 
          <input className="diminput" type="text" id="outLT" placeholder="GK размерность" value={cellGK} readOnly={true}/> 
        </div>
    </div>
  </nav>
    );
}