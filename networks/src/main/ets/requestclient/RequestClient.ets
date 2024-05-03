import { AxiosError, AxiosInstance, AxiosResponse } from '@ohos/axiosforhttpclient'

import { axios } from './HttpClientAdapter'

type HOST = string

const HOST_CDN = "https://cdn.hsbcnet.com"
const HOST_PL = "https://www.secure.hsbcnet.com"

const axiosCdn = axios.create({
  baseURL: HOST_CDN,
  timeout: 30000
})

const axiosPl = axios.create({
  baseURL: HOST_PL,
  timeout: 30000
})


interface AxiosWrapper {
  axios: AxiosInstance,
  api: NetworkApi
}

interface NetworkApi {}

class CdnApi implements NetworkApi {
  axios: AxiosInstance

  constructor(
    axios: AxiosInstance,
  ) {
    this.axios = axios
  }

  configObjectTransformer = (data: string) => {
    console.log('configObjectTransformer: -->' + data)
    const removeScriptTag = (str: string) => str.trim().replace(/<script[^>]*>|<\/script>/g, '');
    const result = removeScriptTag(data)
    try {
      return JSON.parse(result) as LoadBalanceResponse
    } catch (e) {
      throw e as Error
    }
  }

  async getChecksums() {
    axiosCdn.get<string, AxiosResponse<LoadBalanceResponse>, PLRequestBody>(
      '/uims/cdn/2020203/static-dl/public/mobile/features/cmb_mobile_cp/Production/Global/Config/hsbcnet-mobile-checksum-27810g-prod.xml',
      {
        responseType: 'string',
        transformResponse: this.configObjectTransformer,
      }).then((res: AxiosResponse<LoadBalanceResponse>) => {
      console.log(JSON.stringify(res))
    }).catch((err: AxiosError) => {
      console.log(JSON.stringify(err))
    })
  }
}

interface LoadBalanceResponse {
  title: string,
  description: string,
}

interface PLRequestBody {
  __nativeApp: boolean,
  __respType: string
}

class PlApi implements NetworkApi {

  axios: AxiosInstance

  constructor(
    axios: AxiosInstance,
  ) {
    this.axios = axios
  }

  loadBalanceResponseTransformer = (data: string) => {
    console.log('loadBalanceResponseTransformer: -->' + data)
    const removeScriptTag = (str: string) => str.trim().replace(/<script[^>]*>|<\/script>/g, '');
    const result = removeScriptTag(data)
    try {
      return JSON.parse(result) as LoadBalanceResponse
    } catch (e) {
      throw e as Error
    }
  }

  async loadBalance() {

    const params: PLRequestBody = {
      __nativeApp: true,
      __respType: "JSON"
    }
    this.axios.get<string, AxiosResponse<LoadBalanceResponse>, PLRequestBody>('/uims/portal/IDV_CAM10_AUTHENTICATION',
      {
        params: params,
        responseType: 'string',
        transformResponse: this.loadBalanceResponseTransformer,
        // sslCertificateManager: new SslCertificate(),
        // caPath: 'hsbcnet_cert/www.secure.hsbcnet.com.crt',
        // context: getContext(this),
      }).then((res: AxiosResponse<LoadBalanceResponse>) => {
      console.log(JSON.stringify(res))
    }).catch((err: AxiosError) => {
      console.log(JSON.stringify(err))
    })
  }
}

export class RequestClient {
  getAxios(host: HOST) {
    switch (host) {
      case HOST_CDN:

        return new PlApi(
          axiosCdn,
        )
      default:
        return axiosPl
    }
  }
}