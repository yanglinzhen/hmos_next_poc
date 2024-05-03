/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import axios from '@ohos/axios/index'
import buildURL from '@ohos/axios/src/main/ets/components/lib/helpers/buildURL'
import download from '@ohos/axios/src/main/ets/components/lib/adapters/ohos/download'
import upload from '@ohos/axios/src/main/ets/components/lib/adapters/ohos/upload'
import {
   AxiosHeaders,
   RawAxiosRequestHeaders,
   AxiosRequestHeaders,
   RawAxiosResponseHeaders,
   AxiosResponseHeaders,
   AxiosRequestTransformer,
   AxiosResponseTransformer,
   AxiosAdapter,
   AxiosBasicCredentials,
   HttpStatusCode,
   Method,
   ResponseType,
   responseEncoding,
   CertType,
   ClientCert,
   TransitionalOptions,
   GenericAbortSignal,
   FormDataVisitorHelpers,
   SerializerVisitor,
   SerializerOptions,
   ParamEncoder,
   CustomParamsSerializer,
   ParamsSerializerOptions,
   AxiosProgressEvent,
   RawAxiosRequestConfig,
   HeadersDefaults,
   AxiosDefaults,
   CreateAxiosDefaults,
   CanceledError,
   AxiosPromise,
   CancelStatic,
   Cancel,
   Canceler,
   CancelTokenStatic,
   CancelToken,
   CancelTokenSource,
   AxiosInterceptorOptions,
   AxiosInterceptorManager,
   AxiosInstance,
   GenericFormData,
   GenericHTMLFormElement,
   toFormData,
   formToJSON,
   isAxiosError,
   spread,
   isCancel,
   all,
   AxiosStatic,
   FormData,
   InternalAxiosRequestConfig,
   FormSerializerOptions,
   AxiosResponse,
   AxiosError,
   AxiosRequestConfig,
   AxiosProxyConfig,

} from '@ohos/axios/index';
import {
   CAResUtil,
   Request,
   Response,
   X509TrustManager,
   BusinessError,
   HttpDataType,
   Logger,
   TimeUnit,
   Type,
   Proxy,
   CertificatePinnerBuilder,
   HttpClient,
   RequestBody,
   Cookie,
   CookieJar,
   CookieStore,
   CookieManager,
   Route,
   DnsResolve,
   gZipUtil,
   JsonCallback,
   StringCallback,
   ByteStringCallback,
   CookiePolicy,
   FileUpload,
   BinaryFileChunkUpload,
   FormEncoder,
   Mime,
   MultiPart,
   RealWebSocket,
   WebSocketListener,
   WebSocket,
   Factory,
   Dns,
   Interceptor,
   Chain,
   Credentials,
   Authenticator,
   NetAuthenticator,
   Challenge,
   Headers,
   HttpHeaders,
   Utils,
   RealTLSSocket,
   OkHostnameVerifier,
   StringUtil,
   TLSSocketListener,
   Cache,
   CacheControl,
   Protocol,
   EventListener,
   IOException,
   HttpCall,
} from '@ohos/httpclient';

import fs from '@ohos.file.fs';

