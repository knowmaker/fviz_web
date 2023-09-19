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
      const response = await axios.delete(adress, data, {headers: headers})
      resolve(response)
    } catch (error) {
      resolve(error.response)
    }
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
          afterRequestFunction(response.data.data,extraData);
        }
        if (!setStateFunction) {return response.data.data}
      })
      .catch((error) => {
        console.log(adress,headers)
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
    console.log(error);
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

export function getAllCellData(cells,headers,callbackFunction, extraData) {

  let requests = cells.map(cell => axios.get(`http://localhost:5000/api/quantities/${cell}`, {headers: headers}));

  Promise.all(requests)
    .then(responses => {

      //console.log(responses)

      const cells = responses.map(response => response.data.data)
      //callbackFunction(responses)
      callbackFunction(cells, extraData)
    })

}

export function patchAllLayerData(layers,headers,callbackFunction, extraData) {




  // let requests = layers.map((layer) => {

  //   const newLayerBrightness = {
  //     "gk_setting": {
  //       "gk_bright": layer.brightness
  //     }
  //   }

  //   console.log(newLayerBrightness,headers)

  //   return axios.patch(`http://localhost:5000/api/gk/${layer.id}`,newLayerBrightness, {headers: headers})});

  // Promise.all(requests)
  //   .then(responses => {

  //     console.log(responses)

  //     const results = responses.map(response => response.data.data)
  //     //callbackFunction(responses)
  //     callbackFunction(results, extraData)
  //   })

}