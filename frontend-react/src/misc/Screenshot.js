import {createRef} from 'react';
import {toJpeg} from "html-to-image";

export const useDownloadableScreenshot = () => {
    const ref = createRef(null);
    const takeScreenShot = async (node) => {
        console.log(node)
        return await toJpeg(node, {quality:1, backgroundColor:"white", height:2662, width:3726, style:{maxHeight:"none"}});
    };

    const download = (image) => {
        const a = document.createElement("a");
        a.href = image;
        a.download = "представление.jpg";
        a.click();
    };

    const getImage = () => takeScreenShot(ref.current).then(download);

    return { ref, getImage };
};

// import { createRef } from 'react';
// import { toJpeg } from 'html-to-image';
//
// export const useDownloadableScreenshot = () => {
//     const ref = createRef(null);
//
//     const shouldHideCell = (cell) => {
//         const cellRect = cell.getBoundingClientRect();
//         const elementsBelow = document.elementsFromPoint(
//             cellRect.left + cellRect.width / 2,
//             cellRect.bottom + 100 // Проверяем элементы на 100px вниз от нижней грани элемента
//         );
//
//         // Проверяем, есть ли другие элементы с классом CELL-INVISIBLE снизу
//         return !elementsBelow.some((element) => element.classList.contains('cell-invisible'));
//     };
//
//     const takeScreenShot = async (node) => {
//         // Создаем копию узла, чтобы не изменять оригинальный DOM
//         const clonedNode = node.cloneNode(true);
//
//         // Получаем все элементы с классом CELL-INVISIBLE
//         const invisibleCells = clonedNode.querySelectorAll('.cell-invisible');
//
//         // Скрываем элементы, которые не имеют других элементов CELL-INVISIBLE снизу
//         invisibleCells.forEach((cell) => {
//             if (shouldHideCell(cell)) {
//                 cell.style.display = 'none';
//             }
//         });
//
//         // Создаем снимок экрана
//         const image = await toJpeg(clonedNode, {
//             quality: 1,
//             backgroundColor: 'white',
//             height: 2662,
//             width: 3726,
//             style: { maxHeight: 'none' },
//         });
//
//         // Восстанавливаем оригинальные стили элементов
//         invisibleCells.forEach((cell) => {
//             cell.style.display = ''; // Убираем стиль "display: none"
//         });
//
//         return image;
//     };
//
//     const download = (image) => {
//         const a = document.createElement('a');
//         a.href = image;
//         a.download = 'представление.jpg';
//         a.click();
//     };
//
//     const getImage = () => takeScreenShot(ref.current).then(download);
//
//     return { ref, getImage };
// };
