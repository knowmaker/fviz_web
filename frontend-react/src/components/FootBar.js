import React from 'react';
import { TableContext } from './TableContext.js';
import { useContext } from 'react';

export default function Footbar({hoveredCell}) {

  const tableState = useContext(TableContext)

    const cellData = tableState ? tableState.tableData.find(cell => cell.id_lt === hoveredCell) : undefined

    const cellLT = cellData ? cellData.lt_sign : "?"
    const cellGK = `No Data`

  return (
    <nav className="navbar navbar-expand-lg fixed-bottom bg-body-tertiary">
    <div className="container-fluid">
        <div className="navbar-nav">
          <input className="diminput" type="text" id="outLT" placeholder="LT размерность" value={cellLT} readOnly={true}/> 
          <input className="diminput" type="text" id="outLT" placeholder="GK размерность" value={cellGK} readOnly={true}/> 
        </div>
    </div>
  </nav>
    );
}