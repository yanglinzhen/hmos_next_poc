import { Entity } from '../viewmodel/Entity';
import { ZipFile } from '../viewmodel/ClientpackConfig'
import fs from '@ohos.file.fs';

export class FsUtils {

  createEntityPath(dirPath: string, zipFile: ZipFile): string {

    const filesDir: string = getContext().filesDir
    const path = dirPath.split('/').reduce((dir: string, part: string) => {
      const paths = `${dir}/${part}`
      if (!fs.accessSync(paths)) {
        fs.mkdirSync(paths);
      }
      return paths
    }, filesDir)

    const filePath = `${path}/${zipFile.mapping}.zip`
    try {
      fs.accessSync(filePath);
      fs.unlinkSync(filePath);
    } catch (err) {
    }

    return filePath
  }
}

