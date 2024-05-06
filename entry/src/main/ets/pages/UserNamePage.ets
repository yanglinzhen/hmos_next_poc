import { AxiosError, AxiosResponse } from '@ohos/axiosforhttpclient';
import { LocalDataManager } from '@ohos/commonLib/Index';
import { LoadingSpinner } from '../view/LoadingSpinner'
import { ButtonPositive } from '../components/ButtonPositive'

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

          ButtonPositive(
            {
              text: 'Continue',
              // onClickEvent: () => {
              //   this.loadAction(() => {
              //     LocalDataManager.instance()
              //       .getPlApi()
              //       .userNameValidation(this.usernameText)
              //       .then((res: AxiosResponse<string>) => {
              //         console.log(JSON.stringify(res))
              //         this.loadAction()
              //       })
              //       .catch((err: AxiosError) => {
              //         console.log(JSON.stringify(err))
              //         this.loadAction()
              //       })
              //   })
              // }
            }
          )
            .width('100%')
            .padding({ left: '5vp', right: '5vp' })
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

