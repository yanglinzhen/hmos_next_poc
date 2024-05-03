import { X509TrustManager } from '@ohos/httpclient';
import certFramework from '@ohos.security.cert';

export class SslCertificate implements X509TrustManager {

  checkClientTrusted(data: certFramework.X509Cert): void {

    console.log('checkClientTrusted' + JSON.stringify(data))
  }

  checkServerTrusted(X509Certificate: certFramework.X509Cert): void {
    console.log('checkServerTrusted' + JSON.stringify(X509Certificate))

  }
}