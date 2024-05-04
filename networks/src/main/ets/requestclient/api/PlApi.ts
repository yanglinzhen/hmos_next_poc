import { axios, AxiosError, AxiosInstance, AxiosResponse } from '../HttpClientAdapter'
export type ChecksumResponse = object


export const HOST_PL = "https://www.secure.hsbcnet.com"

const axiosPl = axios.create({
  baseURL: HOST_PL,
  timeout: 30000
})


export interface LoadBalanceResponse {
  title: string,
  description: string,
}

interface PLRequestBody {
  __nativeApp: boolean,
  __respType: string
}

export class PlApi {

  loadBalanceResponseTransformer = (data: string) => {
    console.info('RequestClient -->:', 'loadBalanceResponseTransformer: -->' + data)
    const removeScriptTag = (str: string) => str.trim().replace(/<script[^>]*>|<\/script>/g, '');
    const result = removeScriptTag(data)
    try {
      return JSON.parse(result) as LoadBalanceResponse
    } catch (e) {
      throw e as Error
    }
  }

  loadBalance() {
    const params: PLRequestBody = {
      __nativeApp: true,
      __respType: "JSON"
    }
    return axiosPl.get<string, AxiosResponse<LoadBalanceResponse>, PLRequestBody>('/uims/portal/IDV_CAM10_AUTHENTICATION',
      {
        params: params,
        responseType: 'string',
        transformResponse: this.loadBalanceResponseTransformer,
        // sslCertificateManager: new SslCertificate(),
        // caPath: 'hsbcnet_cert/www.secure.hsbcnet.com.crt',
        // context: getContext(this),
      })
  }
}