import React, { useEffect, useState, useContext } from 'react';
import setStateFromGetAPI, { postDataToAPI, putDataToAPI, deleteDataFromAPI } from '../misc/api.js';
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



  useEffect(() => {
    if (modalsVisibility.lawsGroupsModalVisibility.isVisible === false && isAdmin) {
      convertMarkdownToEditorState(setLawGroupEditorState, "");
      document.getElementById("InputLawGroupColor3").value = "#000000";
    }
  }, [modalsVisibility.lawsGroupsModalVisibility.isVisible]);

  const selectLawGroup = (group) => {

    // set this group as selected
    setSelectedLawGroup(group);

    // set input to this group values
    convertMarkdownToEditorState(setLawGroupEditorState, group.type_name);
    document.getElementById("InputLawGroupColor3").value = group.color;

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
    const changedGroupResponseData = await putDataToAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/law_types/${selectedLawGroup.id_type}`, newLawGroup, headers);
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
    const newGroupResponseData = await postDataToAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/law_types`, newLawGroup, headers);
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
            <div className="row">
              <div className="col-2">
                <FormattedMessage id='Название' defaultMessage="Название" />:
              </div>
              <div className="col-5">
                <RichTextEditor editorState={lawGroupEditorState} setEditorState={setLawGroupEditorState} />

              </div>
              <div className="col-2">
                <Button type="button" className="btn btn-success" onClick={(e) => createLawGroup(e)}><FormattedMessage id='Создать' defaultMessage="Создать" /></Button>
              </div>
              <div className="col-3">
                <Button type="button" className="btn btn-info" onClick={(e) => updateLawGroup(e)}><FormattedMessage id='Обновить' defaultMessage="Обновить" /></Button>
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
