import { axios, AxiosResponse } from '../HttpClientAdapter'

import { Entity, getEntityList } from '@ohos/commonLib/src/main/ets/viewmodel/Entity';

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
  urlConfig: UrlConfig = new DebugConfig()

  axiosCdn = axios.create({
    baseURL: this.urlConfig.baseUrl,
    timeout: 30000
  })

  configObjectTransformer = (data: string) => {
    const removeScriptTag = (str: string) => str.trim().replace(/<script[^>]*>|<\/script>/g, '');
    const result = removeScriptTag(data)
    try {
      return JSON.parse(result) as ChecksumResponse
    } catch (e) {
      throw e as Error
    }
  }

  entityListTransformer = (data: string) => {
    const entityList = getEntityList(data)
    try {
      return entityList
    } catch (e) {
      throw e as Error
    }
  }

  getChecksums() {
    return this.axiosCdn.get<string, AxiosResponse<ChecksumResponse>, null>(
      this.urlConfig.checksumPath,
      {
        responseType: 'string',
        transformResponse: this.configObjectTransformer,
        // sslCertificateManager: new SslCertificate(),
        // caPath: 'hsbcnet_cert/cdn.hsbcnet.com.crt',
        // context: getContext(this),
      })
  }

  fetchEntityList() {
    return this.axiosCdn.get<string, AxiosResponse<Entity[]>, null>(
      this.urlConfig.entityListPath,
      {
        responseType: 'string',
        transformResponse: this.entityListTransformer,
      })
  }
}
