import convert from '@ohos/xml_js'

export function convertXmlToObject(
  xml: string
): object {

  let options = {
    compact: true,
    instructionNameFn: (val: string, elementName: string) => {
      return val;
    },
    elementNameFn: (val: string, elementName: string) => {
      return val;
    },
    attributeNameFn: (val: string, elementName: string) => {
      return val;
    },
    attributeValueFn: (val: string, elementName: string) => {
      return val;
    }
  };

  return convert.xml2js(xml, options)
}