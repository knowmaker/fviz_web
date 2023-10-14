import React, { useEffect } from 'react';
import Draggable from 'react-draggable';


export function Modal({ children, modalVisibility, title, hasBackground = false, sizeX = 500 }) {

  const modalStartPos = (window.innerWidth / 2) - Math.min(sizeX / 2, window.innerWidth / 2);

  useEffect(() => {

    if (modalVisibility.isVisible && hasBackground) {
      document.getElementById("modal-mask").classList.remove("hidden");
    }
    else {
      document.getElementById("modal-mask").classList.add("hidden");
    }
  }, [modalVisibility.isVisible, hasBackground]);

  const nodeRef = React.useRef(null);
  return (
    <Draggable
      handle=".modal-title2"
      defaultPosition={{ x: modalStartPos, y: -600 }}
      bounds="html"
      nodeRef={nodeRef}
      scale={1}
    >
      <div className={`drag-modal ${modalVisibility.isVisible ? "" : "hidden"}`} ref={nodeRef} style={{ maxWidth: sizeX }}>

        <div className="modal-title2">
          <span>{title}</span>
          <button type="button" className="btn-close" onClick={() => modalVisibility.setVisibility(false)}></button>
        </div>
        {children}
      </div>
    </Draggable>
  );
}
