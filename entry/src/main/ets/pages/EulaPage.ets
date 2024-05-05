import webView from '@ohos.web.webview';
import http from '@ohos.net.http';
import httpGet from '../common/utils/HttpUtil';
import promptAction from '@ohos.promptAction'
import { axios, AxiosResponse, Logger, StringUtil, X509TrustManager } from '@ohos/axiosforhttpclient'
import { LoadBalanceResponse, PlApi } from '@ohos/networks/src/main/ets/requestclient/api/PlApi';

import { getEntityList, Entity } from '@ohos/commonLib/src/main/ets/viewmodel/Entity'
import { ListPickerDialog, DialogStruct } from '../components/ListPickerDialog'
import { LocalDataManager } from '@ohos/commonLib/Index';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct EulaPage {
  controller: webView.WebviewController = new webView.WebviewController();
  @State message: string = 'Eula page';
  @State webSrc: string = 'https://www.cn.secure.hsbcnet.com/uims/static-dl/public/mobile/features/cmb_mobile_cp/Production/content/China/eula_11/zh_zh/eula.html?page=read&langToggle=true&headerToggle=true&backToggle=false'
  @State isLoading: boolean = true;
  @State entityList?: Entity[] = undefined
  dialogController: CustomDialogController = new CustomDialogController({
    builder: ListPickerDialog({
      data: $entityList,
      onSelectItem: (url: string) => {
        this.selectEntity(url)
      }
    })
  })

  async selectEntity(url: string) {
    const entity: Entity | undefined = this.entityList?.find((entity) => entity.configUrl === url)
    if (entity) {
      await LocalDataManager.instance().selectedEntity(entity)
    }
  }

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

            new PlApi().loadBalance()
              .then((result: AxiosResponse<LoadBalanceResponse>) => {
                hilog.info(0x0088, 'EulaPage', '%{public}s', JSON.stringify(result.data))
              })
              .catch((error: Error) => {
                hilog.info(0x0088, 'EulaPage', '%{public}s', JSON.stringify(error));
              })
          })
          .height('5%')
          .width('100%')

          Button() {
            Text('Request Entity')
          }
          .onClick(async () => {

            getEntityList()
              .then((result: AxiosResponse<Entity[]>) => {
                if (result.data.length > 1) {
                  this.entityList = result.data
                  this.dialogController.open()
                }
              })
              .catch((error: Error) => {
                hilog.info(0x0088, 'EulaPage', '%{public}s', JSON.stringify(error));
              })
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

