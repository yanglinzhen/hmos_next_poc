import { axios, AxiosError, AxiosResponse } from '@ohos/axiosforhttpclient'

interface LoadBalanceResponse {
  title: string,
  description: string,
}

interface PLRequestBody {
  __nativeApp: boolean,
  __respType: string
}

const BASE_URL = 'https://www.secure.hsbcnet.com'

const axiosInstance = axios.create({
  baseURL: BASE_URL,
  timeout: 30000,
})

const loadBalanceResponseTransformer = (data: string) => {
  const removeScriptTag = (str: string) => str.trim().replace(/<script[^>]*>|<\/script>/g, '');
  const result = removeScriptTag(data)
  try {
    return JSON.parse(result) as LoadBalanceResponse
  } catch (e) {
    return {
      title: "title",
      body: 'body'
    }
  }
}

export class RequestClient {
  async loadBalance() {
    const params: PLRequestBody = {
      __nativeApp: true,
      __respType: "JSON"
    }
    axiosInstance.get<string, AxiosResponse<LoadBalanceResponse>, PLRequestBody>('/uims/portal/IDV_CAM10_AUTHENTICATION',
      {
        params: params,
        responseType: 'string',
        transformResponse: loadBalanceResponseTransformer,
      }).then((res: AxiosResponse<LoadBalanceResponse>) => {
      console.log(JSON.stringify(res))
    }).catch((err: AxiosError) => {
      console.log(JSON.stringify(err))
    })
  }
}