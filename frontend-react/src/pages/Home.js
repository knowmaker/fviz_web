import React,{useEffect,useState, useContext} from 'react';
import TableUI from '../components/Table2';
import Draggable from 'react-draggable';
import getData, {postData, putData} from '../components/api';
import { ToastContainer, toast } from 'react-toastify';


export default function Home() {

    const [isRegModalVisible, setRegModalVisibility] = useState(false);
    const regModalVisibility = {isVisible: isRegModalVisible, setVisibility: setRegModalVisibility}

    const modalsVisibility={regModalVisibility}


    const [userToken, setUserToken] = useState(null)
    const [userProfile, setUserProfile] = useState(null)

    const afterRegister = (userData) => {

      setRegModalVisibility(false)
      toast.success('Registration successful', {
        position: "top-center",
        autoClose: 5000,
        hideProgressBar: true,
        closeOnClick: true,
        pauseOnHover: true,
        progress: undefined,
        theme: "colored",
        });

      postData(setUserToken, process.env.REACT_APP_GK_LOGIN_LINK, userData, undefined, afterLogin)
    }

    const afterLogin = (token) => {

      setRegModalVisibility(false)
      
      toast.success('Login successful', {
        position: "top-center",
        autoClose: 5000,
        hideProgressBar: true,
        closeOnClick: true,
        pauseOnHover: true,
        progress: undefined,
        theme: "colored",
      });

      const headers = {
        Authorization: `Bearer ${token}`
      }

      putData(setUserProfile, process.env.REACT_APP_GK_PROFILE_LINK, undefined, headers )
    }

    console.log(userProfile)

    const register = () => {

        const email = document.getElementById("InputEmail1").value
        const password = document.getElementById("InputPassword1").value

        const userData = {
          user: {
            email: email,
            password: password,
            last_name: "test",
            first_name: "test",
            patronymic: "test"
          }
        }



        postData(undefined, process.env.REACT_APP_GK_REGISTER_LINK, userData, undefined, afterRegister)
        

    }

    const login = () => {


      const email = document.getElementById("InputEmail2").value
      const password = document.getElementById("InputPassword2").value
      const userLoginData = {
        email: email,
        password: password,
      }

      postData(setUserToken, process.env.REACT_APP_GK_LOGIN_LINK, userLoginData, undefined, afterLogin)
    }

    return (
            <>
              
                <TableUI modalsVisibility={modalsVisibility}/>

                <div id="modal-mask" className="hidden">
                    <Modal
                    modalVisibility={regModalVisibility}
                    title={"Register/Login"}
                    hasBackground={true}
                    >
                    <div className="modal-content2">

                    <nav>
                        <div className="nav nav-tabs" id="nav-tab" role="tablist">
                            <button className="nav-link active" id="nav-login-tab" data-bs-toggle="tab" data-bs-target="#login" type="button" role="tab" aria-controls="login" aria-selected="true">Login</button>
                            <button className="nav-link" id="nav-register-tab" data-bs-toggle="tab" data-bs-target="#register" type="button" role="tab" aria-controls="register" aria-selected="false">Register</button>
                        </div>
                    </nav>
                    <div className="tab-content" id="nav-tabContent">
                        <div className="tab-pane fade show active" id="login" role="tabpanel" aria-labelledby="login-tab" tabIndex="0">

                            <div className="modal-content2">
                              <label htmlFor="InputEmail2" className="form-label">Email address</label>
                              <input type="email" className="form-control" id="InputEmail2" aria-describedby="emailHelp" placeholder="name@example.com"/>
                              <label htmlFor="InputPassword2" className="form-label">Password</label>
                              <input type="password" className="form-control" id="InputPassword2"/>
                            </div>

                            <div className="modal-footer2">

                                <button type="button" className="btn btn-secondary" onClick={() => setRegModalVisibility(false)}>Close</button>
                                <button type="button" className="btn btn-primary" onClick={() => login()}>Send</button>
                            </div>
                        </div>
                        <div className="tab-pane fade" id="register" role="tabpanel" aria-labelledby="register-tab" tabIndex="0">

                            <div className="modal-content2">
                                <label htmlFor="InputEmail1" className="form-label">Email address</label>
                                <input type="email" className="form-control" id="InputEmail1" aria-describedby="emailHelp" placeholder="name@example.com"/>
                                <label htmlFor="InputPassword1" className="form-label">Password</label>
                                <input type="password" className="form-control" id="InputPassword1"/>
                                <div id="passwordHelpBlock" className="form-text">
                                    Your password must be 8-20 characters long.
                                </div>
                            </div>


                            <div className="modal-footer2">
                                <button type="button" className="btn btn-secondary" onClick={() => setRegModalVisibility(false)}>Close</button>
                                <button type="button" className="btn btn-primary" onClick={() => register()}>Send</button>
                            </div>
                        </div>
                    </div>
                    </div>

                   

                    </Modal>
                </div>
                <ToastContainer />
            </>
    );
}

function Modal({ children, modalVisibility, title, hasBackground }) {

    const modalStartPos = (window.innerWidth / 2) - Math.min(260,window.innerWidth/2)
  
    useEffect(() => {

    if (modalVisibility.isVisible && hasBackground) {
      document.getElementById("modal-mask").classList.remove("hidden")
    } else
    {
      document.getElementById("modal-mask").classList.add("hidden")
    }
    }, [modalVisibility.isVisible,hasBackground])
  
    const nodeRef = React.useRef(null);
      return (
        <Draggable
          handle=".modal-title2"
          defaultPosition={{x: modalStartPos, y: 250}}
          bounds="#modal-mask"
          nodeRef={nodeRef}
          scale={1}
          >
          <div className={`drag-modal ${modalVisibility.isVisible ? "" : "hidden"}`} ref={nodeRef}>
  
            <div className="modal-title2">
              <span>{title}</span>
              <button type="button" className="btn-close" onClick={() => modalVisibility.setVisibility(false)}></button>
            </div>
                {children}
          </div>
        </Draggable>
      );
  }


