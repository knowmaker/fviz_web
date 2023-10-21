import React, { useEffect, useState, useContext } from 'react';
import setStateFromGetAPI, { putDataToAPI } from '../misc/api.js';
import { UserProfile } from '../misc/contexts.js';
import { EditorState } from 'draft-js';
import { isResponseSuccessful } from '../misc/api.js';
import { FormattedMessage, useIntl } from 'react-intl';
import { RichTextEditor } from '../components/RichTextEditor.js';
import { convertMarkdownFromEditorState } from '../pages/Home.js';
import { showMessage } from '../misc/message.js';
import { convertMarkdownToEditorState } from '../misc/converters.js';
import { Modal } from './Modal.js';
import { Button } from '../components/ButtonWithLoad.js';

export function GKColorModal({ modalsVisibility, GKLayersState }) {

  const userInfoState = useContext(UserProfile);

  const headers = {
    Authorization: `Bearer ${userInfoState.userToken}`
  };
  const GKLayers = GKLayersState.gkColors;
  const setGKLayers = GKLayersState.setGkColors;

  const [selectedGKLayer, setSelectedGKLayer] = useState({ type_name: null, id_type: null });
  const [GKLayerEditorState, setGKLayerEditorState] = useState(EditorState.createEmpty());

  let isAdmin = false;
  if (userInfoState.userProfile) {
    isAdmin = userInfoState.userProfile.role;
  }

  const intl = useIntl();

  useEffect(() => {
    if (modalsVisibility.GKColorsEditModalVisibility.isVisible === false && isAdmin) {
      convertMarkdownToEditorState(setGKLayerEditorState, "");
      document.getElementById("InputGKLayerColor3").value = "#000000";
    }
  }, [modalsVisibility.GKColorsEditModalVisibility.isVisible]);

  const selectGKLayer = (layer) => {

    // set this group as selected
    setSelectedGKLayer(layer);

    // set input to this group values
    convertMarkdownToEditorState(setGKLayerEditorState, layer.gk_name);
    document.getElementById("InputGKLayerColor3").value = layer.color;

  };

  const updateLawGroup = async () => {

    // get current input values
    const GKLayerName = convertMarkdownFromEditorState(GKLayerEditorState);
    const GKLayerColor = document.getElementById("InputGKLayerColor3").value;

    const newLawGroup = {
      gk: {
        gk_name: GKLayerName,
        color: GKLayerColor,
      }
    };

    // send group update request
    const changedGKLayerResponseData = await putDataToAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/gk/${selectedGKLayer.id_gk}`, newLawGroup, headers);
    if (!isResponseSuccessful(changedGKLayerResponseData)) {
      showMessage(changedGKLayerResponseData.data.error, "error");
      return;
    }

    // update current groups
    setStateFromGetAPI(setGKLayers, `${process.env.REACT_APP_API_LINK}/${intl.locale}/gk`, undefined, headers);

    // show message
    showMessage(intl.formatMessage({ id: `Системный уровень обновлен`, defaultMessage: `Системный уровень обновлен` }));

  };

  let GKLayersMarkup;
  if (GKLayers) {
    GKLayersMarkup = GKLayers.map(GKLayer => {

      const isCurrent = selectedGKLayer.id_gk === GKLayer.id_gk;

      return (
        <tr key={GKLayer.id_gk}>
          {isAdmin ?
            (<>
              <th scope="row" className='small-cell'>{isCurrent ? `+` : ""}</th>
            </>) : (null)}
          <td dangerouslySetInnerHTML={{ __html: GKLayer.gk_name }}></td>
          <td>G<sup>{GKLayer.g_indicate}</sup>K<sup>{GKLayer.k_indicate}</sup></td>
          <td><input type="color" className="form-control form-control-color disabled" value={GKLayer.color} readOnly onClick={(e) => { e.preventDefault(); }} /></td>
          {isAdmin ?
            (<>
              <td className='small-cell'><button type="button" className="btn btn-primary btn-sm" onClick={() => selectGKLayer(GKLayer)}>📝</button></td>
            </>) : (null)}
        </tr>
      );
    });
  } else { GKLayersMarkup = null; }



  return (
    <Modal
      modalVisibility={modalsVisibility.GKColorsEditModalVisibility}
      title={intl.formatMessage({ id: `Системные уровни`, defaultMessage: `Системные уровни` })}
      hasBackground={false}
      sizeX={600}
    >
      <div className="modal-content2">
        {isAdmin ?
          (<>
            <div className="row">
              <div className="col-2">
                <FormattedMessage id='Название' defaultMessage="Название" />:
              </div>
              <div className="col-5">
                <RichTextEditor editorState={GKLayerEditorState} setEditorState={setGKLayerEditorState} />
              </div>
              <div className="col-2">
                <Button type="button" className="btn btn-info" onClick={(e) => updateLawGroup(e)}><FormattedMessage id='Обновить' defaultMessage="Обновить" /></Button>
              </div>
            </div>
            <div className="row">
              <div className="col-2">
                <FormattedMessage id='Цвет' defaultMessage="Цвет" />:
              </div>
              <div className="col-5">
                <input type="color" className="form-control form-control-color" id="InputGKLayerColor3" />
              </div>
            </div>
          </>) : (null)}

        <table className="table">
          <thead>
            <tr>
              {isAdmin ?
                (<>
                  <th scope="col">#</th>
                </>) : (null)}
              <th scope="col"><FormattedMessage id='Имя' defaultMessage="Имя" /></th>
              <th scope="col">GK</th>
              <th scope="col"><FormattedMessage id='Цвет' defaultMessage="Цвет" /></th>
              {isAdmin ?
                (<>
                  <th scope="col"><FormattedMessage id='Выбрать' defaultMessage="Выбрать" /></th>
                </>) : (null)}
            </tr>
          </thead>
          <tbody>
            {GKLayersMarkup}
          </tbody>
        </table>

      </div>

    </Modal>
  );
}
