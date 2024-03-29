import {createRef} from 'react';
import {toJpeg} from "html-to-image";

export const useDownloadableScreenshot = (intl) => {
    const ref = createRef(null);

    const takeScreenShot = async (node) => {
        console.log(node)
        return await toJpeg(node, {quality:1, backgroundColor:"white", height:2662, width:3726, style:{maxHeight:"none"}});
    };

    const download = (image) => {
        const a = document.createElement("a");
        a.href = image;
        a.download = `${intl.formatMessage({id:`Представление.png`,defaultMessage: `Представление.png`})}`;
        a.click();
    };

    const getImage = () => takeScreenShot(ref.current).then(download);

    return { ref, getImage };
};
