import React, { useEffect, useState, useContext, forwardRef, useRef } from 'react';
import getData from './api';
import { TableContext } from './Contexts.js';

export default function LawsCanvas({lawCells}) {

  const canvasRef = useRef(null)
  
  useEffect(() => {
    drawLaw()
  }, [lawCells])

  const div = (val, by) => {
    return (val - val % by) / by;
  }

  const convertCellIdToCoords = (cellId) => {
    return {x:(getColumn(cellId)-1)*184+184-(getRow(cellId)%2)*92,y:(getRow(cellId)-1)*124+62}
  }


  const drawLaw = () => {

    if (lawCells.length === 0) {return}

    let cellsArray
    // if (lawCells.length === 3) {
    //   const fourthCellId = findFourthCell(lawCells)
    //   cellsArray = lawCells
    //   cellsArray.push(fourthCellId)

    // } else {cellsArray = lawCells}
    cellsArray = lawCells

    const canvas = canvasRef.current
    const ctx = canvas.getContext('2d')

    ctx.clearRect(0, 0, canvas.width, canvas.height);

    ctx.beginPath();
    const firstCellCoords = convertCellIdToCoords(cellsArray[0])
    ctx.moveTo(firstCellCoords.x,firstCellCoords.y)

    // console.log(firstCellCoords) 
    for (let i = 1;i < cellsArray.length;i++) {
    const cellCoords = convertCellIdToCoords(cellsArray[i])
    ctx.lineTo(cellCoords.x, cellCoords.y)  

    //console.log(cellsArray[i]) 
    //console.log(cellCoords) 
    }

    //console.log()

    ctx.lineTo(firstCellCoords.x,firstCellCoords.y)  
    ctx.stroke();

  }

  return (
    <canvas id='lawscanvas' ref={canvasRef} height={2537} width={3726}/>
  )
}

function getRow(cellId) {
  return Math.floor(cellId/19.5)+1
}

function getColumn(cellId) {
  return cellId-(Math.floor(getRow(cellId)*19.5))+19
}
