import React, { useEffect, useState, useContext } from 'react';
import { getDataFromAPI, postDataToAPI, putDataToAPI, deleteDataFromAPI } from '../misc/api.js';
import { UserProfile, TableContext } from '../misc/contexts.js';
import { Cell } from '../components/Table.js';
import { isResponseSuccessful } from '../misc/api.js';
import { FormattedMessage, useIntl } from 'react-intl';
import { convertMarkdownFromEditorState } from '../pages/Home.js';
import { showMessage } from '../misc/message.js';
import { convertToMLTI,convertNumberToUnicodePower } from '../misc/converters.js';
import { Modal } from './Modal.js';
import { RichTextEditor } from '../components/RichTextEditor.js';
import { Button } from '../components/ButtonWithLoad.js';
import setStateFromGetAPI from '../misc/api.js';

export function EditCellModal({ modalVisibility, selectedCell, cellEditorsStates, gkColors, selectedCellState }) {

  const tableState = useContext(TableContext);
  const userInfoState = useContext(UserProfile);
  const headers = {
    Authorization: `Bearer ${userInfoState.userToken}`
  };

  let isAdmin = false;
  if (userInfoState.userProfile) {
    isAdmin = userInfoState.userProfile.role;
  }


  const intl = useIntl();

  const [currentModalLocale, setCurrentModalLocale] = useState("ru");

  // useEffect(() => {
  //   if (modalVisibility.isVisible === false) {
  //     selectedCellState.setSelectedCell(null)
  //   }
  // }, [modalVisibility.isVisible]);

  useEffect(() => {
    if (modalVisibility.isVisible === true) {
      setCurrentModalLocale(intl.locale)
      if (intl.locale === "en") {
        document.getElementById("nav-cell-language-en-tab").click()
      }
      if (intl.locale === "ru") {
        document.getElementById("nav-cell-language-ru-tab").click()
      }
    }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [modalVisibility.isVisible]);

  const saveButtonClick = () => {

    if (!selectedCell) {
      showMessage(intl.formatMessage({ id: `Выберите ячейку`, defaultMessage: `Сначала выберите ячейку на поле` }),"error")
      return
    }

    if (selectedCell.id_value === -1) {
      createCell();
      return;
    }
    updateCell();

  };

  const updateCell = async () => {



    // get all MLTI parameters
    const id_gk = parseInt(document.getElementById("inputGK3").value);

    const G_indicate = gkColors.find(gkLevel => gkLevel.id_gk === id_gk).g_indicate;
    const K_indicate = gkColors.find(gkLevel => gkLevel.id_gk === id_gk).k_indicate;
    const l_indicate = parseInt(document.getElementById("inputL3").value);
    const t_indicate = parseInt(document.getElementById("inputT3").value);

    const M_indicate = 0 - (G_indicate * -1 + K_indicate);
    const L_indicate = l_indicate - G_indicate * 3;
    const T_indicate = t_indicate - G_indicate * -2;
    const I_indicate = 0 - K_indicate * -1;

    // create new cell
    const newCell = {
      quantity: {
        value_name: convertMarkdownFromEditorState(cellEditorsStates.cellNameEditorState.value).split("/n").join(""),
        symbol: convertMarkdownFromEditorState(cellEditorsStates.cellSymbolEditorState.value).split("/n").join(""),
        unit: convertMarkdownFromEditorState(cellEditorsStates.cellUnitEditorState.value).split("/n").join(""),
        l_indicate: l_indicate,
        t_indicate: t_indicate,
        id_gk: id_gk,
        m_indicate_auto: M_indicate,
        l_indicate_auto: L_indicate,
        t_indicate_auto: T_indicate,
        i_indicate_auto: I_indicate,
        mlti_sign: convertToMLTI(M_indicate, L_indicate, T_indicate, I_indicate)
      }
    };

    // send cell update request
    const changedCellResponseData = await putDataToAPI(`${process.env.REACT_APP_API_LINK}/${currentModalLocale}/quantities/${selectedCell.id_value}`, newCell, headers);
    if (!isResponseSuccessful(changedCellResponseData)) {
      showMessage(changedCellResponseData.data.error, "error");
      return;
    }
    const cellData = changedCellResponseData.data.data;

    // show message
    showMessage(intl.formatMessage({ id: `Ячейка была изменена`, defaultMessage: `Ячейка была изменена` }));

    // remove old cell and set new one if current locale was changed
    if (intl.locale === currentModalLocale) {
      tableState.setTableData(tableState.tableData.filter(cell => cell.id_lt !== cellData.id_lt).concat(cellData));
    }

    // send request to replace missing cell
    const cellAlternativesResponseData = await getDataFromAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/layers/${selectedCell.id_lt}`, headers);
    if (!isResponseSuccessful(cellAlternativesResponseData)) {
      showMessage(cellAlternativesResponseData.data.error, "error");
      return;
    }

    const cellAlternatives = cellAlternativesResponseData.data.data;

    // replace missing cell if there is alternative
    if (cellAlternatives.length > 0 && cellData.id_lt !== selectedCell.id_lt) {
      tableState.setTableData(tableState.tableData.filter(cell => cell.id_value !== selectedCell.id_value).concat(cellAlternatives[0]));
    }

    // hide modal
    modalVisibility.setVisibility(false);

  };

  const createCell = async () => {

    // get all MLTI parameters
    const id_gk = parseInt(document.getElementById("inputGK3").value);

    const G_indicate = gkColors.find(gkLevel => gkLevel.id_gk === id_gk).g_indicate;
    const K_indicate = gkColors.find(gkLevel => gkLevel.id_gk === id_gk).k_indicate;
    const l_indicate = parseInt(document.getElementById("inputL3").value);
    const t_indicate = parseInt(document.getElementById("inputT3").value);

    const M_indicate = 0 - (G_indicate * -1 + K_indicate);
    const L_indicate = l_indicate - G_indicate * 3;
    const T_indicate = t_indicate - G_indicate * -2;
    const I_indicate = 0 - K_indicate * -1;

    // create new cell
    const newCell = {
      quantity: {
        value_name: convertMarkdownFromEditorState(cellEditorsStates.cellNameEditorState.value).split("/n").join(""),
        symbol: convertMarkdownFromEditorState(cellEditorsStates.cellSymbolEditorState.value).split("/n").join(""),
        unit: convertMarkdownFromEditorState(cellEditorsStates.cellUnitEditorState.value).split("/n").join(""),
        l_indicate: l_indicate,
        t_indicate: t_indicate,
        id_gk: id_gk,
        m_indicate_auto: M_indicate,
        l_indicate_auto: L_indicate,
        t_indicate_auto: T_indicate,
        i_indicate_auto: I_indicate,
        mlti_sign: convertToMLTI(M_indicate, L_indicate, T_indicate, I_indicate)
      }
    };

    // send cell create request
    const createdCellResponseData = await postDataToAPI(`${process.env.REACT_APP_API_LINK}/${currentModalLocale}/quantities`, newCell, headers);
    if (!isResponseSuccessful(createdCellResponseData)) {
      showMessage(createdCellResponseData.data.error, "error");
      return;
    }
    const cellData = createdCellResponseData.data.data;

    // show message
    showMessage(intl.formatMessage({ id: `Ячейка была изменена`, defaultMessage: `Ячейка была изменена` }));

    // set new cell
    if (intl.locale === currentModalLocale) {
    tableState.setTableData(tableState.tableData.filter(cell => cell.id_lt !== cellData.id_lt).concat(cellData));
    }

    // hide modal
    modalVisibility.setVisibility(false);

  };

  const deleteCell = async () => {

    if (!selectedCell) {
      showMessage(intl.formatMessage({ id: `Выберите ячейку`, defaultMessage: `Сначала выберите ячейку на поле` }),"error")
      return
    }

    if (!window.confirm(intl.formatMessage({ id: `Подтверждение действия`, defaultMessage: `Вы уверены что хотите это сделать? Это приведёт к последствиям для других пользователей.` }))) {
      return;
    }

    // send delete request
    const cellDeleteResponseData = await deleteDataFromAPI(`${process.env.REACT_APP_API_LINK}/${currentModalLocale}/quantities/${selectedCell.id_value}`, undefined, headers);
    if (!isResponseSuccessful(cellDeleteResponseData)) {
      showMessage(cellDeleteResponseData.data.error, "error");
      return;
    }

    tableState.setTableData(tableState.tableData.filter(cell => cell.id_value !== selectedCell.id_value));

    // send request to replace missing cell
    const cellAlternativesResponseData = await getDataFromAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/layers/${selectedCell.id_lt}`, headers);
    if (!isResponseSuccessful(cellAlternativesResponseData)) {
      showMessage(cellAlternativesResponseData.data.error, "error");
      return;
    }

    const cellAlternatives = cellAlternativesResponseData.data.data;

    // replace missing cell if there is alternative
    if (cellAlternatives.length > 0) {
      tableState.setTableData(tableState.tableData.filter(cell => cell.id_value !== selectedCell.id_value).concat(cellAlternatives[0]));
    }


    // selectedCell.id_value
    showMessage(intl.formatMessage({ id: `Ячейка удалена`, defaultMessage: `Ячейка удалена` }));

    // hide modal
    modalVisibility.setVisibility(false);

  };

  // generate gk layer list
  const cellList = gkColors.map(gkLevel => {


    const shownText = `${gkLevel.gk_name} G${convertNumberToUnicodePower(gkLevel.g_indicate)}K<sup>${convertNumberToUnicodePower(gkLevel.k_indicate)}</sup>`;

    return (
      <option key={gkLevel.id_gk} value={gkLevel.id_gk} dangerouslySetInnerHTML={{ __html: shownText }} />
    );

  });

  const [previewCell, setPreviewCell] = useState({
    cellFullId: -1,
    cellData: { value_name: intl.formatMessage({ id: `не выбрано`, defaultMessage: `не выбрано` }), symbol: "", unit: "" },
    cellColor: undefined
  });

  const [GKoption, setGKoption] = useState(null);

  useEffect(() => {

    // update preview cell when input happens
    updatePreviewCell();

  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [cellEditorsStates, GKoption, selectedCell]);

  const updatePreviewCell = () => {

    const id_gk = parseInt(document.getElementById("inputGK3").value);
    if (id_gk) {

      const cellColor = gkColors.find((setting) => setting.id_gk === id_gk).color;

      const G_indicate = gkColors.find(gkLevel => gkLevel.id_gk === id_gk).g_indicate;
      const K_indicate = gkColors.find(gkLevel => gkLevel.id_gk === id_gk).k_indicate;
      const l_indicate = parseInt(document.getElementById("inputL3").value);
      const t_indicate = parseInt(document.getElementById("inputT3").value);

      const M_indicate = 0 - (G_indicate * -1 + K_indicate);
      const L_indicate = l_indicate - G_indicate * 3;
      const T_indicate = t_indicate - G_indicate * -2;
      const I_indicate = 0 - K_indicate * -1;

      setPreviewCell(
        {
          cellFullId: -1,
          cellData: {
            value_name: convertMarkdownFromEditorState(cellEditorsStates.cellNameEditorState.value),
            symbol: convertMarkdownFromEditorState(cellEditorsStates.cellSymbolEditorState.value),
            unit: convertMarkdownFromEditorState(cellEditorsStates.cellUnitEditorState.value),
            m_indicate_auto: M_indicate,
            l_indicate_auto: L_indicate,
            t_indicate_auto: T_indicate,
            i_indicate_auto: I_indicate,
          },
          cellColor: cellColor,
        }
      );

    }

  };

  const requestAlternativeCellData = (locale) => {

    if (selectedCell) {
    setStateFromGetAPI(selectedCellState.setSelectedCell,`${process.env.REACT_APP_API_LINK}/${locale}/quantities/${selectedCell.id_value}`,undefined,headers)
    }
    setCurrentModalLocale(locale)

  }

  return (
    <Modal
      modalVisibility={modalVisibility}
      title={intl.formatMessage({ id: `Редактирование величины`, defaultMessage: `Редактирование величины` })}
      hasBackground={false}
      sizeX={650}
    >
      <div className="modal-content2">
        {isAdmin ?
            (<>
        <div className="row">

              <details>
                <summary><FormattedMessage id='Превью' defaultMessage="Превью" /></summary>
                <Cell cellFullData={previewCell} />
              </details>

        </div>
        </>) : (null)}

        <nav>
          <div className="nav nav-tabs" id="nav-tab" role="tablist">
            <button className="nav-link active" id="nav-cell-language-ru-tab" data-bs-toggle="tab" data-bs-target="#cell-edit" type="button" role="tab" aria-controls="cell-edit" aria-selected="false" onClick={() => {requestAlternativeCellData("ru")}}><FormattedMessage id='ru' defaultMessage="ru" /></button>
            <button className="nav-link" id="nav-cell-language-en-tab" data-bs-toggle="tab" data-bs-target="#cell-edit" type="button" role="tab" aria-controls="cell-edit" aria-selected="true" onClick={() => {requestAlternativeCellData("en")}}><FormattedMessage id='en' defaultMessage="en" /></button>
          </div>
        </nav>
        <div className="tab-content tab-content-border" id="nav-tabContent">
          <div className="tab-pane fade show active" id="cell-edit" role="tabpanel" aria-labelledby="nav-cell-language-tab" tabIndex="0">
            <div className="row">
              <div className="col-6">
                <label className="form-label"><FormattedMessage id='Имя' defaultMessage="Имя" /></label>
                <RichTextEditor editorState={cellEditorsStates.cellNameEditorState.value} setEditorState={cellEditorsStates.cellNameEditorState.set} readOnly={!isAdmin} />
              </div>
              <div className="col-6">
                <label className="form-label"><FormattedMessage id='Условное обозначение' defaultMessage="Условное обозначение" /></label>
                <RichTextEditor editorState={cellEditorsStates.cellSymbolEditorState.value} setEditorState={cellEditorsStates.cellSymbolEditorState.set} readOnly={!isAdmin} />
              </div>
            </div>
          <div className="row">
            <div className="col">
              <label htmlFor="InputFirstName3" className="form-label"><FormattedMessage id='Единица измерения' defaultMessage="Единица измерения" /></label>
              <RichTextEditor editorState={cellEditorsStates.cellUnitEditorState.value} setEditorState={cellEditorsStates.cellUnitEditorState.set} readOnly={!isAdmin} />
            </div>
          </div>
          </div>
        </div>
        
        <div className="col">
              <label htmlFor="InputFirstName3" className="form-label"><FormattedMessage id='Уровень' defaultMessage="Уровень" /> GK</label>
              <select className="form-select" aria-label="Default select example" id='inputGK3' onChange={() => setGKoption(parseInt(document.getElementById("inputGK3").value))} disabled={!isAdmin}>
                {cellList}
          </select>
          </div>

        <div className="row">
          <div className="col">
            <label className="form-label">L</label>
            <input type="number" min="-10" max="10" step="1" className="form-control" id="inputL3" onChange={() => updatePreviewCell()} disabled={!isAdmin} />
          </div>

          <div className="col">
            <label className="form-label">T</label>
            <input type="number" min="-10" step="1" className="form-control" id="inputT3" onChange={() => updatePreviewCell()} disabled={!isAdmin} />
          </div>

        </div>

      </div>
      {isAdmin ?
        (<>
          <div className="modal-footer2">
            <Button type="button" className="btn btn-danger" onClick={(e) => deleteCell(e)}><FormattedMessage id='Удалить' defaultMessage="Удалить" /></Button>
            <Button type="button" className="btn btn-success" onClick={(e) => saveButtonClick(e)}><FormattedMessage id='Сохранить' defaultMessage="Сохранить" /></Button>
          </div>
        </>) : (null)}
    </Modal>
  );
}
