@Preview
@Component
export struct LoadingSpinner {
  build() {
    Stack() {
      // Column() {
      // }
      // .width('100%')
      // .height('100%')

      // .mask(new Rect({
      //   width: '100%',
      //   height: '100%'
      // }).fill(Color.Gray))

      Image($r('app.media.startIcon'))
        .width($r('app.float.app_info_image_height'))
        .height($r('app.float.app_info_image_height'))
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_half_gray'))
  }
}