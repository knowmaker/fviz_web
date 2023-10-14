import React, { useEffect, useState, useContext } from 'react';
import setStateFromGetAPI, { getDataFromAPI, postDataToAPI, putDataToAPI, deleteDataFromAPI } from '../misc/api.js';
import { UserProfile, TableContext } from '../misc/contexts.js';
import { EditorState } from 'draft-js';
import { isResponseSuccessful } from '../misc/api.js';
import { FormattedMessage, useIntl } from 'react-intl';
import { RichTextEditor } from '../pages/RichTextEditor.js';
import { convertMarkdownToEditorState, showMessage, convertMarkdownFromEditorState } from '../pages/Home.js';
import { Modal } from './Modal.js';

export function TableViewsModal({ modalsVisibility, tableViews, setTableViews, tableViewState }) {


  const userInfoState = useContext(UserProfile);
  const tableState = useContext(TableContext);
  const headers = {
    Authorization: `Bearer ${userInfoState.userToken}`
  };

  const intl = useIntl();

  const [tableViewEditorState, setTableViewEditorState] = useState(EditorState.createEmpty());

  useEffect(() => {
    if (modalsVisibility.tableViewsModalVisibility.isVisible === false) {
      convertMarkdownToEditorState(setTableViewEditorState, "");
    }
  }, [modalsVisibility.tableViewsModalVisibility.isVisible]);


  const selectTableView = async (tableView) => {

    // send full table view data request
    const tableViewDataResponse = await getDataFromAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/active_view/${tableView.id_repr}`, headers);
    if (!isResponseSuccessful(tableViewDataResponse)) {
      showMessage(tableViewDataResponse.data.error, "error");
      return;
    }
    const tableViewData = tableViewDataResponse.data.data;

    // set it as selected
    tableViewState.setTableView({ id_repr: tableView.id_repr, title: tableViewData.title });
    tableState.setTableData(tableViewData.active_quantities);

    // change input to current table view name
    convertMarkdownToEditorState(setTableViewEditorState, tableViewData.title);

  };

  const updateTableView = async () => {

    // get all current visible cells ids
    const cellIds = Object.values(tableState)[0].map(cell => cell.id_value);

    // get new table view name
    const tableViewTitle = convertMarkdownFromEditorState(tableViewEditorState);

    const newTableView = {
      title: tableViewTitle,
      active_quantities: cellIds,
    };

    // send table view update request
    const changedTableViewResponseData = await putDataToAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/represents/${tableViewState.tableView.id_repr}`, newTableView, headers);
    if (!isResponseSuccessful(changedTableViewResponseData)) {
      showMessage(changedTableViewResponseData.data.error, "error");
      return;
    }

    // update current table views
    setStateFromGetAPI(setTableViews, `${process.env.REACT_APP_API_LINK}/${intl.locale}/represents`, undefined, headers);

    // show message
    showMessage(intl.formatMessage({ id: `Представление обновлено`, defaultMessage: `Представление обновлено` }));

  };

  const deleteTableView = async (tableView) => {

    // send delete request
    const tableViewDeleteResponseData = await deleteDataFromAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/represents/${tableView.id_repr}`, undefined, headers);
    if (!isResponseSuccessful(tableViewDeleteResponseData)) {
      showMessage(tableViewDeleteResponseData.data.error, "error");
      return;
    }

    // update current table views
    setStateFromGetAPI(setTableViews, `${process.env.REACT_APP_API_LINK}/${intl.locale}/represents`, undefined, headers);

    // show message
    showMessage(intl.formatMessage({ id: `Представление удалено`, defaultMessage: `Представление удалено` }));

  };

  const createTableView = async () => {

    // fix filter later
    // get all current visible cells ids
    const cellIds = Object.values(tableState)[0].map(cell => cell.id_value).filter(id => id !== -1);

    // get new table view name
    const tableViewTitle = convertMarkdownFromEditorState(tableViewEditorState);

    const newTableView = {
      title: tableViewTitle,
      active_quantities: cellIds,
    };
    // send table view create request
    const newTableViewResponseData = await postDataToAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/represents`, newTableView, headers);
    if (!isResponseSuccessful(newTableViewResponseData)) {
      showMessage(newTableViewResponseData.data.error, "error");
      return;
    }

    // update current table views
    setStateFromGetAPI(setTableViews, `${process.env.REACT_APP_API_LINK}/${intl.locale}/represents`, undefined, headers);

    // show message
    showMessage(intl.formatMessage({ id: `Представление создано`, defaultMessage: `Представление создано` }));

  };


  let tableViewsMarkup = null;
  if (tableViews) {
    tableViewsMarkup = tableViews.map(tableView => {

      const isCurrent = tableView.id_repr === tableViewState.tableView.id_repr;

      return (
        <tr key={tableView.id_repr}>
          <th scope="row" className='small-cell'>{isCurrent ? `+` : ''}</th>
          <td dangerouslySetInnerHTML={{ __html: tableView.title }}></td>
          <td className='small-cell'><button type="button" className="btn btn-primary btn-sm" onClick={() => selectTableView(tableView)}>↓</button></td>
          <td className='small-cell'><button type="button" className="btn btn-danger btn-sm" onClick={() => deleteTableView(tableView)}>🗑</button></td>
        </tr>
      );
    });
  }



  return (
    <Modal
      modalVisibility={modalsVisibility.tableViewsModalVisibility}
      title={intl.formatMessage({ id: `Представления ФВ`, defaultMessage: `Представления ФВ` })}
      hasBackground={false}
      sizeX={600}
    >
      <div className="modal-content2">

        <div className="row">
          <div className="col-2">
            <FormattedMessage id='Название' defaultMessage="Название" />:
          </div>
          <div className="col-5">
            <RichTextEditor editorState={tableViewEditorState} setEditorState={setTableViewEditorState} />
          </div>
          <div className="col-2">
            <button type="button" className="btn btn-success" onClick={() => createTableView()}><FormattedMessage id='Создать' defaultMessage="Создать" /></button>
          </div>
          <div className="col-3">
            <button type="button" className="btn btn-info" onClick={() => updateTableView()}><FormattedMessage id='Обновить' defaultMessage="Обновить" /></button>
          </div>
        </div>
        <table className="table">
          <thead>
            <tr>
              <th scope="col">#</th>
              <th scope="col"><FormattedMessage id='Название' defaultMessage="Название" /></th>
              <th scope="col"><FormattedMessage id='Выбрать' defaultMessage="Выбрать" /></th>
              <th scope="col"><FormattedMessage id='Удалить' defaultMessage="Удалить" /></th>
            </tr>
          </thead>
          <tbody>
            {tableViewsMarkup}
          </tbody>
        </table>
      </div>

    </Modal>
  );
}
