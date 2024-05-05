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
import { Entity } from '../viewmodel/Entity';
import url from '@ohos.url';
import { FsUtils } from './FsUtils';
import { CdnApi } from '@ohos/networks/src/main/ets/requestclient/api/CdnApi';
import { AxiosError, AxiosProgressEvent, AxiosResponse } from '@ohos/networks/Index';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { ClientpackConfig, ZipFile } from '../viewmodel/ClientpackConfig'

export class LocalDataManager {
  private static localDataManager: LocalDataManager;

  private constructor() {
    // this.initDefaultShopCartData();
    // this.initDefaultOrderData();
  }

  static instance() {
    if (!LocalDataManager.localDataManager) {
      LocalDataManager.localDataManager = new LocalDataManager();
    }
    return LocalDataManager.localDataManager;
  }

  async downloadZipFile(dirPath: string, zipFile: ZipFile) {
    const filePath = new FsUtils().createEntityPath(dirPath, zipFile)
    new CdnApi().downloadFile(zipFile.zipurl, filePath, (e: AxiosProgressEvent) => {
        hilog.info(0x0000, 'LocalDataManager', '%{public}s', JSON.stringify(e))
      }).then((res: AxiosResponse<string>) => {
        hilog.info(0x0000, 'LocalDataManager', 'download %{public}s finished', zipFile.zipurl)
      })
        .catch((err: AxiosError) => {
          hilog.info(0x0000, 'LocalDataManager', '%{public}s', JSON.stringify(err))
        })
  }

  async selectedEntity(entity: Entity) {
    const entityUrl = url.URL.parseURL(entity.configUrl)
    const dirPath = entity.localised.name + '/' + entity.id
    await new CdnApi().getConfig<ClientpackConfig>(entity.configUrl, (data: string) => {
      return ClientpackConfig.convertConfigFromResponse(data) as ClientpackConfig
    }).then((res: AxiosResponse<ClientpackConfig>) => {
      (res.data as ClientpackConfig).zipFiles().map((zipFile: ZipFile) => {
        this.downloadZipFile(dirPath, zipFile)
      })
    })
      .catch((err: AxiosError) => {
        hilog.info(0x0000, 'LocalDataManager', '%{public}s', JSON.stringify(err))
      })

    //
  }
}