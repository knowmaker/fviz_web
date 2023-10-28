import React, { useEffect, useState, useContext } from 'react';
import setStateFromGetAPI, { postDataToAPI, putDataToAPI, deleteDataFromAPI,getDataFromAPI } from '../misc/api.js';
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

export function LawsGroupsModal({ modalsVisibility, lawsGroupsState,lawsState }) {

  const userInfoState = useContext(UserProfile);

  const headers = {
    Authorization: `Bearer ${userInfoState.userToken}`
  };
  const lawsGroups = lawsGroupsState.lawsGroups;
  const setLawsGroups = lawsGroupsState.setLawsGroups;

  let isAdmin = false;
  if (userInfoState.userProfile) {
    isAdmin = userInfoState.userProfile.role;
  }

  // define current law group and editor state
  const [selectedLawGroup, setSelectedLawGroup] = useState({ type_name: null, id_type: null });
  const [lawGroupEditorState, setLawGroupEditorState] = useState(EditorState.createEmpty());

  const intl = useIntl();

  const [currentModalLocale, setCurrentModalLocale] = useState("ru");

  useEffect(() => {
    if (modalsVisibility.lawsGroupsModalVisibility.isVisible === false && isAdmin) {
      convertMarkdownToEditorState(setLawGroupEditorState, "");
      document.getElementById("InputLawGroupColor3").value = "#000000";
    }
    if (modalsVisibility.lawsGroupsModalVisibility.isVisible === true) {
      setCurrentTabsLocale(intl.locale)
    } else {
      setSelectedLawGroup({ type_name: null, id_type: null })
    }
  }, [modalsVisibility.lawsGroupsModalVisibility.isVisible]);

  const setCurrentTabsLocale = (locale) => {
    setCurrentModalLocale(locale)
    if (locale === "en") {
      document.getElementById("nav-group-language-en-tab").click()
    }
    if (locale === "ru") {
      document.getElementById("nav-group-language-ru-tab").click()
    }
  }

  const selectLawGroup = async (group) => {

    // set this group as selected
    await setSelectedLawGroup(group);
    
    setCurrentTabsLocale(intl.locale)



  };

  const updateLawGroup = async () => {

    // get current input values
    const lawGroupName = convertMarkdownFromEditorState(lawGroupEditorState);
    const lawGroupColor = document.getElementById("InputLawGroupColor3").value;

    const newLawGroup = {
      law_type: {
        type_name: lawGroupName,
        color: lawGroupColor,
      }
    };

    // send group update request
    const changedGroupResponseData = await putDataToAPI(`${process.env.REACT_APP_API_LINK}/${currentModalLocale}/law_types/${selectedLawGroup.id_type}`, newLawGroup, headers);
    if (!isResponseSuccessful(changedGroupResponseData)) {
      showMessage(changedGroupResponseData.data.error, "error");
      return;
    }

    // update current groups
    setStateFromGetAPI(setLawsGroups, `${process.env.REACT_APP_API_LINK}/${intl.locale}/law_types`, undefined, headers);

    // show message
    showMessage(intl.formatMessage({ id: `Группа была обновлена`, defaultMessage: `Группа была обновлена` }));

  };

  const deleteLawGroup = async (group) => {
    if (!window.confirm(intl.formatMessage({ id: `Подтверждение действия`, defaultMessage: `Вы уверены что хотите это сделать? Это приведёт к последствиям для других пользователей.` }))) {
      return;
    }

    //deleteData(undefined,`${process.env.REACT_APP_API_LINK}/${intl.locale}/law_types/${group.id_type}`,headers,afterDeleteLawGroup)
    // send delete group request
    const groupDeleteResponseData = await deleteDataFromAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/law_types/${group.id_type}`, undefined, headers);
    if (!isResponseSuccessful(groupDeleteResponseData)) {
      showMessage(groupDeleteResponseData.data.error, "error");
      return;
    }

    // update current groups and laws
    setStateFromGetAPI(setLawsGroups, `${process.env.REACT_APP_API_LINK}/${intl.locale}/law_types`, undefined, headers);
    setStateFromGetAPI(lawsState.setLaws, `${process.env.REACT_APP_API_LINK}/${intl.locale}/laws`,undefined,headers)

    // show message
    showMessage(intl.formatMessage({ id: `Группа была удалена`, defaultMessage: `Группа была удалена` }));

  };

  const createLawGroup = async () => {

    // get current input values
    const lawGroupName = convertMarkdownFromEditorState(lawGroupEditorState);
    const lawGroupColor = document.getElementById("InputLawGroupColor3").value;

    const newLawGroup = {
      law_type: {
        type_name: lawGroupName,
        color: lawGroupColor,
      }
    };

    // send create group request
    const newGroupResponseData = await postDataToAPI(`${process.env.REACT_APP_API_LINK}/${currentModalLocale}/law_types`, newLawGroup, headers);
    if (!isResponseSuccessful(newGroupResponseData)) {
      showMessage(newGroupResponseData.data.error, "error");
      return;
    }

    // update groups
    setStateFromGetAPI(setLawsGroups, `${process.env.REACT_APP_API_LINK}/${intl.locale}/law_types`, undefined, headers);

    // reset group editors
    setLawGroupEditorState(EditorState.createEmpty());
    document.getElementById("InputLawGroupColor3").value = "#FF0000";

    // show message 
    showMessage(intl.formatMessage({ id: `Группа была создана`, defaultMessage: `Группа была создана` }));

  };

  const requestAlternativeGroupData = async (locale) => {

    if (selectedLawGroup.id_type) {
    //setStateFromGetAPI(selectedCellState.setSelectedCell,`${process.env.REACT_APP_API_LINK}/${locale}/quantities/${selectedCell.id_value}`,undefined,headers)
    //setStateFromGetAPI(setLawsGroups, `${process.env.REACT_APP_API_LINK}/${locale}/law_types`, undefined, headers);
    //setStateFromGetAPI(setLawsGroups, `${process.env.REACT_APP_API_LINK}/${intl.locale}/law_types`,undefined,headers)
    const groupResponseData = await getDataFromAPI(`${process.env.REACT_APP_API_LINK}/${locale}/law_types`, headers);
    if (!isResponseSuccessful(groupResponseData)) {
      showMessage(groupResponseData.data.error, "error");
      return;
    }
    const groups = groupResponseData.data.data

    const translatedSelectedGroup = groups.find(group => group.id_type === selectedLawGroup.id_type)
    console.log(groups,translatedSelectedGroup)
    setSelectedLawGroup(translatedSelectedGroup)
    convertMarkdownToEditorState(setLawGroupEditorState, translatedSelectedGroup.type_name);
    document.getElementById("InputLawGroupColor3").value = translatedSelectedGroup.color;
    }

    setCurrentModalLocale(locale)

  }

  let lawsGroupsMarkup;
  if (lawsGroups) {
    lawsGroupsMarkup = lawsGroups.map(group => {

      const isCurrent = selectedLawGroup.id_type === group.id_type;

      return (
        <tr key={group.id_type}>
          {isAdmin ?
            (<>
              <th scope="row" className='small-cell'>{isCurrent ? `+` : ''}</th>
            </>) : (null)}
          <td dangerouslySetInnerHTML={{ __html: group.type_name }}></td>
          <td><input type="color" className="form-control form-control-color disabled" value={group.color} readOnly onClick={(e) => { e.preventDefault(); }} /></td>
          {isAdmin ?
            (<>
              <td className='small-cell'><button type="button" className="btn btn-primary btn-sm" onClick={() => selectLawGroup(group)}>📝</button></td>
              <td className='small-cell'><button type="button" className="btn btn-danger btn-sm" onClick={() => deleteLawGroup(group)}>🗑</button></td>
            </>) : (null)}
        </tr>
      );
    });
  } else { lawsGroupsMarkup = null; }



  return (
    <Modal
      modalVisibility={modalsVisibility.lawsGroupsModalVisibility}
      title={intl.formatMessage({ id: `Группы законов`, defaultMessage: `Группы законов` })}
      hasBackground={false}
      sizeX={600}
    >
      <div className="modal-content2">

        {isAdmin ?
          (<>

              <nav>
                <div className="nav nav-tabs" id="nav-tab" role="tablist">
                  <button className="nav-link active" id="nav-group-language-ru-tab" data-bs-toggle="tab" data-bs-target="#group-edit" type="button" role="tab" aria-controls="group-edit" aria-selected="false" onClick={() => {requestAlternativeGroupData("ru")}}><FormattedMessage id='ru' defaultMessage="ru" /></button>
                  <button className="nav-link" id="nav-group-language-en-tab" data-bs-toggle="tab" data-bs-target="#group-edit" type="button" role="tab" aria-controls="group-edit" aria-selected="true" onClick={() => {requestAlternativeGroupData("en")}}><FormattedMessage id='en' defaultMessage="en" /></button>
                </div>
              </nav>

          <div className="tab-content tab-content-border" id="nav-tabContent">
            <div className="tab-pane fade show active" id="group-edit" role="tabpanel" aria-labelledby="nav-group-language-tab" tabIndex="0">

              <div className="row">
                <div className="col-2">
                  <FormattedMessage id='Название' defaultMessage="Название" />:
                </div>
                <div className="col">
                  <RichTextEditor editorState={lawGroupEditorState} setEditorState={setLawGroupEditorState} />

                </div>
              </div>
            </div>
          </div>

          <div className="row">
              <div className="col-2">
                <FormattedMessage id='Цвет' defaultMessage="Цвет" />:
              </div>
              <div className="col-5">
                <input type="color" className="form-control form-control-color" id="InputLawGroupColor3" />
              </div>
            </div>

              <div className="row">
              <div className="col-2">
                <Button type="button" className="btn btn-success" onClick={(e) => createLawGroup(e)}><FormattedMessage id='Создать' defaultMessage="Создать" /></Button>
              </div>
              <div className="col-3">
                <Button type="button" className="btn btn-info" onClick={(e) => updateLawGroup(e)}><FormattedMessage id='Обновить' defaultMessage="Обновить" /></Button>
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
              <th scope="col"><FormattedMessage id='Название' defaultMessage="Название" /></th>
              <th scope="col"><FormattedMessage id='Цвет' defaultMessage="Цвет" /></th>
              {isAdmin ?
                (<>
                  <th scope="col"><FormattedMessage id='Выбрать' defaultMessage="Выбрать" /></th>
                  <th scope="col"><FormattedMessage id='Удалить' defaultMessage="Удалить" /></th>
                </>) : (null)}
            </tr>
          </thead>
          <tbody>
            {lawsGroupsMarkup}
          </tbody>
        </table>


      </div>

    </Modal>
  );
}
