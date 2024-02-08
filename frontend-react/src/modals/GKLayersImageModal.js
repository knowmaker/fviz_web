import React from 'react';
import { useIntl } from 'react-intl';
import { Modal } from './Modal';

export function GKLayersImage({ modalVisibility }) {

  const intl = useIntl();

  console.log(modalVisibility.isVisible)
  if (modalVisibility.isVisible) {
    return (
      // <Modal
      //   modalVisibility={modalVisibility}
      //   title={intl.formatMessage({ id: `Соотношение уровней GK`, defaultMessage: `Соотношение уровней GK` })}
      //   sizeX={600}
      // >
      //   <div className="modal-content2">
  
      //   </div>
  
      // </Modal>
            <div className="data-window data-window-bottom">
            <div className="data-window-top">
            <span></span>
            <button type="button" className="btn-close" onClick={() => modalVisibility.setVisibility(false)}></button>
            </div>
            <img src="/image.png" alt="Loading" className='GK-layers-image' />
          </div>
    );
  } else {
    return null
  }

}
