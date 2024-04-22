import { CommonConstants } from '../constants/CommonConstants';
import { hilog } from '@kit.PerformanceAnalysisKit';
import http from '@ohos.net.http';
import BannerView from './BannerComponent';


/**
 * Logo and version component on top page.
 */
@Component
export struct LogoAndVersionComponent {

  url: string = 'https://www.bing.cn';
  httpRequest = http.createHttp();

  build() {
    Column() {
      BannerView()
      // TextInput({ text: this.url })
      //   .type(InputType.Normal)
      //   .width('100%')
      //   .backgroundColor(Color.White)
      //   .caretColor(Color.Orange)
      //   .onChange((newText: string) => {
      //     this.url = newText;
      //     // AppStorage.set('url', urlName);
      //   })
      // Button() {
      //   Text('Send Request')
      // }.onClick((e) => {
      //   let promise = this.httpRequest.request(this.url,
      //     {
      //       method: http.RequestMethod.POST,
      //       connectTimeout: 60000,
      //       readTimeout: 60000,
      //       header: {
      //         'Content-Type': 'application/json'
      //       }
      //     });
      //   promise.then((resp) => {
      //     if (resp.responseCode == http.ResponseCode.OK) {
      //       hilog.info(0x0000, 'marco', '%{public}s', resp.result.toString());
      //     } else {
      //       hilog.info(0x0000, 'marco', '%{public}s', resp.responseCode.toString());
      //     }
      //   })
      //     .catch((err: string) => {
      //       hilog.error(0x0000, 'marco', '%{public}s', err);
      //     });
      // });

      Row() {
        ForEach([
          'Text1',
          'Text2',
          'Text3',
        ],
          (item: string, index) => {
            Text(item)
              .width(80)
              .height(40)
              .backgroundColor(Color.Orange)
              .textAlign(TextAlign.Center)
              .borderWidth(3)
              .borderStyle(BorderStyle.Solid)
              .borderColor(Color.Red)
          })
      }
      .width(280)
      .height(80)
      .backgroundColor(Color.Blue)
      .justifyContent(FlexAlign.Center)
      .align(Alignment.BottomEnd)
      .alignItems(VerticalAlign.Top)
    }
    .width(300)
    .backgroundColor(Color.Gray)
    .height(200)
    .alignItems(HorizontalAlign.Start)
  }
}