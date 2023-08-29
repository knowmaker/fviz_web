import React, { useEffect, useState, useContext, forwardRef, useRef } from 'react';
import getData from './api';
import { TableContext } from './Contexts.js';

export default function LawsCanvas({lawCells}) {

  const canvasRef = useRef(null)
  
  useEffect(() => {
    drawLaw()
  }, [])

  const div = (val, by) => {
    return (val - val % by) / by;
  }

  const convertCellIdToCoords = (cellId) => {
    return {x:getColumn(cellId)*184+92*(div(cellId,19)%2)-92,y:getRow(cellId)*124+62}
  }


  const drawLaw = () => {

    let cellsArray
    if (lawCells.length === 3) {
      const fourthCellId = findFourthCell(lawCells)
      cellsArray = lawCells
      cellsArray.push(fourthCellId)

    } else {cellsArray = lawCells}

    const canvas = canvasRef.current
    const ctx = canvas.getContext('2d')

    ctx.clearRect(0, 0, canvas.width, canvas.height);

    const firstCellCoords = convertCellIdToCoords(cellsArray[0])
    ctx.moveTo(firstCellCoords.x,firstCellCoords.y)
    console.log(firstCellCoords) 
    for (let i = 1;i < cellsArray.length;i++) {
    const cellCoords = convertCellIdToCoords(cellsArray[i])
    ctx.lineTo(cellCoords.x, cellCoords.y)     
    //console.log(cellsArray[i]) 
    //console.log(cellCoords) 
    }
    ctx.lineTo(firstCellCoords.x,firstCellCoords.y)  
    ctx.stroke();

  }

  return (
    <canvas id='lawscanvas' ref={canvasRef} height={2537} width={3726}/>
  )
}

function div(val, by) {
  return (val - val % by) / by;
}

function getRow(cellId) {
  return div(cellId,19)
}

function getColumn(cellId) {
  return cellId%20
}

function findFourthCell(lawCells) {

  const firstAndSecondCellDifference = {x: getColumn(lawCells[1])-getColumn(lawCells[0]),y: getRow(lawCells[1])- getRow(lawCells[0])}

  const fourthCellCoords = {x: getColumn(lawCells[2])- firstAndSecondCellDifference.x, y:  getRow(lawCells[2]) - firstAndSecondCellDifference.y}

  const fourthCellId = fourthCellCoords.x + fourthCellCoords.y*19
  console.log(fourthCellId)

  return fourthCellId
}