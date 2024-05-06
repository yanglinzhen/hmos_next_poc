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
import { PlApi, UrlConfig } from '@ohos/networks/src/main/ets/requestclient/api/PlApi';
import { getUrlAndAuthHeader, getUrlPath } from '@ohos/networks/src/main/ets/requestclient/api/UrlUtils'

export class LocalDataManager {
  private static localDataManager: LocalDataManager;
  private selectedConfig?: ClientpackConfig

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
    hilog.info(0x0000, 'LocalDataManager', 'start download %{public}s', zipFile.zipurl)
    const filePath = new FsUtils().createEntityPath(dirPath, zipFile)
    const result: string = (await new CdnApi().downloadFile(zipFile.zipurl, filePath, (e: AxiosProgressEvent) => {
    }) as AxiosResponse<string>).data
    return result
  }

  async selectedEntity(entity: Entity) {
    const dirPath = `${entity.localised.name}/${entity.id}`
    const config = (await new CdnApi().getConfig<ClientpackConfig>(entity.configUrl, (data: string) => {
      return ClientpackConfig.convertConfigFromResponse(data) as ClientpackConfig
    }) as AxiosResponse<ClientpackConfig>).data

    this.selectedConfig = config
    this.selectedConfig.zipFiles().map((zipFile: ZipFile): Promise<string> => {
      return this.downloadZipFile(dirPath, zipFile)
    })
  }

  private getPlApiConfig(): UrlConfig {
    const urlAndAuth = getUrlAndAuthHeader(this.selectedConfig?.host() || '')
    return {
      baseUrl: urlAndAuth.url,
      loadBalancePath: '/uims/portal/IDV_CAM10_AUTHENTICATION'
    }
  }

  private plApi?: PlApi

  getPlApi(): PlApi {
    if (!this.plApi) {
      this.plApi = new PlApi(this.getPlApiConfig())
    }
    return this.plApi
  }
}