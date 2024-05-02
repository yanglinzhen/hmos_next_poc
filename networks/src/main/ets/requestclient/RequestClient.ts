import { axios, AxiosError, AxiosResponse } from '@ohos/axiosforhttpclient'

interface Cam10Body {
  title: string,
  description: string,
}

export class RequestClient {
  async loadBalance() {

    axios<string, AxiosResponse<Cam10Body>, null>({
      url: 'https://www.secure.hsbcnet.com/uims/portal/IDV_CAM10_AUTHENTICATION',
      params: {
        __nativeApp: true,
        __respType: "JSON"
      },
      method: 'get',
      responseType: 'string',
      transformResponse: (data: string) => {
        const removeScriptTag = (str: string) => str.trim().replace(/<script[^>]*>|<\/script>/g, '');
        const result = removeScriptTag(data)
        try {
          return JSON.parse(result) as Cam10Body
        } catch (e) {
          return {
            title: "title",
            body: 'body'
          }
        }
      },
    }).then((res: AxiosResponse<Cam10Body>) => {
      console.log(JSON.stringify(res))
    }).catch((err: AxiosError) => {
      console.log(JSON.stringify(err))
    })
  }
}