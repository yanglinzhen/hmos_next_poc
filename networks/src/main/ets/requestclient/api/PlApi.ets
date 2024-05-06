import { SslCertificate } from '../certificates/SSLPinningCertificate'
import { axios, AxiosError, AxiosInstance, AxiosResponse } from '../HttpClientAdapter'

interface UrlConfig {
  baseUrl: string
  loadBalancePath: string
}

class DebugConfig implements UrlConfig {
  baseUrl: string
  loadBalancePath: string

  constructor(baseUrl: string = "https://www.sde3-c.uk.hsbcnet.com",
              loadBalancePath: string = '/uims/portal/IDV_CAM10_AUTHENTICATION',
  ) {
    this.baseUrl = baseUrl
    this.loadBalancePath = loadBalancePath
  }
}

class ProdConfig implements UrlConfig {
  baseUrl: string
  loadBalancePath: string

  constructor(baseUrl: string = "https://www.secure.hsbcnet.com",
              loadBalancePath: string = '/uims/portal/IDV_CAM10_AUTHENTICATION',
  ) {
    this.baseUrl = baseUrl
    this.loadBalancePath = loadBalancePath
  }
}


export interface LoadBalanceResponse {
  title: string,
  description: string,
}

interface PLRequestBody {
  __nativeApp: boolean,
  __respType: string
}

export class PlApi {
  urlConfig: UrlConfig
  axiosPl: AxiosInstance

  //constructor
  constructor(urlConfig: UrlConfig = new DebugConfig()) {
    this.urlConfig = urlConfig
    this.axiosPl = axios.create({
      baseURL: urlConfig.baseUrl,
      timeout: 30000
    })
  }

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
    return this.axiosPl.get<string, AxiosResponse<LoadBalanceResponse>, PLRequestBody>(this.urlConfig.loadBalancePath,
      {
        params: params,
        responseType: 'string',
        transformResponse: this.loadBalanceResponseTransformer,
        // sslCertificateManager: new SslCertificate(),
        // caPath: 'hsbcnet_cert/www.secure.hsbcnet.com.crt',
        context: getContext(this),
      })
  }
}