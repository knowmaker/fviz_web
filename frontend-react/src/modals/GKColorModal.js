import React, { useEffect, useState, useContext } from 'react';
import setStateFromGetAPI, { putDataToAPI,getDataFromAPI } from '../misc/api.js';
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

export function GKLayersModal({ modalsVisibility, GKLayersState }) {

  const userInfoState = useContext(UserProfile);

  const headers = {
    Authorization: `Bearer ${userInfoState.userToken}`
  };
  const GKLayers = GKLayersState.gkColors;
  const setGKLayers = GKLayersState.setGkColors;

  const [selectedGKLayer, setSelectedGKLayer] = useState({ en:{gk_name: null},ru:{gk_name:null}, id_gk: null,color:null });
  const [GKLayerEditorState, setGKLayerEditorState] = useState(EditorState.createEmpty());

  let isAdmin = false;
  if (userInfoState.userProfile) {
    isAdmin = userInfoState.userProfile.role;
  }

  const intl = useIntl();

  const [currentModalLocale, setCurrentModalLocale] = useState("ru");

  useEffect(() => {
    if (modalsVisibility.GKColorsEditModalVisibility.isVisible === false && isAdmin) {
      convertMarkdownToEditorState(setGKLayerEditorState, "");
      document.getElementById("InputGKLayerColor3").value = "#000000";
    }
    if (modalsVisibility.GKColorsEditModalVisibility.isVisible === true && isAdmin) {
      setCurrentTabsLocale(intl.locale)
    } else {
      setSelectedGKLayer({ en:{gk_name: null},ru:{gk_name:null}, id_gk: null,color:null })
    }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [modalsVisibility.GKColorsEditModalVisibility.isVisible]);

  const setCurrentTabsLocale = (locale) => {
    setCurrentModalLocale(locale)
    if (locale === "en") {
      document.getElementById("nav-layer-language-en-tab").click()
    }
    if (locale === "ru") {
      document.getElementById("nav-layer-language-ru-tab").click()
    }
  }


  const selectGKLayer = async (layer) => {

    // set this group as selected
    const selectedLayer = {
      ...layer,
      gk_name: null,
      [currentModalLocale]: {
        gk_name: layer.gk_name,
      }
    }

    convertMarkdownToEditorState(setGKLayerEditorState, selectedLayer[currentModalLocale].gk_name);
    document.getElementById("InputGKLayerColor3").value = selectedLayer.color;

    setSelectedGKLayer(selectedLayer);
    
  };

  const updateButtonClick = async () => {

    const selectedLayerUpdated = {
      ...selectedGKLayer,
      [currentModalLocale]: {
        gk_name: convertMarkdownFromEditorState(GKLayerEditorState).split("/n").join("")
      },
    }

    if (selectedLayerUpdated.en) {
      if (!await updateLayer(selectedLayerUpdated,"en")) {return}
    }
    
    if (selectedLayerUpdated.ru) {
      if (!await updateLayer(selectedLayerUpdated,"ru")) {return}
    }

    // update current groups
    setStateFromGetAPI(setGKLayers, `${process.env.REACT_APP_API_LINK}/${intl.locale}/gk`, undefined, headers);

    // show message
    showMessage(intl.formatMessage({ id: `Системный уровень обновлен`, defaultMessage: `Системный уровень обновлен` }));

  }

  const updateLayer = async (layer,locale) => {

    // get current input values

    const GKLayerColor = layer.color;
    const GKLayerName = layer[locale].gk_name;

    const newLawGroup = {
      gk: {
        gk_name: GKLayerName,
        color: GKLayerColor,
      }
    };

    // send group update request
    const changedGKLayerResponseData = await putDataToAPI(`${process.env.REACT_APP_API_LINK}/${locale}/gk/${selectedGKLayer.id_gk}`, newLawGroup, headers);
    if (!isResponseSuccessful(changedGKLayerResponseData)) {
      showMessage(changedGKLayerResponseData.data.error, "error");
      return false;
    }

    return true;

  };

  const requestAlternativeLayerData = async (locale) => {

    if (selectedGKLayer.id_gk) {
    
    const layerResponseData = await getDataFromAPI(`${process.env.REACT_APP_API_LINK}/${locale}/gk`, headers);
    if (!isResponseSuccessful(layerResponseData)) {
      showMessage(layerResponseData.data.error, "error");
      return;
    }
    const layers = layerResponseData.data.data
   

    const translatedSelectedLayer = layers.find(layer => layer.id_gk === selectedGKLayer.id_gk)


    const selectedLayerUpdated = {
      ...selectedGKLayer,
      [currentModalLocale]: {
        gk_name: convertMarkdownFromEditorState(GKLayerEditorState).split("/n").join("")
      },
      [locale]: {
        gk_name: selectedGKLayer[locale] ? selectedGKLayer[locale].gk_name : translatedSelectedLayer.gk_name
      }
    }

    console.log(selectedLayerUpdated)
    setSelectedGKLayer(selectedLayerUpdated);
    convertMarkdownToEditorState(setGKLayerEditorState, selectedLayerUpdated[locale].gk_name);
    document.getElementById("InputGKLayerColor3").value = selectedLayerUpdated.color;
    }

    setCurrentModalLocale(locale)

  }

  const updateColor = async () => {
    console.log("works")
    setSelectedGKLayer({
      ...selectedGKLayer,
      color: document.getElementById("InputGKLayerColor3").value
    })
  }

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
          <td><input type="color" className="form-control form-control-color disabled" value={GKLayer.color} readOnly onClick={(e) => { e.preventDefault();  }}/></td>
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
            <nav>
              <div className="nav nav-tabs" id="nav-tab" role="tablist">
                <button className="nav-link active" id="nav-layer-language-ru-tab" data-bs-toggle="tab" data-bs-target="#layer-edit" type="button" role="tab" aria-controls="layer-edit" aria-selected="false" onClick={() => {requestAlternativeLayerData("ru")}}><FormattedMessage id='ru' defaultMessage="ru" /></button>
                <button className="nav-link" id="nav-layer-language-en-tab" data-bs-toggle="tab" data-bs-target="#layer-edit" type="button" role="tab" aria-controls="layer-edit" aria-selected="true" onClick={() => {requestAlternativeLayerData("en")}}><FormattedMessage id='en' defaultMessage="en" /></button>
              </div>
            </nav>


            <div className="tab-content tab-content-border  mb-2" id="nav-tabContent">
            <div className="tab-pane fade show active" id="layer-edit" role="tabpanel" aria-labelledby="nav-layer-language-tab" tabIndex="0">

            <div className="row">
              <div className="col-2">
                <FormattedMessage id='Название' defaultMessage="Название" />:
              </div>
              <div className="col">
                <RichTextEditor editorState={GKLayerEditorState} setEditorState={setGKLayerEditorState} />
              </div>
              </div>
          </div>

            </div>
            <div className="row mb-2">
              <div className="col-2">
                <FormattedMessage id='Цвет' defaultMessage="Цвет" />:
              </div>
              <div className="col-5">
                <input type="color" className="form-control form-control-color" id="InputGKLayerColor3" onChange={updateColor} />
              </div>
            </div>
            <div className="row">
              <div className="col-2">
                  <Button type="button" className="btn btn-info" onClick={(e) => updateButtonClick(e)}><FormattedMessage id='Обновить' defaultMessage="Обновить" /></Button>
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
