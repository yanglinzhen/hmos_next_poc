@Component
export struct ButtonPositive {
  @Prop text: string = 'button'
  // @Prop onClickEvent: (onClickEvent: ClickEvent) => void
  build() {
    Button(
      {
        buttonStyle: ButtonStyleMode.TEXTUAL,
        type: ButtonType.Normal
      },
    ) {
      Text(this.text)
        .textAlign(TextAlign.Center)
        .fontColor($r("app.color.page_background"))
        .fontSize("20fp")
        .width("100%")
        .padding("12, 12, 12, 12vp")
    }
    // .onClick(this.onClickEvent)
    .align(Alignment.Center)
    .borderRadius(0)
    .backgroundColor($r("app.color.background_button_positive"))
  }
}