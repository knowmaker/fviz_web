import {createRef} from 'react';
import {createFileName} from 'use-react-screenshot';
import {toJpeg} from "html-to-image";

export const useDownloadableScreenshot = () => {
    const ref = createRef(null);
    const takeScreenShot = async (node) => {
        return await toJpeg(node);
    };

    const download = (image, { name = "ФВиЗ_картина", extension = "jpg" } = {}) => {
        const a = document.createElement("a");
        a.href = image;
        a.download = createFileName(extension, name);
        a.click();
    };

    const getImage = () => takeScreenShot(ref.current).then(download);

    return { ref, getImage };
};
