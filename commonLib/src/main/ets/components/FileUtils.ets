export class FileUtils {

  async getFileObject(path: string, context: Context): Promise<object | string> {
    if (!path) {
      return "path is error";
    }
    const self = this
    return await new Promise<object>((resolve, reject) => {
      context.resourceManager.getRawFileContent(path, (err: Error, value) => {
        if (err) {
          throw err
        }
        try {
          const jsonString = self.parsingRawFile(value)
          const result: object = JSON.parse(jsonString)
          resolve(result)
        } catch (e) {
          reject(e)
        }
      })
    })
  }

  private parsingRawFile(rawFile: Uint8Array): string {
    let fileContent: string = "";
    for (let index = 0, len = rawFile.length; index < len; index++) {
      const todo = rawFile[index];
      const item = String.fromCharCode(todo);
      fileContent += item + "";
    }
    return fileContent;
  }

}