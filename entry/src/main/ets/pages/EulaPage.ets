import webView from '@ohos.web.webview';
import http from '@ohos.net.http';
import httpGet from '../common/utils/HttpUtil';
import promptAction from '@ohos.promptAction'
import { AxiosResponse } from '@ohos/axiosforhttpclient'

import { getEntityList, Entity } from '@ohos/commonLib/src/main/ets/viewmodel/Entity'
import { ListPickerDialog } from '../components/ListPickerDialog'
import { LocalDataManager } from '@ohos/commonLib/Index';
import { hilog } from '@kit.PerformanceAnalysisKit';
import router from '@ohos.router'
import { LoadingSpinner } from '../view/LoadingSpinner'

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
        this.loadAction(async () => {
          await this.selectEntity(url)
          router.pushUrl({
            url: 'pages/UserNamePage'
          })
        })
      }
    })
  })

  async selectEntity(url: string) {
    const entity: Entity | undefined = this.entityList?.find((entity) => entity.configUrl === url)
    if (entity) {
      await LocalDataManager.instance().selectedEntity(entity)
    }
  }

  loadAction(action: (() => void) | undefined = undefined, loading: boolean = true) {

    if (!action) {
      this.isLoading = false
      return
    }
    this.isLoading = loading
    action()
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
            .width('100%')
          // Button() {
          //   Text('Request')
          // }
          // .onClick(() => {
          //   this.loadAction(() => {
          //     new PlApi().loadBalance()
          //       .then((result: AxiosResponse<LoadBalanceResponse>) => {
          //         this.loadAction()
          //       })
          //       .catch((error: Error) => {
          //         this.loadAction()
          //       })
          //   })
          // })
          // .height('5%')
          // .width('100%')

          Button() {
            Text('Accept Eula')
          }
          .onClick(() => {
            this.loadAction(() => {
              getEntityList()
                .then((result: AxiosResponse<Entity[]>) => {
                  if (result.data.length > 1) {
                    this.entityList = result.data
                    this.dialogController.open()
                  }
                  this.loadAction()
                })
                .catch((error: Error) => {
                  hilog.info(0x0088, 'EulaPage', '%{public}s', JSON.stringify(error));
                })
            })
          })
          .flexShrink(1)
          .height('36vp')
          .width('100%')
        }
      }
      .height('100%')
      .width('100%')

      if (this.isLoading)
        LoadingSpinner()

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

