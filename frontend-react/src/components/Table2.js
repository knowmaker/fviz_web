import React, { useEffect, useState, useContext, forwardRef } from 'react';
import Navbar from './Navbar';
import Footbar from './FootBar';
import { TableContext } from './Contexts.js';
import { useDownloadableScreenshot } from './Screenshot';
import getData from './api';

const rowCount = 20
const cellCount = 20

export default function TableUI({modalsVisibility, gkState, selectedCellState, revStates}) {

  const [hoveredCell, setHoveredCell] = useState(null);



  const hoveredCellState = {hoveredCell, setHoveredCell}


  const [once, setOnce] = useState(true);
  const tableState = useContext(TableContext)

  useEffect(() => {

  if (document.getElementById("cell-204") !== null && once) {
    document.getElementById("cell-204").scrollIntoView({ behavior: "smooth", block: "center", inline: "center" });
    setOnce(false)
  }

  }, [tableState]);



  const { ref, getImage } = useDownloadableScreenshot();

  return (
    <>
      <Navbar revStates={revStates} getImage={getImage} modalsVisibility={modalsVisibility} selectedCell={selectedCellState.selectedCell}/>
      <CellOptions selectedCellState={selectedCellState} gkColors={gkState.gkColors} revStates={revStates} />
      <Table2 gkColors={gkState.gkColors} setSelectedCell={selectedCellState.setSelectedCell} hoveredCellState={hoveredCellState} ref={ref}/>
      <Footbar hoveredCell={hoveredCell} gkColors={gkState.gkColors}/>
    </>  
    );
}

function CellOptions({selectedCellState ,gkColors, revStates}) {

  const selectedCell = selectedCellState.selectedCell
  const setSelectedCell = selectedCellState.setSelectedCell

  const [cellAlternatives, setCellAlternatives] = useState(null);

  useEffect(() => {
    if (selectedCell) {
      getData(setCellAlternatives,`${process.env.REACT_APP_CELL_LAYERS_LINK}/${selectedCell.id_lt}`) 
    } else {setCellAlternatives(null)}
  }, [selectedCell]);

  if (cellAlternatives !== null && selectedCell !== null) {

    const cells = cellAlternatives.filter(cellData => cellData.id_value !== selectedCell.id_value).map(cellData => {

      const cellFullId = cellData.id_value
      const cellColor = `#${gkColors.find((setting) => setting.id_gk === cellData.id_gk).gk_color}`

      return (
        <Cell 
        key={cellFullId} 
        cellFullData={{cellFullId,cellData,cellColor}}
        selectedCells={cellAlternatives} 
        revStates={revStates} 
        setSelectedCell={setSelectedCell}
        />
      )


    })


    const cellOptions = cells.length !== 0 ? cells : "no cells to show"

    return (
      <div className="data-window">
        <div className="data-window-top">
        <span>Choose cell</span>
        <button type="button" className="btn-close" onClick={() => setSelectedCell(null)}></button>
        </div>
        {cellOptions}
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

function Cell({cellFullData, cellRightClick, selectedCells, revStates, hoveredCellState, setSelectedCell}) {

  const cellFullId = cellFullData.cellFullId
  const cellData = cellFullData.cellData
  const cellColor = cellFullData.cellColor
  const tableState = useContext(TableContext)

  
  const handleCellRightClick = (event, cellId) => {
    
    event.preventDefault()
    cellRightClick(null)


      //getData(cellRightClick,`http://127.0.0.1:5000/api/layers/${cellId}`)
      cellRightClick(cellData)

  };

  const handleEmptyCellRightClick = (event) => {
    event.preventDefault()
    cellRightClick(null)
  }

  const handleCellLeftClick = (event, cellId) => {
    
      event.preventDefault()
      const cellData = selectedCells.find(cell => cell.id_value === cellId);

      cellData.lt_sign = tableState.tableData.find(cell => cell.id_lt !== cellData.id_lt).lt_sign

      tableState.setTableData(tableState.tableData.filter(cell => cell.id_lt !== cellData.id_lt).concat(cellData))


      revStates.setUndoStack([...revStates.undoStack, tableState.tableData]);
      revStates.setRedoStack([]);



      setSelectedCell(null)

  };

  const handleCellHover = (event, cellId) => {

    hoveredCellState.setHoveredCell(cellId)
  }


  if (cellData) {

    const cellContent_name = cellData.value_name;
    const cellContent_symbol = cellData.symbol;
    const cellContent_unit = cellData.unit;
    const cellContent_mlti = cellData.mlti_sign;
    
    

    return (
        <div
          key={cellFullId}
          className="cell"
          id={`cell-${cellFullId}`}
          style={{ backgroundColor: cellColor }}
          onContextMenu={event => cellRightClick ? handleCellRightClick(event, cellFullId) : {}}
          onClick={event => selectedCells ? handleCellLeftClick(event, cellFullId) : {}}
          onMouseOver={event => hoveredCellState ? handleCellHover(event, cellFullId) : {}}
        >
          <div className='cell-name'>
          <span dangerouslySetInnerHTML={{__html: cellContent_name}}></span>
              <br />
          </div>
          <div className="su-pos" >
          <span dangerouslySetInnerHTML={{__html: cellContent_symbol}}></span>
              {', '}
          <span dangerouslySetInnerHTML={{__html: cellContent_unit}}></span>   
              <br />
          </div>
          <div className="mlti-pos">
          <span dangerouslySetInnerHTML={{__html: cellContent_mlti}}></span>   
          </div>
        </div>
    );
  } else {
    return <div className="cell-invisible cell" onContextMenu={event => handleEmptyCellRightClick(event, cellFullId)}></div>
  }
  
}

