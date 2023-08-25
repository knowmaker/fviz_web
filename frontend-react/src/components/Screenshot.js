import {createRef} from 'react';
import {toJpeg} from "html-to-image";

export const useDownloadableScreenshot = () => {
    const ref = createRef(null);
    const takeScreenShot = async (node) => {
        return await toJpeg(node);
    };

    const download = (image) => {
        const a = document.createElement("a");
        a.href = image;
        a.download = "image.jpg";
        a.click();
    };

    const getImage = () => takeScreenShot(ref.current).then(download);

    return { ref, getImage };
};
