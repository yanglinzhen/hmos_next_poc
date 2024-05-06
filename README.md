Generate SHA-512 hex string for Cert:
```bash
openssl x509 -outform der -in <inputfile.crt> -out <outputfile.der>
openssl dgst -sha512 -hex <inputfile.der> >> <outputfile.txt>
```

Generate SHA-256 fingerprint for Cert:
```bash
openssl x509 -in <cert.crt> -noout -sha256 -fingerprint
```


Harmony POC checklist

| Status    | Functionality                            | Lib/Kit          | Pros                                  | Cons                                                          |
|-----------|------------------------------------------|------------------|---------------------------------------|---------------------------------------------------------------|
| Checked   | Simple http requests                     | Axios/HttpClient |                                       | SSL Pinning failed, cannot detect redirect, few logs to debug |
| Checked   | File system access                       | @ohos.file.fs    |                                       |                                                               |
| Unchecked | Cookie synchronization                   |                  |                                       |                                                               |
| Checked   | XML/JSON convertion                      | @ohos/xml_js     |                                       |                                                               |
| Checked   | Simple animation                         | ArkUI framework  |                                       |                                                               |
| Checked   | UI layout/Styling                        | ArkUI framework  |  |                                                               |
| Checked   | Simple dialog and data status management | ArkUI framework  |                                       |                                                               |
| Checked   | HTML rendering/Webview                   | ArkUI framework  |                                       |                                                               |
| Checked   | Concurrency                              | Promise API      |                                       |                                                               |
| Unchecked | Unit test suit                           | ArkUI framework  |                                       |                                                               |
| Checked   | Build speed                              | NodeJs/ohpm      | POC project build within 1 min        |                                                               |
| Unchecked | App performance on large project         |       |                                       |                                                               |
| Unchecked | Fingerprint sensor                       |       |                                       |                                                               |
| Unchecked | Camera                                   |       |                                       |                                                               |
| Unchecked | Location service                         |       |                                       |                                                               |
| Unchecked | Wifi/BT/Device information               |       |                                       |                                                               |