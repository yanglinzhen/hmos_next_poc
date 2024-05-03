Generate SHA-512 hex string for Cert:
```bash
openssl x509 -outform der -in <inputfile.crt> -out <outputfile.der>
openssl dgst -sha512 -hex <inputfile.der> >> <outputfile.txt>
```

Generate SHA-256 fingerprint for Cert:
```bash
openssl x509 -in <cert.crt> -noout -sha256 -fingerprint
```