import { axios, AxiosError, AxiosResponse } from '@ohos/axiosforhttpclient'

interface Cam10Body {
  title: string,
  description: string,
}

interface PLRequestBody {
  __nativeApp: boolean,
  __respType: string
}

export class RequestClient {
  async loadBalance() {
    const params: PLRequestBody = {
      __nativeApp: true,
      __respType: "JSON"
    }
    axios.create({
      baseURL: 'https://www.secure.hsbcnet.com',
      timeout: 30000,
    })
      .get<string, AxiosResponse<Cam10Body>, PLRequestBody>('/uims/portal/IDV_CAM10_AUTHENTICATION',
        {
          params: params,
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