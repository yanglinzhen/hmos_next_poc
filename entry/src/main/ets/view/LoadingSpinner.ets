import curves from '@ohos.curves';

@Preview
@Component
export struct LoadingSpinner {
  @State spinnerAngle: number = 0

  rotateFrame = () => {
    this.spinnerAngle %= 360
    animateTo(
      {
        duration: 1000,
        curve: Curve.Linear,
        playMode: PlayMode.Normal,
        onFinish: this.rotateFrame,
      },
      () => {
        this.spinnerAngle += 240
      })
  }

  build() {
    Stack() {
      Image($r('app.media.startIcon'))
        .width($r('app.float.app_info_image_height'))
        .height($r('app.float.app_info_image_height'))
        .rotate({ angle: this.spinnerAngle })
        .onAppear(() => {
          this.rotateFrame()
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_half_gray'))
  }
}