import React, { useEffect, useState, useContext, forwardRef, useRef } from 'react';
import Navbar from './Navbar';
import { TableContext, UserProfile } from '../misc/contexts.js';

import setStateFromGetAPI, {getAllCellDataFromAPI} from '../misc/api.js';
import LawsCanvas from './LawsCanvas';
import {showMessage} from '../pages/Home.js';
import { isResponseSuccessful } from '../misc/api';
import { convertToMLTI } from '../pages/Home.js';
import {FormattedMessage,useIntl} from 'react-intl'
import { convertMarkdownFromEditorState,convertMarkdownToEditorState } from '../pages/Home.js';
// const Color = require('color');

const rowCount = 21
const cellCount = 20

export default function TableUI({modalsVisibility, gkState, selectedCellState, revStates, selectedLawState,hoveredCellState,refTable,lawsGroupsState ,lawsState,currentLocaleState,lawEditorsStates}) {

  const [once, setOnce] = useState(true);
  const tableState = useContext(TableContext)

  useEffect(() => {

  if (document.getElementById("cell-204") !== null && once) {
    document.getElementById("cell-204").scrollIntoView({ behavior: "smooth", block: "center", inline: "center" });
    setOnce(false)
  }

  }, [tableState]);



 
  return (
    <>
      <Navbar revStates={revStates} modalsVisibility={modalsVisibility} selectedCell={selectedCellState.selectedCell} currentLocaleState={currentLocaleState}/>
      <CellOptions selectedCellState={selectedCellState} gkColors={gkState.gkColors} revStates={revStates} />
      <Table 
      gkColors={gkState.gkColors} 
      selectedCellState={selectedCellState} 
      hoveredCellState={hoveredCellState} 
      selectedLawState={selectedLawState} 
      ref={refTable} 
      modalsVisibility={modalsVisibility} 
      lawsGroupsState={lawsGroupsState} 
      lawsState={lawsState}
      lawEditorsStates={lawEditorsStates}
      />
      <LawOptions lawsState={lawsState} lawsGroupsState={lawsGroupsState} selectedLawState={selectedLawState} lawEditorsStates={lawEditorsStates} modalsVisibility={modalsVisibility}/>
    </>  
    );
}

