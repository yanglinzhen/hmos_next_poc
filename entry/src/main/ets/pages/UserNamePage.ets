import { AxiosError, AxiosResponse } from '@ohos/axiosforhttpclient';
import { LocalDataManager } from '@ohos/commonLib/Index';
import { LoadingSpinner } from '../view/LoadingSpinner'

@Preview
@Entry
@Component
struct UserNamePage {
  @State isLoading: boolean = false;
  @State usernameText: string = ''

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
      Flex({
        direction: FlexDirection.Column,
        justifyContent: FlexAlign.Center
      }) {

        Column() {
          Text('Input your username')

          TextInput({
            placeholder: 'Input your username:',
            text: this.usernameText
          })
            .backgroundColor($r('app.color.divider'))
            .margin({ top: '10%', bottom: '10%' })
            .enableKeyboardOnFocus(true)
            .onChange((text) => {
              this.usernameText = text
            })

          Button() {
            Text('Continue')
          }
          .onClick(() => {
            this.loadAction(() => {
              LocalDataManager.instance()
                .getPlApi()
                .userNameValidation(this.usernameText)
                .then((res: AxiosResponse<string>) => {
                  console.log(JSON.stringify(res))
                  this.loadAction()
                })
                .catch((err: AxiosError) => {
                  console.log(JSON.stringify(err))
                  this.loadAction()
                })
            })
          })
          .height('5%')
          .width('100%')
        }
        .padding({ left: '10%', right: '10%' })
      }
      .width('100%')
      .height('100%')

      if (this.isLoading)
        LoadingSpinner()

    }.width('100%')
    .height('100%')
  }

  onPageShow(): void {
  }
}