const TAG: string = "HttpClientAdapter";
export const HttpClientAdapter = (config: InternalAxiosRequestConfig) => {
   return new Promise(async (resolve, reject) => {
      if (config.data && config.context
         && config.data instanceof FormData
         && config.method.toUpperCase() === 'POST') {
         // 上传
         upload(config, resolve, reject);
      } else if (config.filePath && config.method.toUpperCase() === 'GET') {
         // 下载。如果文件已存在，则直接返回错误。
         try {
            let cacheDir = config.context && config.context.cacheDir ? config.context.cacheDir : '';
            let filePath = config.filePath
            let path = config.filePath.indexOf(cacheDir) > -1 ?  filePath : `${cacheDir}/${filePath}`
            let res = fs.accessSync(path);
            if(!res){
               download(config, resolve, reject);
            }else {
               reject(new AxiosError('The file already exist, please delete the file first!', AxiosError.ERR_BAD_OPTION, null, null, null));
            }
         } catch (err) {
            reject(new AxiosError(err, AxiosError.ERR_BAD_OPTION, null, null, null));
         }
      } else {
         // 发送请求
         try {
            // config属性获取和client构造判断
            Logger.debug(TAG + " request config111:" + JSON.stringify(JSON.parse(JSON.stringify(config)), null, 4));
            let url = buildFullPath(config.baseURL, config.url);
            Logger.debug(TAG + " config.baseURL :" + config.baseURL);
            Logger.debug(TAG + " config.url :" + config.url);

            url = buildURL(url, config.params, config.paramsSerializer)
            Logger.debug(TAG + " url :" + url);
            let client = config.client;
            if (client == undefined || client == null) {
               Logger.debug(TAG + " client is  null ");
               client = new HttpClient
                  .Builder()
                  .setConnectTimeout(5, TimeUnit.SECONDS)
                  .setReadTimeout(5, TimeUnit.SECONDS)
                  .setWriteTimeout(5, TimeUnit.SECONDS)
               let userDns = config.dns;
               if (userDns !== undefined || userDns !== null) {
                  Logger.debug(TAG + " userDns is not null");
                  client = client.dns(userDns);
               }
               let userEventListener = config.eventListener;
               if (userEventListener !== undefined || userEventListener !== null) {
                  Logger.debug(TAG + " userEventListener is not null");
                  client = client.addEventListener(userEventListener);
               }
               let proxy = config.proxy as AxiosProxyConfig;
               if (proxy) {
                  Logger.debug(TAG + " proxy is not null" + JSON.stringify(proxy));
                  client = client.setProxy(new Proxy(Type.HTTP, proxy.host, proxy.port));
               }
               let cache = config.cache;
               if (!!cache) {
                  Logger.debug(TAG + " cache is not null" + JSON.stringify(cache));
                  client = client.cache(cache);
               }
            }
            client = client.build();
            // 请求方式获取，post，get等
            let method = config.method;
            if (method === undefined || method === null) {
               method = 'GET';
            } else {
               method = method.toUpperCase();
            }
            Logger.debug(TAG + " method :" + method);
            let context = config.context;
            let ca: string = '';
            let adapterCA = config.caPath;
            if (adapterCA && context) {
               Logger.debug(TAG + " Get CA:" + adapterCA);
               ca = await getCA(adapterCA, context);
            } else {
               Logger.warn(TAG, "CA or context is null,CA:{},context:{}", ca, context);
            }
            let cert: string = '';
            if (config.clientCert && config.clientCert.certPath && context) {
               let adapterCertPath = config.clientCert.certPath;
               Logger.debug(TAG + " Get CERT:" + adapterCertPath);
               cert = await getCA(adapterCertPath, context);
            } else {
               Logger.warn(TAG, "certPath or context is null,cert:{},context:{}", cert, context);
            }
            let key: string = '';
            if (config.clientCert && config.clientCert.keyPath && context) {
               let adapterKeyPath = config.clientCert.keyPath;
               Logger.debug(TAG + " Get KEY:" + adapterKeyPath);
               key = await getCA(adapterKeyPath, context);
            } else {
               Logger.warn(TAG, "key or context is null,key:{},context:{}", key, context);
            }
            let password: string = '';
            if (config.clientCert && config.clientCert.keyPasswd) {
               password = config.clientCert.keyPasswd;
            } else {
               Logger.warn(TAG, "password is null");
            }

            let Builder = new Request.Builder()
               .url(url)
               .method(method);

            let data = config.data;
            if (data) {
               let requestBody: RequestBody = RequestBody.create(data)
               Builder.body(requestBody)
            }
            // 优先级排序
            let priority = config.priority;
            if (priority) {
               Logger.debug(TAG, "priority is not null");
               Builder.setPriority(priority);
            }
            // 证书相关
            if (ca.length >= 1) {
               Logger.debug(TAG, "CA is not null")
               Builder.ca([ca]);
            }
            if (key) {
               Logger.debug(TAG, "KEY is not null" + key);
               Builder.key(key);
            }
            if (cert) {
               Logger.debug(TAG, "CERT is not null" + cert);
               Builder.cert(cert);
            }
            if (password) {
               Logger.debug(TAG, "password is not null");
               Builder.password(password);
            }
            let headers = config.headers;
            if(headers){
               let headerMaps = new Map(Object.entries(headers))
               headerMaps.forEach((value, key) => {
                  Logger.debug(TAG + " headers key is :" + key + " headers value is :" + value);
                  Builder.addHeader(key, value);
               });
            }
            // 响应类型类型，默认为string类型
            let responseType = config.responseType;
            if (responseType === 'array_buffer' || responseType === 'ARRAY_BUFFER') {
               Logger.debug(TAG, "responseType is array_buffer");
               Builder.setHttpDataType(HttpDataType.ARRAY_BUFFER);
            } else if (responseType === 'object' || responseType === 'OBJECT') {
               Logger.debug(TAG, "responseType is object");
               Builder.setHttpDataType(HttpDataType.OBJECT);
            } else if(responseType === 'string' || responseType === 'STRING'){
               Logger.debug(TAG, "responseType is string");
               Builder.setHttpDataType(HttpDataType.STRING);
            } else {
               Builder.setHttpDataType(HttpDataType.OBJECT);
            }

            // Request方法构建
            let requestBuild: Request = Builder.build();
            let HttpCall = client.newCall(requestBuild);
            //证书锁定
            let sslCertificateManager: X509TrustManager = config.sslCertificateManager;
            if (sslCertificateManager) {
               Logger.debug(TAG, "sslCertificateManager is not null");
               HttpCall = HttpCall.checkCertificate(sslCertificateManager);
            }
            let pinnerByJson: Uint8Array;
            try {
               pinnerByJson = context.resourceManager.getRawFileContentSync('network_config.json');
            } catch (error) {
               let code = (error as BusinessError).code;
               let message = (error as BusinessError).message;
               Logger.error(TAG, `getRawFileContentSync failed, error code: ${code}, message: ${message}.`);
            }
            if (pinnerByJson) {
               let jsonString = pinnerByJson.reduce((prev, cur) => {
                  return prev + String.fromCharCode(cur);
               }, '')
               const jsonData = JSON.parse(jsonString)['network-security-config']['domain-config'][0];
               const hostnames = jsonData.domains.reduce((prev, cur) => {
                  prev.push(cur.name);
                  return prev;
               }, [])
               const pins = jsonData['pin-set'].pin.reduce((prev, cur) => {
                  prev.push(`${cur['digest-algorithm']}/${cur.digest}`)
                  return prev;
               }, [])
               if (hostnames.length !== 0 && pins.length !== 0) {
                  Logger.debug('HOSTNAMES:' + hostnames[0]);
                  Logger.debug('PINS:' + pins[0]);
                  let certPinBuild = new CertificatePinnerBuilder();
                  for (let i = 0; i < hostnames.length; i++) {
                     certPinBuild = certPinBuild.add(hostnames[i], pins[i]);
                  }
                  const certificatePinner = certPinBuild.build();
                  HttpCall = HttpCall.setCertificatePinner(certificatePinner);
               }
            }
            if(config.async){
               // 通过httpclient进行通信，并且将数据返回以axios的格式返回
               HttpCall.enqueue((result: Response) => {
                  Logger.debug(TAG + "success:" + JSON.stringify(JSON.parse(JSON.stringify(result)), null, 4));
                  if (!!result.cacheResponse && !!!result.networkResponse) {
                     result = result.cacheResponse;
                  }
                  let AxiosResponse: AxiosResponse<Response, null> = {
                     data: result.getBody() as any,
                     status: result.responseCode,
                     statusText: result.header,
                     headers: AxiosHeaders.from(JSON.parse(result.header)),
                     config
                  };
                  resolve(AxiosResponse);
               }, (err: Response) => {
                  Logger.warn(TAG + " failed:" + JSON.stringify(err));
                  reject(err);
               });
            }else{
               // 通过httpclient进行通信，并且将数据返回以axios的格式返回
               HttpCall.execute().then((result: Response) => {
                  Logger.debug(TAG + "success:" + JSON.stringify(JSON.parse(JSON.stringify(result)), null, 4));
                  if (!!result.cacheResponse && !!!result.networkResponse) {
                     result = result.cacheResponse;
                  }
                  let AxiosResponse: AxiosResponse<Response, null> = {
                     data: result.getBody() as any,
                     status: result.responseCode,
                     statusText: result.header,
                     headers: AxiosHeaders.from(JSON.parse(result.header)),
                     config
                  };
                  resolve(AxiosResponse);
               }, (err: Response) => {
                  Logger.warn(TAG + " failed:" + JSON.stringify(err));
                  reject(err);
               });
            }
         } catch (err) {
            Logger.error(TAG + " try catch error:" + JSON.stringify(err));
            reject(err);
         }
      }
   });

}



