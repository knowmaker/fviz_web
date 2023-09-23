import React, { useEffect, useState, useContext, forwardRef, useRef } from 'react';
import setStateFromGetAPI from '../misc/api';
import { TableContext } from '../misc/contexts.js';

export default function LawsCanvas({lawCells}) {

  const canvasRef = useRef(null)

  
  useEffect(() => {
    drawLaw()
  }, [lawCells])

  const convertCellIdToCoords = (cellId) => {
    return {x:(getColumn(cellId)-1)*184+184-(getRow(cellId)%2)*92,y:(getRow(cellId)-1)*124+62}
  }

  const getCorrectDrawOrder = (lawCells) => {

    const sortedCells = lawCells.sort()

    return [sortedCells[0],sortedCells[1],sortedCells[3],sortedCells[2]]

  }

  const drawLaw = () => {

    const canvas = canvasRef.current
    const ctx = canvas.getContext('2d')   

    ctx.clearRect(0, 0, canvas.width, canvas.height);    

    if (lawCells.length === 0) {return}

    const cellsArray = lawCells.length === 4 ? getCorrectDrawOrder(lawCells) : lawCells





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
