import React, { useEffect, useState, createContext } from 'react';
import MathJax from 'react-mathjax';
import axios from 'axios';
import Navbar from './Navbar';


const rowCount = 20
const cellCount = 20
//const TableContext = createContext(null)

//todo:
//rewrite prev code .... done
//refactor this code with "createContext"
//add ability to redact elements
//db saving??? 


export default function TableUI() {


  const [tableData, setTableData] = useState([]);
  const [gkColors, setGkColors] = useState([]);
  
  const [undoStack, setUndoStack] = useState([]);
  const [redoStack, setRedoStack] = useState([]);
  const [selectedCell, setSelectedCell] = useState(null);

  const revStates = {undoStack,setUndoStack,redoStack,setRedoStack}

  useEffect(() => {
  requestData(setTableData,'http://127.0.0.1:5000/api/quantities')
  requestData(setGkColors,'http://127.0.0.1:5000/api/gk_settings')
  }, []);

  return (
    <MathJax.Provider>
      <Navbar tableState={{tableData,setTableData}} revStates={revStates} />
      <CellOptions selectedCell={selectedCell} gkColors={gkColors} tableState={{tableData,setTableData}} revStates={revStates} setSelectedCell={setSelectedCell}/>
      <Table2 tableData={tableData} gkColors={gkColors} setSelectedCell={setSelectedCell}/>
    </MathJax.Provider>
    );
}

function CellOptions({selectedCell,gkColors, tableState, revStates, setSelectedCell}) {

  if (selectedCell !== null) {


    const cells = selectedCell.map(cellData => {

      const cellFullId = cellData.id_value
      const cellColor = `#${gkColors.find((setting) => setting.id_gk === cellData.id_gk).gk_color}`

      return (
        <Cell key={cellFullId} cellFullId={cellFullId} cellData={cellData} cellColor={cellColor} selectedCells={selectedCell} tableState={tableState} revStates={revStates} cellRightClick={setSelectedCell}/>
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

function Table2({tableData,gkColors,setSelectedCell}) {

  const fullTableData = { tableData: tableData, Colors: gkColors};



  console.log(tableData)

  const isLoaded = tableData.length !== 0 && gkColors.length !== 0

  if (isLoaded) {
    const rowList = Array.from({length: rowCount}, (_, rowId) => {
      return <Row key={rowId} rowId={rowId} fullTableData={fullTableData} setSelectedCell={setSelectedCell} />
    });
     return <div className="table">{rowList}</div>
  }
  else
  {
     return (
      <div className="loading">
          <img src="/loading.gif" alt="Loading" />
      </div>
     )
  }

}

function Row({rowId, fullTableData, setSelectedCell}) {
  const cellList = Array.from({length: cellCount - 1 + (rowId % 2 === 0 ? 0 : 1)}, (_, cellId) => {

    const cellFullId = rowId * 19 + (rowId % 2 === 0 ? 0 : 1) + cellId + 1 + Math.floor(rowId / 2)
    const cellData = fullTableData.tableData.find(cell => cell.id_lt === cellFullId)
    const cellColor = cellData ? `#${fullTableData.Colors.find((setting) => setting.id_gk === cellData.id_gk).gk_color}` : '';

    return <Cell key={cellFullId} cellFullId={cellFullId} cellData={cellData} cellColor={cellColor} cellRightClick={setSelectedCell}/>
  });

  return <div className="row">{cellList}</div>
}

function Cell({cellFullId,cellData,cellColor, cellRightClick, selectedCells, tableState, revStates}) {

  const splitLatexText = (text) => {
    return text.split(' ').map((word, index) => (
        <React.Fragment key={index}>
            <MathJax.Node inline formula={word} />
            {' '}
        </React.Fragment>
    ));
  };
  
  const handleCellRightClick = (event, cellId) => {
    
    //need to fix this 
    if (cellRightClick) {
      event.preventDefault()
      console.log(cellId)
      requestData(cellRightClick,`http://127.0.0.1:5000/api/cell/${cellId}`)
    }

  };

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
      console.log(revStates.undoStack)
      console.log(revStates.redoStack)
      cellRightClick(null)
    }

  };

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
        >
          <div>
              {splitLatexText(cellContent_name)}
              <br />
          </div>
          <div className="su-pos">
              <MathJax.Node inline formula={cellContent_symbol} />
              {', '}
              <MathJax.Node inline formula={cellContent_unit} />
              <br />
          </div>
          <div className="mlti-pos">
              <MathJax.Node inline formula={cellContent_mlti} />
          </div>
        </div>
    );
  } else {
    return <div className="cell-invisible"></div>
  }
  
}

function Formula({formula}) {
  return (
    <MathJax.Node inline formula={formula} />
  );
}


// function calculateCellId(cellIndex,rowIndex) {
//   return (rowIndex * 19 + (rowIndex % 2 === 0 ? 0 : 1) + cellIndex + 1 + Math.floor(rowIndex / 2))
// }

// interactions with database

function requestData(setStateFunction, adress) {

  axios
      .get(adress)
      .then((response) => {
          setStateFunction(response.data);
      })
      .catch((error) => {
          console.error(error);
      });

}

