import { SslCertificate } from './certificates/SSLPinningCertificate'
import { axios, AxiosError, AxiosInstance, AxiosResponse } from './HttpClientAdapter'
import certFramework from '@ohos.security.cert';
import base64 from 'base64-js'

import http from '@ohos.net.http';
import { CdnApi, HOST_CDN } from './api/CdnApi';
import { PlApi } from './api/PlApi';

export async function Get(url: string = 'https://cdn.hsbcnet.com/uims/cdn/2020203/static-dl/public/mobile/features/cmb_mobile_cp/Production/Global/Config/hsbcnet-mobile-checksum-27810g-prod.xml') {
  if (!url) {
    return undefined;
  }
  let request = http.createHttp();
  let options = {
    method: http.RequestMethod.GET,
    header: { 'Content-Type': 'application/json' },
    readTimeout: 30000,
    connectTimeout: 30000,
    // caPath: 'hsbcnet_cert/cdn.hsbcnet.com.crt',
  } as http.HttpRequestOptions;
  return request.request(url, options)
}

type HOST = string

export class RequestClient {
  getAxios(host: HOST) {
    switch (host) {
      case HOST_CDN:
        return new CdnApi()
      default:
        return new PlApi()
    }
  }
}