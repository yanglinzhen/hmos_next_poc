import { CdnApi } from '@ohos/networks/src/main/ets/requestclient/api/CdnApi';
import { AxiosResponse } from '@ohos/networks/src/main/ets/requestclient/HttpClientAdapter';
import { convertXmlToObject } from '../utils/XmlUtils'

export interface Entity {
  id: string;
  supportedDevices: string[];
  supportedSSLPinning: boolean;
  localised: Localised;
  configUrl: string;
}

export interface Localised {
  locale: string;
  name: string;
  shortname: string;
  default: boolean;
}

export async function getEntityList(): Promise<AxiosResponse<Entity[]>> {
  const transformer = (data: string) => {
    const entityList = xmlStringToEntityList(data)
    try {
      return entityList
    } catch (e) {
      throw e as Error
    }
  }
  return new CdnApi().fetchEntityList<Entity[]>(transformer)
}

function xmlStringToEntityList(
  xmlString: string
) {
  const xml = convertXmlToObject(xmlString)
  return convertXmlToEntityList(xml)
}

function convertXmlToEntityList(
  xml: object
): Entity[] {
  const entities: Entity[] = (xml['entityList']['entity'] as object[]).map((entityObj: object) => {
    const entity: Entity = {
      id: entityObj['_attributes']['id'],
      supportedDevices: (entityObj['supportedDevices']['device'] as object[]).map((item) => {
        return item['_attributes']['name'] as string
      }),
      supportedSSLPinning: (entityObj['supportedSSLPinning']['enable']['_text'] == 'true') as boolean,
      localised: {
        locale: entityObj['localised']['_attributes']['locale'],
        name: entityObj['localised']['_attributes']['name'],
        shortname: entityObj['localised']['_attributes']['shortname'],
        default: (entityObj['localised']['_attributes']['default'] == 'true') as boolean
      },
      configUrl: entityObj['configurl']['_text']
    }
    return entity
  })
  return entities
}

export async function downloadEntityFile() {

}