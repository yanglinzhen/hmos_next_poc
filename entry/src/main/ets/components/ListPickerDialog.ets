/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { Entity } from '@ohos/commonLib/Index'

export interface DialogStruct {
  title: string,
  url: string,
}

@CustomDialog
export struct ListPickerDialog {
  controller?: CustomDialogController
  @Link data: Entity[]
  private onSelectItem?: (url: string) => void;

  aboutToAppear() {
  }

  mapData() {
    return this.data.map((entity: Entity) => {
      return {
        title: entity.localised.name,
        url: entity.configUrl
      } as DialogStruct
    }) as DialogStruct[]
  }

  build() {
    GridRow({
      columns: {
        sm: 4,
        md: 6,
        lg: 8
      }
    }) {
      GridCol({
        span: {
          sm: 4,
          md: 6,
          lg: 8
        },
        offset: 1
      }) {
        Scroll() {
          Column() {
            ForEach(this.mapData(), (item: DialogStruct) => {
              Column() {
                Text(item.title)
                  .fontSize('14fp')
                  .fontColor("#99000000")
              }.onClick(() => {
                if (this.onSelectItem) {
                  this.onSelectItem(item.url)
                }
                this.controller?.close()
              })
            })
          }
        }
      }
    }
  }
}