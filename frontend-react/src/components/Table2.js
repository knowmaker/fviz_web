import React, { useEffect, useState, useContext, forwardRef } from 'react';
import Navbar from './Navbar';
import Footbar from './FootBar';
import { TableContext } from './Contexts.js';
import { useDownloadableScreenshot } from './Screenshot';
import getData from './api';

const rowCount = 20
const cellCount = 20

export default function TableUI({modalsVisibility}) {


  const [tableData, setTableData] = useState([]);
  const [gkColors, setGkColors] = useState([]);
  
  const [undoStack, setUndoStack] = useState([]);
  const [redoStack, setRedoStack] = useState([]);
  const [selectedCell, setSelectedCell] = useState(null);
  const [hoveredCell, setHoveredCell] = useState(null);

  const revStates = {undoStack,setUndoStack,redoStack,setRedoStack}
  const tableState = {tableData,setTableData}
  const hoveredCellState = {hoveredCell, setHoveredCell}
  //const isLoaded = tableData.length !== 0 && gkColors.length !== 0

  useEffect(() => {
    getData(setTableData, process.env.REACT_APP_QUANTITIES_LINK)
    getData(setGkColors,process.env.REACT_APP_GK_SETTINGS_LINK)

  }, []);

  const [once, setOnce] = useState(true);
  if (document.getElementById("cell-204") !== null && once) {
    document.getElementById("cell-204").scrollIntoView({ behavior: "smooth", block: "center", inline: "center" });
    setOnce(false)
  }

  const { ref, getImage } = useDownloadableScreenshot();

  return (
    <TableContext.Provider value={tableState}>
      <Navbar revStates={revStates} getImage={getImage} modalsVisibility={modalsVisibility}/>
      <CellOptions selectedCellState={{selectedCell,setSelectedCell}} gkColors={gkColors} revStates={revStates} />
      <Table2 gkColors={gkColors} setSelectedCell={setSelectedCell} hoveredCellState={hoveredCellState} ref={ref}/>
      <Footbar hoveredCell={hoveredCell} gkColors={gkColors}/>
    </TableContext.Provider>
    );
}

function CellOptions({selectedCellState ,gkColors, revStates}) {

  const selectedCell = selectedCellState.selectedCell
  const setSelectedCell = selectedCellState.setSelectedCell

  if (selectedCell !== null) {


    const cells = selectedCell.map(cellData => {

      const cellFullId = cellData.id_value
      const cellColor = `#${gkColors.find((setting) => setting.id_gk === cellData.id_gk).gk_color}`

      return (
        <Cell 
        key={cellFullId} 
        cellFullData={{cellFullId,cellData,cellColor}}
        selectedCells={selectedCell} 
        revStates={revStates} 
        cellRightClick={setSelectedCell}
        />
      );
    })


    return (
      <div className="data-window">
        {cells}
      </div>
    );

  } else {
    return null
  }

  
}

const Table2 = forwardRef(({ gkColors, setSelectedCell, hoveredCellState }, ref) => {


  const tableState = useContext(TableContext)
  const tableData = tableState.tableData
  const fullTableData = { tableData: tableData, Colors: gkColors};


  const isLoaded = tableData.length !== 0 && gkColors.length !== 0

  if (isLoaded) {
    const rowList = Array.from({length: rowCount}, (_, rowId) => {
      return <Row key={rowId} rowId={rowId} fullTableData={fullTableData} setSelectedCell={setSelectedCell} hoveredCellState={hoveredCellState}/>
    });
      return <div className="tables" ref={ref}>{rowList}</div>
  }
  else
  {
     return (
      <div className="loading">
          <img src="/bee2.gif" alt="Loading"/>
      </div>
     )
  }

})

function Row({rowId, fullTableData, setSelectedCell, hoveredCellState}) {

  const isEven = (rowId % 2 === 0 ? 0 : 1)

  const cellList = Array.from({length: cellCount - 1 - isEven}, (_, cellId) => {

    const cellFullId = rowId * 19 + isEven + cellId + 1 + Math.floor(rowId / 2)
    const cellData = fullTableData.tableData.find(cell => cell.id_lt === cellFullId)
    const cellColor = cellData ? `#${fullTableData.Colors.find((setting) => setting.id_gk === cellData.id_gk).gk_color}` : '';

    return (<Cell 
            key={cellFullId} 
            cellFullData={{cellFullId,cellData,cellColor}} 
            cellRightClick={setSelectedCell} 
            hoveredCellState={hoveredCellState}
            />);
  });


  if (isEven) {
    return <div className="row"><div className="half-cell"></div>{cellList}</div>
  } else {
    return <div className="row">{cellList}</div>
  }

  


}

function Cell({cellFullData, cellRightClick, selectedCells, revStates, hoveredCellState}) {

  const cellFullId = cellFullData.cellFullId
  const cellData = cellFullData.cellData
  const cellColor = cellFullData.cellColor
  const tableState = useContext(TableContext)

  
  const handleCellRightClick = (event, cellId) => {
    
    event.preventDefault()
    cellRightClick(null)
    console.log(cellId)

    //need to fix this 
    if (cellRightClick) {

      getData(cellRightClick,`http://127.0.0.1:5000/api/layers/${cellId}`)
    }

  };

  const handleEmptyCellRightClick = (event) => {
    event.preventDefault()
    cellRightClick(null)
  }

  const handleCellLeftClick = (event, cellId) => {
    



    //need to fix this 
    if (selectedCells) {

      event.preventDefault()
      const cellData = selectedCells.find(cell => cell.id_value === cellId);
      //console.log(cellData)
      //console.log(tableState.tableData)
      tableState.setTableData(tableState.tableData.filter(cell => cell.id_lt !== cellData.id_lt).concat(cellData))
      //console.log(tableState.tableData)

      revStates.setUndoStack([...revStates.undoStack, tableState.tableData]);
      revStates.setRedoStack([]);
      //console.log(revStates.undoStack)
      //console.log(revStates.redoStack)
      cellRightClick(null)
    }

  };

  const handleCellHover = (event, cellId) => {
      //need to fix this 
      
      if (hoveredCellState) {
        hoveredCellState.setHoveredCell(cellId)
      }
  }


  if (cellData) {

    const cellContent_name = cellData.val_name;
    const cellContent_symbol = cellData.symbol;
    const cellContent_unit = cellData.unit;
    const cellContent_mlti = cellData.mlti_sign;
    
    

    return (
        <div
          key={cellFullId}
          className="cell"
          id={`cell-${cellFullId}`}
          style={{ backgroundColor: cellColor }}
          onContextMenu={event => handleCellRightClick(event, cellFullId)}
          onClick={event => handleCellLeftClick(event, cellFullId)}
          onMouseOver={event => handleCellHover(event, cellFullId)}
        >
          <div>
              {cellContent_name}
              <br />
          </div>
          <div className="su-pos">
          {cellContent_symbol}
              {', '}
          {cellContent_unit} 
              <br />
          </div>
          <div className="mlti-pos">
          {cellContent_mlti}
          </div>
        </div>
    );
  } else {
    return <div className="cell-invisible cell" onContextMenu={event => handleEmptyCellRightClick(event, cellFullId)}></div>
  }
  
}

