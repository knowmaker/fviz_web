import React, { useEffect, useRef } from 'react';

export default function LawsCanvas({lawCells,color}) {

  const canvasRef = useRef(null)

  
  useEffect(() => {
    drawLaw()
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [lawCells])

  const convertCellIdToCoords = (cellId) => {
    return {x:(getColumn(cellId)-1)*184+184-(getRow(cellId)%2)*92,y:(getRow(cellId)-1)*124+62}
  }

  const getCorrectDrawOrder = (lawCells) => {

    const sortedCells = lawCells.sort((a,b)=>a-b)

    return [sortedCells[0],sortedCells[1],sortedCells[3],sortedCells[2]]

  }

  const drawLaw = () => {

    const canvas = canvasRef.current
    const ctx = canvas.getContext('2d')   

    ctx.clearRect(0, 0, canvas.width, canvas.height);    

    if (lawCells.length === 0) {return}

    const cellsArray = lawCells.length === 4 ? getCorrectDrawOrder(lawCells) : lawCells



    ctx.strokeStyle = color

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
