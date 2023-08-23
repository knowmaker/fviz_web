import axios from 'axios';

export default function getData(setStateFunction, adress, afterRequestFunction, headers) {

  axios
      .get(adress, {headers: headers})
      .then((response) => {
        if (setStateFunction) {
          setStateFunction(response.data);
        } 
        if (afterRequestFunction !== undefined) {
          afterRequestFunction(response.data);
        }
        if (!setStateFunction) {return response.data}
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
    if (setStateFunction) {
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

export function patchData(setStateFunction, adress, data, headers, afterRequestFunction) {

  axios.patch(adress, data, {headers: headers})
  .then((response) => {
    if (setStateFunction) {
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
