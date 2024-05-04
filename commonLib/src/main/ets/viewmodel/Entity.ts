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

export function getEntityList(
  xmlString: string
) {
  const xml = convertXmlToObject(xmlString)
  return convertXmlToEntityList(xml)
}

export function convertXmlToEntityList(
  xml: object
): Entity[] {
  const entities: Entity[] = (xml['entityList']['entity'] as object[]).map((entityObj: object) => {
    const entity: Entity = {
      id: entityObj['_attributes']['id'],
      supportedDevices: (entityObj['supportedDevices']['device'] as object[]).map((item) => {
        return item['_attributes']['name']
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