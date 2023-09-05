import axios from 'axios';

export default function getData(setStateFunction, adress, afterRequestFunction, headers, extraData) {

  axios
      .get(adress, {headers: headers})
      .then((response) => {
        if (setStateFunction) {
          setStateFunction(response.data);
        } 
        if (afterRequestFunction !== undefined) {
          afterRequestFunction(response.data,extraData);
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

export function deleteData(setStateFunction, adress, headers, afterRequestFunction) {

  axios.delete(adress, {headers: headers})
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

export function getAllCellData(cells,headers,callbackFunction) {

  let requests = cells.map(cell => axios.get(`http://localhost:5000/api/quantities/${cell}`, {headers: headers}));

  Promise.all(requests)
    .then(responses => {

      //console.log(responses)

      const cells = responses.map(response => response.data)
      //callbackFunction(responses)
      callbackFunction(cells)
    })

}