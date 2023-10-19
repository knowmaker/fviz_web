import React, { useEffect, useContext } from 'react';
import setStateFromGetAPI, { postDataToAPI, putDataToAPI, deleteDataFromAPI } from '../misc/api.js';
import { UserProfile, TableContext } from '../misc/contexts.js';
import { isResponseSuccessful } from '../misc/api.js';
import { FormattedMessage, useIntl } from 'react-intl';
import { checkLaw } from '../components/Table.js';
import { RichTextEditor } from '../components/RichTextEditor.js';
import { convertMarkdownFromEditorState } from '../pages/Home.js';
import { showMessage } from '../misc/message.js';
import { Modal } from './Modal.js';
import { Button } from '../components/ButtonWithLoad.js';

export function LawsModal({ modalsVisibility, lawsState, selectedLawState, lawsGroupsState, lawEditorsStates }) {

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

  // useEffect(() => {
  //   if (modalsVisibility.lawsModalVisibility.isVisible === false) {
  //     selectedLawState.setSelectedLaw({law_name: null,cells:[],id_type: null})
  //     document.getElementById("InputLawName3").value = ""
  //     document.getElementById("inputLawGroup3").value = -1
  //   }
  // }, [modalsVisibility.lawsModalVisibility.isVisible]);
  //lawEditorsStates.lawGroupEditorState
  useEffect(() => {
    if (lawEditorsStates.lawGroupEditorState.value === null) {
      document.getElementById("inputLawGroup3").value = -1;
      return;
    }
    if (lawEditorsStates.lawGroupEditorState.value) {
      document.getElementById("inputLawGroup3").value = lawEditorsStates.lawGroupEditorState.value;

    }
  }, [lawEditorsStates.lawGroupEditorState.value]);

  const saveButtonClick = () => {
    if (selectedLawState.selectedLaw.id_law) {
      updateLaw();
      return;
    }
    createLaw();
  };

  const createLaw = async () => {

    // check length of current law
    if (selectedLawState.selectedLaw.cells.length !== 4) {
      showMessage(intl.formatMessage({ id: `Выбрать 4 ячейки`, defaultMessage: `Для закона нужно выбрать 4 ячейки` }));
      return;
    }

    // check if this law is correct
    if (!checkLaw(selectedLawState.selectedLaw.cells)) {
      showMessage(intl.formatMessage({ id: `Выбран некорректный закон`, defaultMessage: `выбран некорректный закон` }));
      return;
    }

    // get current selected cells
    const selectedLawCellId = selectedLawState.selectedLaw.cells.map(cell => cell.id_value);



    const newLaw = {
      law: {
        law_name: convertMarkdownFromEditorState(lawEditorsStates.lawNameEditorState.value),
        first_element: selectedLawCellId[0],
        second_element: selectedLawCellId[1],
        third_element: selectedLawCellId[2],
        fourth_element: selectedLawCellId[3],
        id_type: document.getElementById("inputLawGroup3").value
      }
    };

    // send create group request
    const newLawResponseData = await postDataToAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/laws`, newLaw, headers);
    if (!isResponseSuccessful(newLawResponseData)) {
      showMessage(newLawResponseData.data.error, "error");
      return;
    }

    // update laws
    setStateFromGetAPI(lawsState.setLaws, `${process.env.REACT_APP_API_LINK}/${intl.locale}/laws`, undefined, headers);

    selectedLawState.setSelectedLaw(newLawResponseData.data.data);
    // show message
    showMessage(intl.formatMessage({ id: `Закон создан`, defaultMessage: `Закон создан` }));

  };

  const updateLaw = async () => {

    // check length of current law
    if (selectedLawState.selectedLaw.cells.length !== 4) {
      showMessage(intl.formatMessage({ id: `Выбрать 4 ячейки`, defaultMessage: `Для закона нужно выбрать 4 ячейки` }));
      return;
    }

    // check if this law is correct
    if (!checkLaw(selectedLawState.selectedLaw.cells)) {
      showMessage(intl.formatMessage({ id: `Выбран некорректный закон`, defaultMessage: `выбран некорректный закон` }));
      return;
    }

    // get current selected cells
    const selectedLawCellId = selectedLawState.selectedLaw.cells.map(cell => cell.id_value);

    const newLaw = {
      law: {
        law_name: convertMarkdownFromEditorState(lawEditorsStates.lawNameEditorState.value),
        first_element: selectedLawCellId[0],
        second_element: selectedLawCellId[1],
        third_element: selectedLawCellId[2],
        fourth_element: selectedLawCellId[3],
        id_type: document.getElementById("inputLawGroup3").value
      }
    };

    // send update request
    const changedLawResponseData = await putDataToAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/laws/${selectedLawState.selectedLaw.id_law}`, newLaw, headers);
    if (!isResponseSuccessful(changedLawResponseData)) {
      showMessage(changedLawResponseData.data.error, "error");
      return;
    }

    // update laws
    setStateFromGetAPI(lawsState.setLaws, `${process.env.REACT_APP_API_LINK}/${intl.locale}/laws`, undefined, headers);

    // show message
    showMessage(intl.formatMessage({ id: `Закон обновлён`, defaultMessage: `Закон обновлён` }));

  };

  const deleteLaw = async (law) => {

    // send delete law request
    const lawDeleteResponseData = await deleteDataFromAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/laws/${law.id_law}`, undefined, headers);
    if (!isResponseSuccessful(lawDeleteResponseData)) {
      showMessage(lawDeleteResponseData.data.error, "error");
      return;
    }

    // update laws
    setStateFromGetAPI(lawsState.setLaws, `${process.env.REACT_APP_API_LINK}/${intl.locale}/laws`, undefined, headers);

    // show message
    showMessage(intl.formatMessage({ id: `Закон удалён`, defaultMessage: `Закон удалён` }));

  };

  const chooseOption = <option key={-1} value={-1} dangerouslySetInnerHTML={{ __html: intl.formatMessage({ id: `Выберите опцию`, defaultMessage: `Выберите опцию` }) }} />;

  const lawsGroupList = lawsGroupsState.lawsGroups.map(lawGroup => {

    const shownText = `${lawGroup.type_name}`;

    return (
      <option key={lawGroup.id_type} value={lawGroup.id_type} dangerouslySetInnerHTML={{ __html: shownText }} />
    );

  });

  const allOptions = [chooseOption, ...lawsGroupList];

  const selectedLaw = selectedLawState.selectedLaw;


  const lawFormulaSymbols = selectedLaw.cells.length >= 4 ? `${selectedLaw.cells[0].symbol} * ${selectedLaw.cells[2].symbol} = ${selectedLaw.cells[1].symbol} * ${selectedLaw.cells[3].symbol}` : "";
  const lawFormulaNames = selectedLaw.cells.length >= 4 ? `${selectedLaw.cells[0].value_name} * ${selectedLaw.cells[2].value_name} = <br> = ${selectedLaw.cells[1].value_name} * ${selectedLaw.cells[3].value_name}` : "";

  return (
    <Modal
      modalVisibility={modalsVisibility.lawsModalVisibility}
      title={intl.formatMessage({ id: `Законы`, defaultMessage: `Законы` })}
      hasBackground={false}
      sizeX={600}
    >
      <div className="modal-content2">
        <div className="row">
          <div className="col-2">
            <FormattedMessage id='Название' defaultMessage="Название" />:
          </div>
          <div className="col">
            <RichTextEditor editorState={lawEditorsStates.lawNameEditorState.value} setEditorState={lawEditorsStates.lawNameEditorState.set} />
          </div>
        </div>
        <div className="row">
          <div className="col-2">
            <FormattedMessage id='Группы' defaultMessage="Группы" />:
          </div>
          <div className="col">
            <select className="form-select" aria-label="Default select example" id='inputLawGroup3'>
              {allOptions}
            </select>
          </div>
        </div>
        <div className="row">
          <div className="col-2">
            <FormattedMessage id='Формулы' defaultMessage="Формулы" />:
          </div>
          <div className="col">
            <div className="" dangerouslySetInnerHTML={{ __html: lawFormulaSymbols }} />
          </div>
        </div>
        <div className="row">
          <div className="col-2 invisible">
            <FormattedMessage id='Формулы' defaultMessage="Формулы" />:
          </div>
          <div className="col">
            <div className="" dangerouslySetInnerHTML={{ __html: lawFormulaNames }} />
          </div>
        </div>
      </div>

      <div className="modal-footer2">
        <Button type="button" className="btn btn-success" onClick={(e) => saveButtonClick(e)}><FormattedMessage id='Сохранить' defaultMessage="Сохранить" /></Button>
        {selectedLaw.id_law ?
          (<>
            <Button type="button" className="btn btn-danger" onClick={(e) => deleteLaw(e)}><FormattedMessage id='Удалить' defaultMessage="Удалить" /></Button>
          </>) : (null)}
      </div>

    </Modal>
  );
}
