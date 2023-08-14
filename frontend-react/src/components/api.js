import axios from 'axios';

export default function getData(setStateFunction, adress) {

  axios
      .get(adress)
      .then((response) => {
          setStateFunction(response.data);
      })
      .catch((error) => {
          console.error(error);
      });

}

export function postData(setStateFunction, adress, data, headers, afterRequestFunction) {

  axios.post(adress, data, {headers: headers})
  .then((response) => {
    if (setStateFunction !== undefined) {
      setStateFunction(response.data);
    }
    if (afterRequestFunction !== undefined) {
      afterRequestFunction(response.data);
    }
  })
  .catch((error) => {
    console.log(error);
  });
}

export function putData(setStateFunction, adress, data, headers, afterRequestFunction) {

  axios.put(adress, data, {headers: headers})
  .then((response) => {
    if (setStateFunction !== undefined) {
      setStateFunction(response.data);
    }
    if (afterRequestFunction !== undefined) {
      afterRequestFunction(response.data);
    }
  })
  .catch((error) => {
    console.log(error);
  });
}