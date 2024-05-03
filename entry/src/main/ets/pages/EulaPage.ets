import webView from '@ohos.web.webview';
import http from '@ohos.net.http';
import httpGet from '../common/utils/HttpUtil';
import promptAction from '@ohos.promptAction'
import { RequestClient } from '@ohos/networks/Index';
import { ChecksumUtils } from '@ohos/networks/Index';
import { FileUtils } from '@ohos/commonLib/Index';

@Entry
@Component
struct EulaPage {
  controller: webView.WebviewController = new webView.WebviewController();
  @State message: string = 'Eula page';
  @State webSrc: string = 'https://www.cn.secure.hsbcnet.com/uims/static-dl/public/mobile/features/cmb_mobile_cp/Production/content/China/eula_11/zh_zh/eula.html?page=read&langToggle=true&headerToggle=true&backToggle=false'
  @State isLoading: boolean = true;

  build() {
    Stack() {
      Column() {
        Flex({
          direction: FlexDirection.Column
        }) {
          Web({ src: this.webSrc, controller: this.controller })
            .onProgressChange((event) => {
              if (event?.newProgress == 100) {
                this.isLoading = false
              }
            })
            .height('90%')
            .width('100%')
          Button() {
            Text('Request')
          }
          .onClick(() => {

            // new FileUtils().getFileObject('checksum.json', getContext()).then((result) => {
            //   console.log(JSON.stringify(result['root']));
            // }).catch((error: Error) => {
            //   console.log(JSON.stringify(error));
            // })

            new RequestClient().loadBalance()
          })
          .height('5%')
          .width('100%')

          Button() {
            Text('Request CDN')
          }
          .onClick(() => {
            new RequestClient().getChecksums()
          })
          .height('5%')
          .width('100%')
        }
      }
      .height('100%')
      .width('100%')

      if (this.isLoading)
        LoadingProgress()

    }.width('100%')
    .height('100%')
  }

  onPageShow(): void {
    this.onRequest()
  }

  async onRequest() {
    try {
      let result = await httpGet(this.webSrc);
      if (result && result.responseCode === http.ResponseCode.OK) {
        this.controller.clearHistory();
        this.controller.loadUrl(this.webSrc);
      }
    } catch (error) {
      promptAction.showToast({
        message: $r('app.string.http_response_error')
      })
    }
  }
}