export {
   axios,
   AxiosHeaders,
   RawAxiosRequestHeaders,
   AxiosRequestHeaders,
   RawAxiosResponseHeaders,
   AxiosResponseHeaders,
   AxiosRequestTransformer,
   AxiosResponseTransformer,
   AxiosAdapter,
   AxiosBasicCredentials,
   HttpStatusCode,
   Method,
   ResponseType,
   responseEncoding,
   CertType,
   ClientCert,
   TransitionalOptions,
   GenericAbortSignal,
   FormDataVisitorHelpers,
   SerializerVisitor,
   SerializerOptions,
   ParamEncoder,
   CustomParamsSerializer,
   ParamsSerializerOptions,
   AxiosProgressEvent,
   RawAxiosRequestConfig,
   HeadersDefaults,
   AxiosDefaults,
   CreateAxiosDefaults,
   CanceledError,
   AxiosPromise,
   CancelStatic,
   Cancel,
   Canceler,
   CancelTokenStatic,
   CancelToken,
   CancelTokenSource,
   AxiosInterceptorOptions,
   AxiosInterceptorManager,
   AxiosInstance,
   GenericFormData,
   GenericHTMLFormElement,
   toFormData,
   formToJSON,
   isAxiosError,
   spread,
   isCancel,
   all,
   AxiosStatic,
   FormData,
   InternalAxiosRequestConfig,
   FormSerializerOptions,
   AxiosResponse,
   AxiosError,
   AxiosRequestConfig,
   AxiosProxyConfig,
   CAResUtil,
   Request,
   Response,
   X509TrustManager,
   BusinessError,
   HttpDataType,
   Logger,
   TimeUnit,
   Type,
   Proxy,
   CertificatePinnerBuilder,
   HttpClient,
   RequestBody,
   Cookie,
   CookieJar,
   CookieStore,
   CookieManager,
   Route,
   DnsResolve,
   gZipUtil,
   JsonCallback,
   StringCallback,
   ByteStringCallback,
   CookiePolicy,
   FileUpload,
   BinaryFileChunkUpload,
   FormEncoder,
   Mime,
   MultiPart,
   RealWebSocket,
   WebSocketListener,
   WebSocket,
   Factory,
   Dns,
   Interceptor,
   Chain,
   Credentials,
   Authenticator,
   NetAuthenticator,
   Challenge,
   Headers,
   HttpHeaders,
   Utils,
   RealTLSSocket,
   OkHostnameVerifier,
   StringUtil,
   TLSSocketListener,
   Cache,
   CacheControl,
   Protocol,
   EventListener,
   IOException,
   HttpCall,
};


async function getCA(adapterCA, context): Promise<string> {
   const value = await new Promise<string>((resolve,reject) => {
      new CAResUtil().getCA(adapterCA, context).then((value)=>{
          resolve(value);
       }).catch((err) => {
          reject(err)
       });
   })
   return value;
};

function buildFullPath(baseURL, requestedURL) {
   if (baseURL && !isAbsoluteURL(requestedURL)) {
      return combineURLs(baseURL, requestedURL);
   }
   return requestedURL;
};

function isAbsoluteURL(url) {
   // A URL is considered absolute if it begins with "<scheme>://" or "//" (protocol-relative URL).
   // RFC 3986 defines scheme name as a sequence of characters beginning with a letter and followed
   // by any combination of letters, digits, plus, period, or hyphen.
   return /^([a-z][a-z\d+\-.]*:)?\/\//i.test(url);
};

function combineURLs(baseURL, relativeURL) {
   return relativeURL
      ? baseURL.replace(/\/+$/, '') + '/' + relativeURL.replace(/^\/+/, '')
      : baseURL;
};