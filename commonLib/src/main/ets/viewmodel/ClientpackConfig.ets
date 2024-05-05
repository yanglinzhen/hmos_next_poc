export class ClientpackConfig {
  readonly configObject?: object

  constructor(configObject: object) {
    this.configObject = configObject
  }

  host(): string {
    return this.configObject?.['host'] as string
  }

  zipFiles(): ZipFile[] {
    return (this.configObject?.['webresources'][0]['HSBCnet.1.5.14'][0]['globaltemplate'] as object[])?.map((item: object) => {
      return {
        zipurl: item['zipurl'] as string,
        hashcode: item['hashcode'] as string,
        mapping: item['mapping'][0] as string,
        size: item['size'] as number
      } as ZipFile
    })
  }

  static convertConfigFromResponse(data: string) {
    return new ClientpackConfig(JSON.parse(data))
  }
}

export interface ZipFile {
  zipurl: string,
  hashcode: string,
  mapping: string,
  size: number
}