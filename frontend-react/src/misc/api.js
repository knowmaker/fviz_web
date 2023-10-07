import axios from 'axios';

export function getDataFromAPI(adress, headers = undefined) {
  return new Promise(async function(resolve) {
    try {
      const response = await axios.get(adress, {headers: headers})
      //console.log(adress,headers,response)
      resolve(response)
    } catch (error) {
      resolve(error.response)
    }
  })
  // return axios.get(adress, {headers: headers})
}

export function postDataToAPI(adress,data, headers = undefined) {
  return new Promise(async function(resolve) {
    try {
      const response = await axios.post(adress, data, {headers: headers})
      resolve(response)
    } catch (error) {
      resolve(error.response)
    }
  })
  //return axios.post(adress, data, {headers: headers})
}

export function putDataToAPI(adress,data, headers = undefined) {
  return new Promise(async function(resolve) {
    try {
      const response = await axios.put(adress, data, {headers: headers})
      resolve(response)
    } catch (error) {
      resolve(error.response)
    }
  })

}

export function patchDataToAPI(adress,data, headers = undefined) {
  return new Promise(async function(resolve) {
    try {
      const response = await axios.patch(adress, data, {headers: headers})
      resolve(response)
    } catch (error) {
      resolve(error.response)
    }
  })

}

export function deleteDataFromAPI(adress,data, headers = undefined) {
  return new Promise(async function(resolve) {
    try {
      const response = await axios.delete(adress, {headers: headers})
      console.log(adress,data,{headers: headers})
      resolve(response)
    } catch (error) {
      resolve(error.response)
      console.log(adress,data, headers)
    }
  })

}

export function getAllCellDataFromAPI(cells,headers) {

  let requests = cells.map(cell => axios.get(`${process.env.REACT_APP_API_LINK}/quantities/${cell}`, {headers: headers}));

  return new Promise(async function(resolve) {

    const responses = await Promise.allSettled(requests)
    resolve(responses.map(cellResponse => cellResponse.value))
  })


}

export default function setStateFromGetAPI(setStateFunction, adress, afterRequestFunction, headers, extraData) {

  axios
      .get(adress, {headers: headers})
      .then((response) => {
        if (setStateFunction) {
          setStateFunction(response.data.data);
        } 
        if (afterRequestFunction !== undefined) {
          afterRequestFunction(response.data.data,extraData,{adress:adress,headers:headers});
        }
        if (!setStateFunction) {return response.data.data}
      })
      .catch((error) => {
        console.log("ERROR:",adress,headers)
        //console.error(error);
      });

}

export function postData(setStateFunction, adress, data, headers, afterRequestFunction) {

  axios.post(adress, data, {headers: headers})
  .then((response) => {
    if (setStateFunction !== undefined) {
      setStateFunction(response.data.data);
    }
    if (afterRequestFunction !== undefined) {
      afterRequestFunction(response.data.data);
    }
  })
  .catch((error) => {
    console.log(adress, data, headers);
  });
}

export function putData(setStateFunction, adress, data, headers, afterRequestFunction) {

  axios.put(adress, data, {headers: headers})
  .then((response) => {
    if (setStateFunction) {
      setStateFunction(response.data.data);
    }
    if (afterRequestFunction !== undefined) {
      afterRequestFunction(response.data.data);
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
      setStateFunction(response.data.data);
    }
    if (afterRequestFunction !== undefined) {
      afterRequestFunction(response.data.data);
    }
  })
  .catch((error) => {
    console.log(error);
  });
}

export function deleteData(setStateFunction, adress, headers, afterRequestFunction) {

  axios.delete(adress, {headers: headers})
  .then((response) => {
    console.log(adress, headers);
    if (setStateFunction) {
      setStateFunction(response.data.data);
    }
    if (afterRequestFunction !== undefined) {
      afterRequestFunction(response.data.data);
    }
  })
  .catch((error) => {
    console.log(adress, headers);
  });
}
export function isResponseSuccessful(response) {
  if (response.status < 300) { return true; }
  return false;
}

