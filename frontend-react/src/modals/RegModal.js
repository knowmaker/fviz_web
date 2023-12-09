import React, { useEffect, useRef } from 'react';
import { postDataToAPI } from '../misc/api.js';
import { isResponseSuccessful } from '../misc/api.js';
import { FormattedMessage, useIntl } from 'react-intl';
import { showPassword } from '../pages/Home.js';
import { showMessage } from '../misc/message.js';
import { Modal } from './Modal.js';
import { Button } from '../components/ButtonWithLoad.js';

export function RegistrationModal({ modalVisibility, setUserToken, currentLocaleState }) {

  const intl = useIntl();

  useEffect(() => {
    if (modalVisibility.isVisible === false) {
      document.getElementById("InputEmail1").value = "";
      document.getElementById("InputPassword1").value = "";
      document.getElementById("InputEmail2").value = "";
      document.getElementById("InputPassword2").value = "";
      document.getElementById("InputEmail5").value = "";
    }
  }, [modalVisibility.isVisible]);

  const register = async () => {


    // get email and password from fields
    const email = document.getElementById("InputEmail1").value;
    const password = document.getElementById("InputPassword1").value;
    const locale = currentLocaleState.currentLocale;

    const userData = {
      user: {
        email: email,
        password: password,
        locale: locale,
      }
    };

    // try to register
    const registerResponseData = await postDataToAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/users/register`, userData);
    if (!isResponseSuccessful(registerResponseData)) {
      showMessage(registerResponseData.data.error, "error");
      return;
    }

    // hide modal and show message
    modalVisibility.setVisibility(false);
    showMessage(intl.formatMessage({ id: `Письмо подтверждения почты`, defaultMessage: `Было выслано письмо подтверждения почты` }));


  };

  // on login function
  const login = async (e) => {

    // get email and password from fields
    const email = document.getElementById("InputEmail2").value;
    const password = document.getElementById("InputPassword2").value;
    const userLoginData = {
      user: {
        email: email,
        password: password,
      }
    };

    // try to log in 
    const loginResponse = await postDataToAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/users/login`, userLoginData);

    if (!isResponseSuccessful(loginResponse)) {
      showMessage(loginResponse.data.error, "error");
      return;
    }

    // if succesful set user token
    const loginResponseData = loginResponse.data.data;
    setUserToken(loginResponseData);

    // hide modal and show message
    modalVisibility.setVisibility(false);
    showMessage(intl.formatMessage({ id: `Авторизация успешна`, defaultMessage: `Авторизация успешна` }));
  
  };


  const forgotPassword = async () => {

    // get email field
    const email = document.getElementById("InputEmail5").value;

    const userData = {
      user: {
        email: email,
      }
    };

    // send password reset request
    const resetPasswordResponse = await postDataToAPI(`${process.env.REACT_APP_API_LINK}/${intl.locale}/users/reset`, userData);
    if (!isResponseSuccessful(resetPasswordResponse)) {
      showMessage(resetPasswordResponse.data.error, "error");
      return;
    }
    // show message
    showMessage(intl.formatMessage({ id: `Письмо сброса пароля`, defaultMessage: `Письмо сброса пароля выслано` }));
  };

  const clearAllFields = () => {
    document.getElementById("InputEmail1").value = "";
    document.getElementById("InputPassword1").value = "";
    document.getElementById("InputEmail2").value = "";
    document.getElementById("InputPassword2").value = "";
    document.getElementById("InputEmail5").value = "";
  }

  const InputRegisterPassword = useRef();
  const InputRegisterPasswordEye = useRef();

  const InputLoginPassword = useRef();
  const InputLoginPasswordEye = useRef();

  return (
    <Modal
      modalVisibility={modalVisibility}
      title={intl.formatMessage({ id: `Авторизация / Регистрация`, defaultMessage: `Авторизация / Регистрация` })}
      hasBackground={true}
    >
      <div className="modal-content2">

        <nav>
          <div className="nav nav-tabs" id="nav-tab" role="tablist">
            <button className="nav-link active" id="nav-login-tab" data-bs-toggle="tab" data-bs-target="#login" type="button" role="tab" aria-controls="login" aria-selected="true" onClick={clearAllFields}><FormattedMessage id='Авторизация' defaultMessage="Авторизация" /></button>
            <button className="nav-link" id="nav-register-tab" data-bs-toggle="tab" data-bs-target="#register" type="button" role="tab" aria-controls="register" aria-selected="false" onClick={clearAllFields}><FormattedMessage id='Регистрация' defaultMessage="Регистрация" /></button>
            <button className="nav-link" id="nav-forgot-password-tab" data-bs-toggle="tab" data-bs-target="#forgot-password" type="button" role="tab" aria-controls="forgot-password" aria-selected="false" onClick={clearAllFields}><FormattedMessage id='Сброс пароля' defaultMessage="Сброс пароля" /></button>
          </div>
        </nav>
        <div className="tab-content" id="nav-tabContent">
          <div className="tab-pane fade show active" id="login" role="tabpanel" aria-labelledby="login-tab" tabIndex="0">

            <div className="modal-content2">
              <label htmlFor="InputEmail2" className="form-label"><FormattedMessage id='Почта' defaultMessage="Почта" /></label>
              <input type="email" className="form-control" id="InputEmail2" aria-describedby="emailHelp" placeholder="name@example.com" />
              <label htmlFor="InputPassword2" className="form-label"><FormattedMessage id='Пароль' defaultMessage="Пароль" /></label>

              <div className="input-group" id="show_hide_password">
                <input type="password" className="form-control" id="InputPassword2" ref={InputRegisterPassword} />
                <div className="input-group-text">
                  <span className='showPassword' onClick={() => { showPassword(InputRegisterPassword, InputRegisterPasswordEye); }}>👁<i className="fa fa-eye-slash" aria-hidden="true" ref={InputRegisterPasswordEye} /></span>
                </div>
              </div>
            </div>

            <div className="modal-footer2">
              <Button className="btn btn-primary" onClick={(e) => login(e)}><FormattedMessage id='Вход' defaultMessage="Вход" /></Button>
            </div>
          </div>
          <div className="tab-pane fade" id="register" role="tabpanel" aria-labelledby="register-tab" tabIndex="0">

            <div className="modal-content2">
              <label htmlFor="InputEmail1" className="form-label"><FormattedMessage id='Почта' defaultMessage="Почта" /></label>
              <input type="email" className="form-control" id="InputEmail1" aria-describedby="emailHelp" placeholder="name@example.com" />
              <label htmlFor="InputPassword1" className="form-label"><FormattedMessage id='Пароль' defaultMessage="Пароль" /></label>
              <div className="input-group" id="show_hide_password">
                <input type="password" className="form-control" id="InputPassword1" ref={InputLoginPassword} />
                <div className="input-group-text">
                  <span className='showPassword' onClick={() => { showPassword(InputLoginPassword, InputLoginPasswordEye); }}>👁<i className="fa fa-eye-slash" aria-hidden="true" ref={InputLoginPasswordEye} /></span>
                </div>
              </div>
            </div>

            <div className="modal-footer2">
              <Button type="button" className="btn btn-primary" onClick={(e) => register(e)}><FormattedMessage id='Регистрация' defaultMessage="Регистрация" /></Button>
            </div>
          </div>
          <div className="tab-pane fade" id="forgot-password" role="tabpanel" aria-labelledby="forgot-password-tab" tabIndex="0">

            <div className="modal-content2">
              <label htmlFor="InputEmail5" className="form-label"><FormattedMessage id='Почта' defaultMessage="Почта" /></label>
              <input type="email" className="form-control" id="InputEmail5" aria-describedby="emailHelp" placeholder="name@example.com" />
            </div>

            <div className="modal-footer2">
              <Button type="button" className="btn btn-primary" onClick={(e) => forgotPassword(e)}><FormattedMessage id='Сброс' defaultMessage="Сброс" /></Button>
            </div>
          </div>
        </div>
      </div>


    </Modal>
  );


}


