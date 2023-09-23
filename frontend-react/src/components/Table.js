import React, { useEffect, useState, useContext, forwardRef } from 'react';
import Navbar from './Navbar';
import { TableContext, UserProfile } from '../misc/contexts.js';
import { useDownloadableScreenshot } from '../misc/Screenshot.js';
import setStateFromGetAPI, {getAllCellData} from '../misc/api';
import LawsCanvas from './LawsCanvas';
const Color = require('color');

const rowCount = 21
const cellCount = 20

export default function TableUI({modalsVisibility, gkState, selectedCellState, revStates, selectedLawState,hoveredCellState}) {



  const hoveredCell = hoveredCellState.hoveredCell

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
      <Table gkColors={gkState.gkColors} setSelectedCell={selectedCellState.setSelectedCell} hoveredCellState={hoveredCellState} selectedLawState={selectedLawState} ref={ref} modalsVisibility={modalsVisibility}/>


    </>  
    );
}

function CellOptions({selectedCellState ,gkColors, revStates}) {

  const selectedCell = selectedCellState.selectedCell
  const setSelectedCell = selectedCellState.setSelectedCell

  const [cellAlternatives, setCellAlternatives] = useState(null);

  useEffect(() => {
    if (selectedCell) {
      setStateFromGetAPI(setCellAlternatives,`${process.env.REACT_APP_API_LINK}/layers/${selectedCell.id_lt}`) 
    } else {setCellAlternatives(null)}
  }, [selectedCell]);

  console.log(cellAlternatives,selectedCell)

  if (cellAlternatives !== null && selectedCell !== null) {

    const emptyCellData = {id_lt:selectedCell.id_lt,id_value:999}    

    let cells = cellAlternatives.filter(cellData => cellData.id_value !== selectedCell.id_value).map(cellData => {

      const cellFullId = cellData.id_value
      const cellColor = `${gkColors.find((setting) => setting.id_gk === cellData.id_gk).color}`

      //console.log(cellData)
      return (
        <Cell 
        key={cellFullId} 
        cellFullData={{cellFullId,cellData,cellColor}}
        selectedCells={cellAlternatives.concat(emptyCellData)} 
        revStates={revStates} 
        setSelectedCell={setSelectedCell}
        />
      )


    })

    
    cells.push(
      <Cell 
      key={999} 
      cellFullData={{cellFullId:999,cellData:emptyCellData,undefined}}
      selectedCells={cellAlternatives.concat(emptyCellData)} 
      revStates={revStates} 
      setSelectedCell={setSelectedCell}
      isEmpty={true}
      />
    )

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

const Table = forwardRef(({ gkColors, setSelectedCell, hoveredCellState, selectedLawState,modalsVisibility}, ref) => {


  const tableState = useContext(TableContext)
  const tableData = tableState.tableData
  const fullTableData = { tableData: tableData, Colors: gkColors};

  const isLoaded = tableData.length !== 0 && gkColors.length !== 0

  const [emptyCells, setEmptyCells] = useState([]);

  useEffect(() => {

    setStateFromGetAPI(setEmptyCells, `http://localhost:5000/api/lt`)

  }, []);

  //console.log(emptyCells)

  //console.log( selectedLawState.selectedLaw)
  let selectedLawCellsLTId = selectedLawState.selectedLaw.cells.map(cell => cell.id_lt)
  if (hoveredCellState.hoveredCell !== null && selectedLawCellsLTId.length >= 1 && selectedLawCellsLTId.length < 3) {
    selectedLawCellsLTId.push(hoveredCellState.hoveredCell)
  }
  if (hoveredCellState.hoveredCell !== null && selectedLawCellsLTId.length === 3) {
    selectedLawCellsLTId.push(findFourthCell(selectedLawCellsLTId))
    
  }

  //console.log(selectedLawCellsLTId)
  

  if (isLoaded) {
    const rowList = Array.from({length: rowCount}, (_, rowId) => {
      return <Row 
      key={rowId} 
      rowId={rowId} 
      fullTableData={fullTableData} 
      setSelectedCell={setSelectedCell} 
      hoveredCellState={hoveredCellState} 
      selectedLawState={selectedLawState}
      modalsVisibility={modalsVisibility}
      emptyCellsData={emptyCells}
      />
    });
      return (
        <div className="tables" ref={ref}>
        {rowList}
        <LawsCanvas lawCells={ selectedLawCellsLTId}/>
        </div>
      )
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

function Row({rowId, fullTableData, setSelectedCell, hoveredCellState, selectedLawState, modalsVisibility, emptyCellsData}) {

  const isEven = (rowId % 2 === 0 ? 0 : 1)

  //console.log(emptyCellsData)

  const cellList = Array.from({length: cellCount - 1 - isEven}, (_, cellId) => {


    const cellFullId = rowId * 19 + isEven + cellId + 1 + Math.floor(rowId / 2)
    const cellData = fullTableData.tableData.find(cell => cell.id_lt === cellFullId)
    let hoverData = emptyCellsData.find(cell => cell.id_lt === cellFullId)
    let cellColor
    if (cellData) {
      if (cellData.id_gk) {
        const cellGKLayer = fullTableData.Colors.find((setting) => setting.id_gk === cellData.id_gk)
        const cellNormalColor = cellGKLayer.color
        cellColor = cellNormalColor
        //console.log(cellColor)
        hoverData.GKLayer = cellGKLayer

      }
    }

    return (<Cell 
            key={cellFullId} 
            cellFullData={{cellFullId,cellData,cellColor}} 
            cellRightClick={setSelectedCell} 
            hoveredCellState={hoveredCellState}
            hoverData={{hoveredCellState,hoverData}}
            selectedLawState={cellColor ? selectedLawState : undefined}
            modalsVisibility={modalsVisibility}
            isEmpty={cellColor ? false:true}
            />);
  });


  if (isEven) {
    return <div className="row"><div className="half-cell"></div>{cellList}</div>
  } else {
    return <div className="row">{cellList}</div>
  }

}

export function Cell({cellFullData, cellRightClick, selectedCells, revStates, setSelectedCell, selectedLawState, modalsVisibility,hoverData,isEmpty = false}) {

  const cellFullId = cellFullData.cellFullId
  const cellData = cellFullData.cellData
  const cellColor = cellFullData.cellColor
  const tableState = useContext(TableContext)
  const userInfoState = useContext(UserProfile)

  
  const handleCellRightClick = (event, cellId) => {
    
    event.preventDefault()


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

    console.log(selectedCells,cellData)

      cellData.lt_sign = tableState.tableData.find(cell => cell.id_lt !== cellData.id_lt).lt_sign

      tableState.setTableData(tableState.tableData.filter(cell => cell.id_lt !== cellData.id_lt).concat(cellData))


      revStates.setUndoStack([...revStates.undoStack, tableState.tableData]);
      revStates.setRedoStack([]);



      setSelectedCell(null)



  };

  const handleLawSelection = (event, cellId) => {

      const selectedCellData = tableState.tableData.find(cell => cell.id_lt === cellId)



      if (selectedLawState.selectedLaw.cells.map(cell=>cell.id_lt).find(cellId => cellId === selectedCellData.id_lt) === undefined && selectedLawState.selectedLaw.cells.length < 2) {
        selectedLawState.setSelectedLaw(
        {
          law_name: null,
          cells:[...selectedLawState.selectedLaw.cells,selectedCellData],
          id_type: null,
        } 
        );
      }
     
      if (selectedLawState.selectedLaw.cells.map(cell=>cell.id_lt).find(cellId => cellId === selectedCellData.id_lt) === undefined && selectedLawState.selectedLaw.cells.length === 2) {
        const selectedLawCellsLTId = selectedLawState.selectedLaw.cells.map(cell => cell.id_lt)
        selectedLawCellsLTId.push(selectedCellData.id_lt)
        const fourthCellData = tableState.tableData.find(cell => cell.id_lt === findFourthCell(selectedLawCellsLTId))
        selectedLawState.setSelectedLaw(
          {
            law_name: null,
            cells:[...selectedLawState.selectedLaw.cells,selectedCellData,fourthCellData],
            id_type: null,
          } 
          );
        //[...currentCells,selectedCellData,fourthCellData]



        const headers = {
          Authorization: `Bearer ${userInfoState.userToken}`
        }    
        getAllCellData([...selectedLawState.selectedLaw.cells,selectedCellData,fourthCellData].map(cell=>cell.id_value),headers,checkLaw)

      }

  }

  const checkLaw = (cells) => {


    //console.log(cells)

    const firstThirdCellsMLTI = {
      M: cells[0].m_indicate_auto + cells[2].m_indicate_auto,
      L: cells[0].l_indicate_auto + cells[2].l_indicate_auto,
      T: cells[0].t_indicate_auto + cells[2].t_indicate_auto,
      I: cells[0].i_indicate_auto + cells[2].i_indicate_auto
    }



    const secondFourthCellsMLTI = {
      M: cells[1].m_indicate_auto + cells[3].m_indicate_auto,
      L: cells[1].l_indicate_auto + cells[3].l_indicate_auto,
      T: cells[1].t_indicate_auto + cells[3].t_indicate_auto,
      I: cells[1].i_indicate_auto + cells[3].i_indicate_auto
    }

    const sameMLTI = JSON.stringify(firstThirdCellsMLTI) === JSON.stringify(secondFourthCellsMLTI)

    if (sameMLTI) {
      modalsVisibility.lawsModalVisibility.setVisibility(true)
    }
  }

  //const checkLawExistence = (selectedLaw)

  const handleCellHover = (event, cellData) => {

    hoverData.hoveredCellState.setHoveredCell(cellData)
    //console.log(selectedLawState.selectedLaw.cells)
  }


  const onClickEvent = (event) => {

    if (selectedCells) {handleCellLeftClick(event, cellFullId)};
    if (selectedLawState) {handleLawSelection(event, cellFullId)};
  }

  if (!isEmpty) {

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
          onClick={onClickEvent}
          onMouseOver={event => hoverData ? handleCellHover(event, hoverData.hoverData) : {}}
          cellnumber={cellFullId}
        >
          <div className='cell-name'>
          <span dangerouslySetInnerHTML={{__html: cellContent_name}}></span>
              <br />
          </div>
          <div className="su-pos" >
          <span dangerouslySetInnerHTML={{__html: cellContent_symbol}}></span>
              {(cellContent_unit === "") ? '' : ', '}
          <span dangerouslySetInnerHTML={{__html: cellContent_unit}}></span>   
              <br />
          </div>
          <div className="mlti-pos">
          <span dangerouslySetInnerHTML={{__html: cellContent_mlti}}></span>   
          </div>
        </div>
    );
  } else {
    return <div 
    className="cell-invisible cell" 
    onContextMenu={event => handleEmptyCellRightClick(event, cellFullId)} 
    onClick={onClickEvent} 
    id={`cell-${cellFullId}`} 
    cellnumber={cellFullId}
    onMouseOver={event => hoverData ? handleCellHover(event, hoverData.hoverData) : {}}
    ></div>
  }
  
}

function getRow(cellId) {
  return Math.floor(cellId/19.5)+1
}

function getColumn(cellId) {
  return cellId-(Math.floor(getRow(cellId)*19.5))+19
}

function findFourthCell(lawCells) {

  const firstAndSecondCellDifference = {x: getColumn(lawCells[1])-getColumn(lawCells[0]),y: getRow(lawCells[1])- getRow(lawCells[0])}

  const fourthCellCoords = {x: getColumn(lawCells[2])- firstAndSecondCellDifference.x, y:  getRow(lawCells[2]) - firstAndSecondCellDifference.y}

  const fourthCellId = Math.floor((fourthCellCoords.y-1)*19.5)+(fourthCellCoords.y%2 === 0 ? 1 : 0)+fourthCellCoords.x


  return fourthCellId
}

