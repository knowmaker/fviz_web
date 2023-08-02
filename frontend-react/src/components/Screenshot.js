import { useEffect, createRef } from 'react';
import { useScreenshot, createFileName } from 'use-react-screenshot';

export const useDownloadableScreenshot = () => {
    const ref = createRef(null);
    const [image, takeScreenShot] = useScreenshot();

    const download = (image, { name = 'img', extension = 'png' } = {}) => {
        const a = document.createElement('a');
        a.href = image;
        a.download = createFileName(extension, name);
        a.click();
    };

    const getImage = () => {
        console.log("trying to photo");
        console.log(ref.current);
        takeScreenShot(ref.current);}

    useEffect(() => {
        if (image) {
            download(image, { name: 'lorem-ipsum', extension: 'png' });
        }
    }, [image]);

    return { ref, getImage };
};
