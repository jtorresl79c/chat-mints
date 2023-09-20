import axios from 'axios';

export const generateAxiosInstance = (baseUrl = null) => {
    axios.defaults.headers.common['x-api-key'] = '9c6334a7-8215-46ff-8ec9-f442cdc43cac';
    axios.defaults.headers.common['Accept'] = 'application/json';
    axios.defaults.headers.common['Content-Type'] = 'application/json';
    axios.defaults.baseURL = baseUrl;
    return axios;
};