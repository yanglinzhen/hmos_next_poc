import base64 from 'base64-js';
import url from '@ohos.url'

const stringToUint8Array = (str: string): Uint8Array => {
  let arr: Array<number> = [];
  for (let i = 0, j = str.length; i < j; i++) {
    arr.push(str.charCodeAt(i));
  }
  return new Uint8Array(arr);
}

export interface UrlAndAuth {
  url: string,
  header: string | undefined
}

export function getUrlPath(urlStr: string): string {
  const urlObj = url.URL.parseURL(urlStr)
  return urlObj.pathname
}

export function getUrlAndAuthHeader(urlStr: string): UrlAndAuth {

  const urlObj = url.URL.parseURL(urlStr)
  const username = urlObj.username
  const password = urlObj.password

  let header: string | undefined
  if (urlObj.username && urlObj.password) {
    const base64Credentials = base64.fromByteArray(stringToUint8Array(`${username}:${password}`))
    header = `Basic ${base64Credentials}`
  }

  return {
    url: urlObj.origin,
    header: header
  } as UrlAndAuth
}