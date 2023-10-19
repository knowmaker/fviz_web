import { toast } from "react-toastify";


export function showMessage(messages, type = "success") {

  // check if passed argument is array and if not then put it into array
  const messagesArray = Array.isArray(messages) ? messages : [messages];

  messagesArray.forEach(message => {
    if (type == "success") {
      toast.success(message, {
        position: "top-center",
        autoClose: 5000,
        hideProgressBar: true,
        closeOnClick: true,
        pauseOnHover: true,
        progress: undefined,
        theme: "colored",
      });
    }

    if (type == "error") {
      toast.error(message, {
        position: "top-center",
        autoClose: 5000,
        hideProgressBar: true,
        closeOnClick: true,
        pauseOnHover: true,
        progress: undefined,
        theme: "colored",
      });
    }

    if (type == "warn") {
      toast.warn(message, {
        position: "top-center",
        autoClose: 5000,
        hideProgressBar: true,
        closeOnClick: true,
        pauseOnHover: true,
        progress: undefined,
        theme: "colored",
      });
    }

  });



}
