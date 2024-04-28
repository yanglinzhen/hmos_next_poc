import axios, { AxiosError, AxiosResponse } from '@ohos/axios'
import uri from '@ohos.uri';
import url from '@ohos.url';

interface Cam10Body {
  title: string,
  description: string,
}

export class RequestClient {
  loadBalance() {
    let instance = axios.create({
      baseURL: 'https://www.secure.hsbcnet.com',
      timeout: 30000,
    })
    instance.request<string, AxiosResponse<Cam10Body>, null>(
      {
        url: instance.defaults.baseURL + '/uims/portal/IDV_CAM10_AUTHENTICATION',
        params: {
          __nativeApp: true,
          __respType: 'JSON',
        },
        transformResponse: [(data: string) => {
          const removeScriptTag = (str: string) => str.trim().replace(/<script[^>]*>|<\/script>/g, '');
          const result = removeScriptTag(data)

          try {
            return JSON.parse(result)
          } catch (e) {
            return {
              title: "title",
              body: 'body'
            }
          }
        }]
      }
    ).then((result: AxiosResponse<Cam10Body>) => {
      console.info(JSON.stringify(result));

      console.log('payload: ' + JSON.stringify(result.data))

      let host = url.URL.parseURL(result.headers['location']).host

      console.log('host: ' + JSON.stringify(host))
    }).catch((error: AxiosError) => {
      console.info(JSON.stringify(error));
    })
  }

  // "host": "https://www.secure.hsbcnet.com",
  // loadBalance() {
  //   let instance = axios.create({
  //     baseURL: 'https://www.sde3-c.uk.hsbcnet.com',
  //     // baseURL: 'https://www.secure.hsbcnet.com',
  //     timeout: 30000,
  //   })
  //   instance.request<string, AxiosResponse<string>, null>(
  //     {
  //       url: 'https://www.baidu.com',
  //       params: {
  //         __nativeApp: true,
  //         __respType: 'json',
  //       }
  //     }
  //   ).then((result: AxiosResponse) => {
  //     console.log(JSON.stringify(result))
  //   })
  //     .catch((error: AxiosError) => {
  //       console.log(JSON.stringify(error))
  //     })
  //   //   .then((res: AxiosResponse) => {
  //   //
  //   // })
  //   //   .catch((err: AxiosError) => {
  //   //
  //   //   })
  // }

}