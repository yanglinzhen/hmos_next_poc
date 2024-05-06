import { axios, AxiosInstance, AxiosProgressEvent, AxiosResponse } from '../HttpClientAdapter'
import { getUrlAndAuthHeader, getUrlPath } from './UrlUtils'

export type ChecksumResponse = object

export const HOST_CDN = "https://cdn.hsbcnet.com"

interface UrlConfig {
  baseUrl: string,
  entityListPath: string,
  checksumPath: string,
}

class DebugConfig implements UrlConfig {
  baseUrl: string
  entityListPath: string
  checksumPath: string

  constructor(baseUrl: string = 'https://netmobile:MobP8w@www.hkg1vl0077.p2g.netd2.hsbc.com.hk',
              entityListPath: string = '/mobile/mobileApp/R79/Global/hsbcnet-mobile-entitylist-27900g-ft.xml',
              checksumPath: string = '/mobile/mobileApp/R79/Global/hsbcnet-mobile-checksum-27900g-ft.xml') {
    this.baseUrl = baseUrl
    this.entityListPath = entityListPath
    this.checksumPath = checksumPath
  }
}

class ProdConfig implements UrlConfig {
  baseUrl: string
  entityListPath: string
  checksumPath: string

  constructor(baseUrl: string = "https://cdn.hsbcnet.com",
              entityListPath: string = 'uims/cdn/2020203/static-dl/public/mobile/features/cmb_mobile_cp/Production/Global/Config/hsbcnet-mobile-entitylist-27810g-prod.xml',
              checksumPath: string = '/uims/cdn/2020203/static-dl/public/mobile/features/cmb_mobile_cp/Production/Global/Config/hsbcnet-mobile-checksum-27810g-prod.xml') {
    this.baseUrl = baseUrl
    this.entityListPath = entityListPath
    this.checksumPath = checksumPath
  }
}

export class CdnApi {
  urlConfig: UrlConfig
  axiosCdn: AxiosInstance

  constructor(urlConfig: UrlConfig = new DebugConfig()) {
    this.urlConfig = urlConfig
    const urlAndAuth = getUrlAndAuthHeader(urlConfig.baseUrl)

    if (urlAndAuth.header) {
      this.axiosCdn = axios.create({
        baseURL: urlAndAuth.url,
        timeout: 30000,
        headers: {
          'Authorization': urlAndAuth.header
        }
      })
    } else {
      this.axiosCdn = axios.create({
        baseURL: this.urlConfig.baseUrl,
        timeout: 30000,
      })
    }

  }

  getConfig<T>(url: string, transformer: (data: string) => T) {
    return this.axiosCdn.get<string, AxiosResponse<T>, null>(
      getUrlPath(url),
      {
        responseType: 'string',
        transformResponse: transformer,
      })
  }

  downloadFile(url: string, filePath: string, downloadProgress: (progressEvent: AxiosProgressEvent) => void) {
    return this.axiosCdn.get<string, AxiosResponse<string>, null>(
      getUrlPath(url), {
      headers: { 'Content-Type': 'application/zip' },
      context: getContext(this),
      filePath: filePath,
      onDownloadProgress: downloadProgress
    })
  }

  fetchEntityList<T>(transformer: (data: string) => T) {
    return this.axiosCdn.get<string, AxiosResponse<T>, null>(
      this.urlConfig.entityListPath,
      {
        responseType: 'string',
        transformResponse: transformer,
      })
  }
}
