import React from 'react';
import { useIntl } from 'react-intl';
import { Modal } from './Modal';

export function GKLayersImageModal({ modalVisibility }) {

  const intl = useIntl();

  return (
    <Modal
      modalVisibility={modalVisibility}
      title={intl.formatMessage({ id: `Соотношение уровней GK`, defaultMessage: `Соотношение уровней GK` })}
      sizeX={600}
    >
      <div className="modal-content2">
        <img src="/image.png" alt="Loading" className='GK-layers-image' />
      </div>

    </Modal>
  );
}
