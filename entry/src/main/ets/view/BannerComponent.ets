import hilog from '@ohos.hilog'

@Preview
@Component
struct BannerView {
  build() {
    BannerLayout() {
      Image($r('app.media.ic_back'))
        .size({ width: $r('app.float.image_size'), height: $r('app.float.image_size') })
      Text('Banner title')
      Text(`Banner content, line1
Line 2
Line 3`)
    }
  }
}

@Component
struct BannerLayout {
  result: SizeResult = {
    width: 0,
    height: 0
  }

  onMeasureSize(selfLayoutInfo: GeometryInfo, children: Measurable[], constraint: ConstraintSizeOptions): SizeResult {

    let results = children.map((child) => {
      let childMeasure = child.measure({
        minWidth: constraint.minWidth,
        minHeight: constraint.minHeight,
        maxWidth: constraint.maxWidth,
        maxHeight: constraint.maxHeight
      });

      return childMeasure;
    });

    let w: number = results[0].width + Math.max(results[1].width, results[2].width);
    let h: number = results[2].height + Math.max(results[1].height, results[0].height);

    return { width: w, height: h };
  }

  onPlaceChildren(selfLayoutInfo: GeometryInfo, children: Layoutable[], constraint: ConstraintSizeOptions): void {
    let posX = 0;
    let posY = 0;
    children[0].layout({ x: posX, y: posY })
    posX += children[0].measureResult.width;
    children[1].layout({ x: posX, y: posY })
    posY += Math.max(children[0].measureResult.height, children[1].measureResult.height)
    children[2].layout({ x: posX, y: posY })
  }

  @Builder
  doNothingBuilder() {
  };

  @BuilderParam builder: () => void = this.doNothingBuilder;

  build() {
    this.builder();
  }
}

export default BannerView;