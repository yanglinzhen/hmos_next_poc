import { Dns, HttpClient, Logger, Request, Response, StringUtil, TimeUnit, Utils,
  X509TrustManager } from '@ohos/httpclient';
import connection from '@ohos.net.connection';
import certFramework from '@ohos.security.cert';

export class SslCertificate implements X509TrustManager {

  checkClientTrusted(data: certFramework.X509Cert): void {

  }

  checkServerTrusted(X509Certificate: certFramework.X509Cert): void {
    let currentDayTime = StringUtil.getCurrentDayTime();
    let date = currentDayTime + 'Z';
    try {
      X509Certificate.checkValidityWithDate(date); // 检查X509证书有效期
      console.error('checkValidityWithDate success');
    } catch (error) {
      console.error('checkValidityWithDate failed, errCode: ' + error.code + ', errMsg: ' + error.message);
      error.message = 'checkValidityWithDate failed, errCode: ' + error.code + ', errMsg: ' + error.message;
      throw new Error(error);
    }
  }
}