function CellOptions({selectedCellState ,gkColors, revStates}) {

  const selectedCell = selectedCellState.selectedCell
  const setSelectedCell = selectedCellState.setSelectedCell

  const [cellAlternatives, setCellAlternatives] = useState(null);

  const intl = useIntl()

  useEffect(() => {
    if (selectedCell) {
      setStateFromGetAPI(setCellAlternatives,`${process.env.REACT_APP_API_LINK}/${intl.locale}/layers/${selectedCell.id_lt}`) 
    } else {setCellAlternatives(null)}
  }, [selectedCell]);



  if (cellAlternatives !== null && selectedCell) {

    const emptyCellData = {id_lt:selectedCell.id_lt,id_value:-1,unit:""}  
    const emptyCellShowData = {id_lt:selectedCell.id_lt,id_value:-1,unit:"",value_name:"<<Скрыть>>"}    

    let cells = cellAlternatives.filter(cellData => cellData.id_value !== selectedCell.id_value).map(cellData => {

      const cellFullId = cellData.id_value
      const cellColor = `${gkColors.find((setting) => setting.id_gk === cellData.id_gk).color}`


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


    if (selectedCell.id_gk) {
      cells.push(
        <Cell 
        key={-1} 
        cellFullData={{cellFullId:-1,cellData:emptyCellShowData,cellColor:"#CCCCCC"}}
        selectedCells={cellAlternatives.concat(emptyCellData)} 
        revStates={revStates} 
        setSelectedCell={setSelectedCell}
        className="fancy-empty-cell"
        />
      )  
    }

    const cellOptions = cells.length !== 0 ? cells : intl.formatMessage({id:`Нет альтернативных ячеек`,defaultMessage: `Нет альтернативных ячеек`})



    return (
      <div className="data-window">
        <div className="data-window-top">
        <span><FormattedMessage id='Другие уровни' defaultMessage="Другие уровни"/></span>
        <button type="button" className="btn-close" onClick={() => setSelectedCell(null)}></button>
        </div>
        {cellOptions}
      </div>
    );




  } else {
    return null
  }

  
}

function LawOptions({lawsState,lawsGroupsState,selectedLawState,lawEditorsStates,modalsVisibility}) {

  const tableState = useContext(TableContext)
  const userInfoState = useContext(UserProfile) 
  const headers = {
    Authorization: `Bearer ${userInfoState.userToken}`
  }  
  const intl = useIntl()
  
  const selectLaw = async (selectedLaw) => {

    // get all cell Id's into an array
    const lawCellsIds = [selectedLaw.first_element,selectedLaw.second_element,selectedLaw.third_element,selectedLaw.fourth_element]
   
    // get all required cells from API
    const lawCellsResponse = await getAllCellDataFromAPI(lawCellsIds,headers)
    if (!isResponseSuccessful(lawCellsResponse[0])) {
      showMessage(lawCellsResponse[0].data.error,"error")
      return
    }
    const lawCells = lawCellsResponse.map(cellResponse => cellResponse.data.data)

    // set request law as selected
    selectedLawState.setSelectedLaw({law_name: selectedLaw.law_name,cells:lawCells,id_type:selectedLaw.id_type,id_law:selectedLaw.id_law})

    // update cells to reflect new law
    let newTable = tableState.tableData
    lawCells.forEach(cellData => {
      newTable = newTable.filter(cell => cell.id_lt !== cellData.id_lt).concat(cellData)
    })
    tableState.setTableData(newTable)

    // show message
    showMessage(intl.formatMessage({id:`Закон выбран`,defaultMessage: `Закон выбран`}))

  }

  const editLaw = async (selectedLaw) => {

    convertMarkdownToEditorState(lawEditorsStates.lawNameEditorState.set, selectedLaw.law_name)

    lawEditorsStates.lawGroupEditorState.set(selectedLaw.id_type)

    selectLaw(selectedLaw)

    modalsVisibility.lawsModalVisibility.setVisibility(true)

  }

  const lawsGroups = lawsGroupsState.lawsGroups

  if (!lawsState.laws || !lawsGroups) {
    return null
  }

  const lawOptions = [...lawsGroups,{ type_name:"Без группы",id_type:null}].map((lawGroup) => {

  const lawsInThisGroup = lawsState.laws.filter(law => law.id_type === lawGroup.id_type)
      

    if (lawsInThisGroup.length === 0) {
      return (
        <details key={lawGroup.id_type}>
        <summary>{lawGroup.type_name}</summary>
        <FormattedMessage id='Законов нет' defaultMessage="Законов нет"/>
        </details>
      )
    }
      
    const lawsInThisGroupMarkup = lawsInThisGroup.map(law => {

      const isCurrent = selectedLawState.selectedLaw.id_law === law.id_law

      return (
        <tr key={law.id_law}>
          <th scope="row" className='small-cell'>{isCurrent ?  `+` : ''}</th>
          <td onClick={() => {selectLaw(law)}} className="hover-table-cell" dangerouslySetInnerHTML={{__html: law.law_name}}/>
          <td className='small-cell'><button type="button" className="btn btn-primary btn-sm" onClick={() => editLaw(law)}>↓</button></td>
        </tr>
      )
    })



    return (

      <details key={lawGroup.id_type}>
        <summary>{lawGroup.type_name}</summary>
          <table className="table">
          <thead>
            <tr>
              <th scope="col">#</th>
              <th scope="col"><FormattedMessage id='Название' defaultMessage="Название"/></th>
              <th scope="col">ⓘ</th>
            </tr>
          </thead>
          <tbody>
            {lawsInThisGroupMarkup}
          </tbody>
        </table>
      </details>

    )

  })

  if (modalsVisibility.LawsMenuVisibility.isVisible) {

    return (

      <div className="data-window data-window-left">
        <div className="data-window-top">
        <span><FormattedMessage id='Выбор закона' defaultMessage="Выбор закона"/></span>
        <button type="button" className="btn-close" onClick={() => {modalsVisibility.LawsMenuVisibility.setVisibility(false)}}></button>
        </div>
        {lawOptions}
      </div>
  
    )
  } else {return null}



}

const Table = forwardRef(({ gkColors, selectedCellState, hoveredCellState, selectedLawState,modalsVisibility,lawsGroupsState,lawsState,lawEditorsStates}, ref) => {


  const tableState = useContext(TableContext)
  const tableData = tableState.tableData
  const fullTableData = { tableData: tableData, Colors: gkColors};

  const [emptyCells, setEmptyCells] = useState([]);

  const isLoaded = tableData.length !== 0 && gkColors.length !== 0 && emptyCells.length !== 0 

  const intl = useIntl()

  useEffect(() => {

    setStateFromGetAPI(setEmptyCells, `${process.env.REACT_APP_API_LINK}/${intl.locale}/lt`)

  }, []);

  let zoom = useRef(undefined)
  let scale = useRef(1)
  let panning = useRef(false)
  let pointX = useRef(1109)
  let pointY = useRef(973)
  let start = useRef({ x: 0, y: 0 })

  if (document.getElementById("table") && zoom.current === undefined) {
    zoom.current = document.getElementById("table")
  }

  if (zoom.current !== undefined) {

  }

  useEffect(() => {
  
    if (zoom.current) {



    function setTransform() {
      document.getElementById("table-scale").style.transform = "scale(" + scale.current + ")";
      zoom.current.scrollTop = 1947 - pointY.current;
      zoom.current.scrollLeft = 1841 - pointX.current;
      
    }

    zoom.current.onscroll =  function (e) {

      pointY.current = 1947 - zoom.current.scrollTop
      pointX.current = 1841 - zoom.current.scrollLeft 
      pointY.current = pointY.current>1947 ? 1947 : pointY.current
      pointX.current = pointX.current>1841 ? 1841 : pointX.current
    }

    zoom.current.onmousedown = function (e) {
      e.preventDefault();
      start.current = { x: e.clientX - pointX.current, y: e.clientY - pointY.current };
      panning.current = true;
    }

    zoom.current.onmouseup = function (e) {
      panning.current = false;
    }

    zoom.current.onmousemove = function (e) {
      e.preventDefault();
      if (!panning.current) {
        return;
      }
      pointX.current = (e.clientX - start.current.x);
      pointY.current = (e.clientY - start.current.y);
      setTransform();
    }

    zoom.current.onwheel = function (e) {
      e.preventDefault();
      // var xs = (e.clientX - pointX.current) / scale.current,
      //   ys = (e.clientY - pointY.current) / scale.current,
      //   delta = (e.wheelDelta ? e.wheelDelta : -e.deltaY);
      // (delta > 0) ? (scale.current *= 1.2) : (scale.current /= 1.2);
      // if (scale.current > 1.2**3) {scale.current = 1.2**3}
      // if (scale.current < 1.2**-3) {scale.current = 1.2**-3}
      // console.log(scale.current)
      // console.log(pointX.current - (e.clientX - (xs) * scale.current))
      // console.log(pointY.current - (e.clientY - (ys) * scale.current))
      // pointX.current = e.clientX - (xs) * scale.current;
      // pointY.current = e.clientY - (ys) * scale.current;

      // setTransform();
    }
  }

  }, [zoom.current]);
    


  let selectedLawCellsLTId = selectedLawState.selectedLaw.cells.map(cell => cell.id_lt)

  if (hoveredCellState.hoveredCell !== null && selectedLawCellsLTId.length >= 1 && selectedLawCellsLTId.length < 3) {
    selectedLawCellsLTId.push(hoveredCellState.hoveredCell.id_lt)
  }


  if (hoveredCellState.hoveredCell !== null && selectedLawCellsLTId.length === 3) {
    selectedLawCellsLTId.push(findFourthCell(selectedLawCellsLTId))
  }



  const selectedLawGroup = lawsGroupsState.lawsGroups.find(group => group.id_type === selectedLawState.selectedLaw.id_type)

  let color = "#000000"
  if (selectedLawGroup) {
    color = selectedLawGroup.color
  }



  if (isLoaded) {
    const rowList = Array.from({length: rowCount}, (_, rowId) => {
      return <Row 
      key={rowId} 
      rowId={rowId} 
      fullTableData={fullTableData} 
      selectedCellState={selectedCellState} 
      hoveredCellState={hoveredCellState} 
      selectedLawState={selectedLawState}
      modalsVisibility={modalsVisibility}
      emptyCellsData={emptyCells}
      lawsState={lawsState}
      lawEditorsStates={lawEditorsStates}
      />
    });
      return (
        <div className="tables" id='table' ref={ref}>
          <div id='table-scale'>
            {rowList}
            <LawsCanvas lawCells={ selectedLawCellsLTId} color={color}/>
          </div>
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

function Row({rowId, fullTableData, selectedCellState, hoveredCellState, selectedLawState, modalsVisibility, emptyCellsData,lawsState,lawEditorsStates}) {

  const isEven = (rowId % 2 === 0 ? 0 : 1)
  const setSelectedCell = selectedCellState.setSelectedCell



  const cellList = Array.from({length: cellCount - isEven}, (_, cellId) => {


    const cellFullId = rowId * 19 + isEven + cellId + 1 + Math.floor(rowId / 2)
    let cellData = fullTableData.tableData.find(cell => cell.id_lt === cellFullId)
    let hoverData = emptyCellsData.find(cell => cell.id_lt === cellFullId)
    let cellColor
    let borderColor
    if (cellData) {
      if (cellData.id_gk) {
        const cellGKLayer = fullTableData.Colors.find((setting) => setting.id_gk === cellData.id_gk)
        const cellNormalColor = cellGKLayer.color
        cellColor = cellNormalColor

        hoverData.GKLayer = cellGKLayer

        if (selectedCellState.selectedCell) {

          borderColor = cellData.id_value === selectedCellState.selectedCell.id_value ? "orange" : ""

        }
        if (selectedLawState.selectedLaw) {

          borderColor = selectedLawState.selectedLaw.cells.find(lawCell => lawCell.id_value === cellData.id_value) ? "red" : borderColor
        }
      }
    } else {
      cellData = emptyCellsData.find(cell => cell.id_lt === cellFullId)
      cellData.id_value = -1
    }

    return (<Cell 
            key={cellFullId} 
            cellFullData={{cellFullId,cellData,cellColor,borderColor}} 
            cellRightClick={setSelectedCell} 
            hoveredCellState={hoveredCellState}
            hoverData={{hoveredCellState,hoverData}}
            selectedLawState={cellColor ? selectedLawState : undefined}
            modalsVisibility={modalsVisibility}
            isEmpty={cellColor ? false:true}
            lawsState={lawsState}
            lawEditorsStates={lawEditorsStates}
            />);
  });


  if (isEven) {
    return (<div className="row">
      <div className="half-cell"></div>
      {cellList}
      </div>)
  } else {
    return <div className="row">{cellList}</div>
  }

}

export function Cell({cellFullData, cellRightClick, selectedCells, revStates, setSelectedCell, selectedLawState, modalsVisibility,hoverData,isEmpty = false, className = "",lawsState,lawEditorsStates}) {

  const cellFullId = cellFullData.cellFullId
  const cellData = cellFullData.cellData
  const cellColor = cellFullData.cellColor
  const borderColor = cellFullData.borderColor
  const tableState = useContext(TableContext)
  const userInfoState = useContext(UserProfile)
  const headers = {
    Authorization: `Bearer ${userInfoState.userToken}`
  }  

  const intl = useIntl()

  
  const handleCellRightClick = (event) => {
    
    event.preventDefault()
    


    cellRightClick(cellData)

  };

  const handleCellLeftClick = (event, cellId) => {
    

      event.preventDefault()

      
      const cellData = selectedCells.find(cell => cell.id_value === cellId);

      tableState.setTableData(tableState.tableData.filter(cell => cell.id_lt !== cellData.id_lt).concat(cellData))

      revStates.setUndoStack([...revStates.undoStack, tableState.tableData]);
      revStates.setRedoStack([]);

      setSelectedCell(null)



  };

  const handleLawSelection = async (event, cellId) => {

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

        if (!fourthCellData) {
          selectedLawState.setSelectedLaw({law_name: null,cells:[],id_type: null})
          showMessage("Выбрана пустая ячейка")
  
          return
        }

        if (lawsState.laws) {
          const dublicateLaw = lawsState.laws.find(law => {
            const lawInArray = [law.first_element,law.second_element,law.third_element,law.fourth_element]
            const currentLaw = [...selectedLawState.selectedLaw.cells,selectedCellData,fourthCellData].map(cell=>cell.id_value)
            return arraysEqual(lawInArray,currentLaw)
          })
          
          if (dublicateLaw) {
            const lawCellsIds = [dublicateLaw.first_element,dublicateLaw.second_element,dublicateLaw.third_element,dublicateLaw.fourth_element]
            
            const lawCellsFullData = lawCellsIds.map(cellId => tableState.tableData.find(tableCell => tableCell.id_value === cellId))
  
            modalsVisibility.lawsModalVisibility.setVisibility(true)
            
            selectedLawState.setSelectedLaw({
              ...dublicateLaw,
              cells:lawCellsFullData,
            })
            convertMarkdownToEditorState(lawEditorsStates.lawNameEditorState.set, dublicateLaw.law_name)
            lawEditorsStates.lawGroupEditorState.set(dublicateLaw.id_type)
  
  
            showMessage(intl.formatMessage({id:`Закон существует`,defaultMessage: `Этот закон уже существует`}),"warn")
  
  
            return
          }
        }

        selectedLawState.setSelectedLaw(
          {
            law_name: null,
            cells:[...selectedLawState.selectedLaw.cells,selectedCellData,fourthCellData],
            id_type: null,
          } 
          );

        const lawCellsResponse = await getAllCellDataFromAPI([...selectedLawState.selectedLaw.cells,selectedCellData,fourthCellData].map(cell=>cell.id_value),headers)
        if (!isResponseSuccessful(lawCellsResponse[0])) {
          showMessage(lawCellsResponse[0].data.error,"error")
          return
        }
        const lawCells = lawCellsResponse.map(cellResponse => cellResponse.data.data)

        const isCorrectLaw = checkLaw(lawCells)

        if (!isCorrectLaw) {
          selectedLawState.setSelectedLaw({law_name: null,cells:[],id_type: null})
          showMessage(intl.formatMessage({id:"Данного закона не существует",defaultMessage: "Данного закона не существует"}),"error")
          return
        }

        convertMarkdownToEditorState(lawEditorsStates.lawNameEditorState.set, "")
        lawEditorsStates.lawGroupEditorState.set(-1)

        showMessage(intl.formatMessage({id:`Закон выбран`,defaultMessage: `Закон выбран`}))

        if (lawsState.laws) {
        modalsVisibility.lawsModalVisibility.setVisibility(true)
        }
      }

  }



  const handleCellHover = (event, cellData) => {
    hoverData.hoveredCellState.setHoveredCell(cellData)
  }


  const onClickEvent = (event) => {

    if (selectedCells) {handleCellLeftClick(event, cellFullId)};
    if (selectedLawState) {handleLawSelection(event, cellFullId)};
  }

  if (!isEmpty) {


    const cellContent_name = cellData.value_name;
    const cellContent_symbol = cellData.symbol;
    const cellContent_unit = cellData.unit;
    const cellContent_mlti = convertToMLTI(cellData.m_indicate_auto,cellData.l_indicate_auto,cellData.t_indicate_auto,cellData.i_indicate_auto);



    return (
      <div className="cell" style={{ backgroundColor: borderColor }}>
        <div
          className={`inner-cell ${className}`}
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
              {(cellContent_unit === "\n" || cellContent_unit === "") ? '' : ', '}
          <span dangerouslySetInnerHTML={{__html: cellContent_unit}}></span>   
              <br />
          </div>
          <div className="mlti-pos">
          <span dangerouslySetInnerHTML={{__html: cellContent_mlti}}></span>   
          </div>
        </div>
      </div>
    );
  } else {
    return (  
    <div className="cell-invisible cell">
      <div 
      className="cell-invisible inner-cell" 
      onContextMenu={event => handleCellRightClick(event, cellFullId)} 
      onClick={onClickEvent} 
      id={`cell-${cellFullId}`} 
      cellnumber={cellFullId}
      onMouseOver={event => hoverData ? handleCellHover(event, hoverData.hoverData) : {}}
      />
    </div>
    )
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
  const firstCellRow = getRow(lawCells[0])
  const secondCellRow = getRow(lawCells[1])
  const thirdCellRow = getRow(lawCells[2])


  let fourthCellCoords = {x: getColumn(lawCells[2])- firstAndSecondCellDifference.x, y:  getRow(lawCells[2]) - firstAndSecondCellDifference.y}
  if (((firstCellRow % 2) === (thirdCellRow % 2) && (secondCellRow % 2 ) !== (thirdCellRow % 2))) {
    fourthCellCoords = {x: fourthCellCoords.x + ((firstCellRow % 2 === 0) ? 1:-1) ,y: fourthCellCoords.y}
  }

  const cellId = (fourthCellCoords.y-1) * 19 + ((fourthCellCoords.y-1) % 2 === 0 ? 0 : 1) + (fourthCellCoords.x-1) + 1 + Math.floor((fourthCellCoords.y-1) / 2)


  return cellId
}

export function checkLaw(cells) {

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

  const isSameMLTI = JSON.stringify(firstThirdCellsMLTI) === JSON.stringify(secondFourthCellsMLTI)

  return isSameMLTI
}

function arraysEqual(a, b) {
  if (a === b) return true;
  if (a == null || b == null) return false;
  if (a.length !== b.length) return false;

  let aSorted = a.toSorted()
  let bSorted = b.toSorted()

  for (let i = 0; i < aSorted.length; ++i) {
    if (aSorted[i] !== bSorted[i]) return false;
  }
  return true;
}