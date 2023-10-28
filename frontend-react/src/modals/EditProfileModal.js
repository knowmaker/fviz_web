import React, { useContext, useRef } from 'react';
import { patchDataToAPI, deleteDataFromAPI } from '../misc/api.js';
import { UserProfile } from '../misc/contexts.js';
import { isResponseSuccessful } from '../misc/api.js';
import { FormattedMessage, useIntl } from 'react-intl';
import { showPassword } from '../pages/Home.js';
import { showMessage } from '../misc/message.js';
import { Modal } from './Modal.js';
import { Button } from '../components/ButtonWithLoad.js';

export function EditProfileModal({ modalsVisibility, currentLocaleState }) {

  const modalVisibility = modalsVisibility.editProfileModalVisibility;
  const userInfoState = useContext(UserProfile);
  const headers = {
    Authorization: `Bearer ${userInfoState.userToken}`
  };

  const intl = useIntl();

  const editProfile = async () => {

    // get values from fields
    const firstName = document.getElementById("InputFirstName3").value;
    const lastName = document.getElementById("InputLastName3").value;
    const patronymic = document.getElementById("InputPatronymic3").value;
    const password = document.getElementById("InputPassword3").value;
    const locale = document.getElementById("inputLocale").value;

    let newUserData = {
      user: {
        last_name: lastName,
        first_name: firstName,
        patronymic: patronymic,
        locale: locale,
      }
    };

    // if new password field is not empty add it to json
    if (password !== "") {
      newUserData.user.password = password;
    }

    // send profile update request
    const editUserResponse = await patchDataToAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/users/update`, newUserData, headers);
    if (!isResponseSuccessful(editUserResponse)) {
      showMessage(editUserResponse.data.error, "error");
      return;
    }

    // hide modal
    modalVisibility.setVisibility(false);
    showMessage(intl.formatMessage({ id: `Профиль обновлён`, defaultMessage: `Профиль обновлён` }));

    // empty input fields
    document.getElementById("InputEmail2").value = "";
    document.getElementById("InputPassword2").value = "";
    document.getElementById("InputEmail1").value = "";
    document.getElementById("InputPassword1").value = "";

    // change current locate acctording to user preferences
    currentLocaleState.setCurrentLocale(locale);

  };

  const deleteUser = async () => {
    if (!window.confirm(intl.formatMessage({ id: `Подтверждение действия`, defaultMessage: `Вы уверены что хотите это сделать? Это приведёт к последствиям для других пользователей.` }))) {
      return;
    }

    // send delete request
    const deleteUserResponse = await deleteDataFromAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/delete`, undefined, headers);
    if (!isResponseSuccessful(deleteUserResponse)) {
      showMessage(deleteUserResponse.data.error, "error");
      return;
    }
    // show message and delete user token
    showMessage(intl.formatMessage({ id: `Аккаунт удалён`, defaultMessage: `Аккаунт удалён` }));
    userInfoState.setUserToken(null);

  };

  const InputPassword = useRef();
  const InputPasswordEye = useRef();

  return (
    <Modal
      modalVisibility={modalVisibility}
      title={intl.formatMessage({ id: `Редактирование профиля`, defaultMessage: `Редактирование профиля` })}
      hasBackground={true}
    >
      <div className="modal-content2">

        <label htmlFor="InputEmail3" className="form-label"><FormattedMessage id='Почта' defaultMessage="Почта" /></label>
        <input type="email" className="form-control" id="InputEmail3" aria-describedby="emailHelp" placeholder="name@example.com" disabled={true} />
        <label htmlFor="InputLastName3" className="form-label"><FormattedMessage id='Новый пароль' defaultMessage="Новый пароль" /></label>
        <div className="input-group" id="show_hide_password">
          <input type="password" className="form-control" id="InputPassword3" ref={InputPassword} />
          <div className="input-group-text">
            <span className='showPassword' onClick={() => { showPassword(InputPassword, InputPasswordEye); }}>👁<i className="fa fa-eye-slash" aria-hidden="true" ref={InputPasswordEye} /></span>
          </div>
        </div>
        <label htmlFor="InputLastName3" className="form-label"><FormattedMessage id='Фамилия' defaultMessage="Фамилия" /></label>
        <input type="text" className="form-control" id="InputLastName3" />
        <label htmlFor="InputFirstName3" className="form-label"><FormattedMessage id='Имя' defaultMessage="Имя" /></label>
        <input type="text" className="form-control" id="InputFirstName3" />
        <label htmlFor="InputPatronymic3" className="form-label"><FormattedMessage id='Отчество' defaultMessage="Отчество" /></label>
        <input type="text" className="form-control" id="InputPatronymic3" />
        <label htmlFor="InputPatronymic3" className="form-label"><FormattedMessage id='Язык' defaultMessage="Язык" /></label>
        <select className="form-select" aria-label="Default select example" id='inputLocale'>
          <option value={"en"}>English</option>
          <option value={"ru"}>Русский</option>
        </select>
      </div>
      <div className="modal-footer2">
        <Button type="button" className="btn btn-danger me-1" onClick={(e) => deleteUser(e)}><FormattedMessage id='Удалить аккаунт' defaultMessage="Удалить аккаунт" /></Button>
        <Button type="button" className="btn btn-success" onClick={(e) => editProfile(e)}><FormattedMessage id='Сохранить' defaultMessage="Сохранить" /></Button>
      </div>

    </Modal>
  );
}
