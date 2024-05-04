import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { convertXmlToObject } from '../main/ets/utils/XmlUtils';

export default function localUnitTest() {
  describe('localUnitTest',() => {
    beforeAll(() => {
    });
    beforeEach(() => {
    });
    afterEach(() => {
    });
    afterAll(() => {
    });
    it('testXml', 0, () => {

      let xml =
        '<?xml version="1.0" encoding="utf-8"?>' +
          '<note importance="high" logged="true">' +
          '    <title>Happy</title>' +
          '    <todo>Work</todo>' +
          '    <todo>Play</todo>' +
          '</note>';

      // const result = getEntityInXml()
      // console.log(JSON.stringify(result))
    });
  });
}