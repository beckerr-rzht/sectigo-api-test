# Sectigo API Test

This BASH script tests the Secogo API for generating an S/MIME user certificate.
It checks if the order of the email addresses in the certificate is in the intended order.

## Install

* Dependencies:
```bash
apt install -y git curl gettext-base jo jq
```

* Clone:
```
git clone https://github.com/beckerr-rzht/sectigo-api-test.git
cd sectigo-api-test
```

## Configure

* Copy config
```bash
cp conf/do.cnf.sample conf/do.cnf
```

* `vi con/do.cnf` and fill in admins username and passwords.

## Test

* Create Key
```bash
./do.sh create-key
```
Output:
```text
* Creating key:
  ./data/rfttest@hochschule-trier.de.key

Generating RSA private key, 4096 bit long modulus (2 primes)
...............................................................................................................++++
...................................................++++
e is 65537 (0x010001)
```

* Create CSR
```bash
./do.sh create-csr
```
Output:
```
* Creating request:
  ./data/rfttest@hochschule-trier.de.csr

You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) []:DE
Organization Name []:Hochschule Trier - Trier University of Applied Sciences
City []:Trier
Postal Code []:54293
Street []:Schneidershof
Common Name []:Dr. Juergen Test
Email Address []:rfttest@hochschule-trier.de

* Result: (emails in reverse order)
        Subject: C = DE, O = Hochschule Trier - Trier University of Applied Sciences, L = Trier, postalCode = 54293, street = Schneidershof, CN = Dr. Juergen Test, emailAddress = rftt
est@hochschule-trier.de
        Subject Public Key Info:
            X509v3 Subject Alternative Name: 
                email:rfttest@fh-trier.de, email:rfttest@rz.fh-trier.de J.TEST@rz.fh-trier.de rfttest@rz.hochschule-trier.de rfttest@hochschule-trier.de
```

* Test API
```bash
 ./do.sh test-api
```
Output:
```
* E-Mail:
  rfttest@hochschule-trier.de

* E-Mails:
  rfttest@hochschule-trier.de rfttest@rz.hochschule-trier.de J.TEST@rz.fh-trier.de rfttest@rz.fh-trier.de rfttest@fh-trier.de

* E-Mail from request:
  rfttest@hochschule-trier.de

* E-Mails from request:
  rfttest@fh-trier.de rfttest@rz.fh-trier.de J.TEST@rz.fh-trier.de rfttest@rz.hochschule-trier.de rfttest@hochschule-trier.de (wanted list in reverse order)

* Cert-Type:
  16307 = GÉANT Personal Certificate

* Request:
{
  "orgId": 28420,
  "firstName": "Juergen",
  "middleName": "",
  "lastName": "Test",
  "commonName": "Dr. Juergen Test",
  "csr": "-----BEGIN CERTIFICATE REQUEST-----\nMIIFtDCCA5wCAQAwgc4xCzAJBgNVBAYTAkRFMUAwPgYDVQQKDDdIb2Noc2NodWxl\nIFRyaWVyIC0gVHJpZXIgVW5pdmVyc2l0eSBvZiBBcHBsaWVkIFNjaWVuY2VzMQ4w\nDAYDVQQHDAVUcmllcjEOMAwGA1UEEQwFNTQyOTMxFjAUBgNVBAkMDVNjaG5laWRl\ncnNob2YxGTAXBgNVBAMMEERyLiBKdWVyZ2VuIFRlc3QxKjAoBgkqhkiG9w0BCQEW\nG3JmdHRlc3RAaG9jaHNjaHVsZS10cmllci5kZTCCAiIwDQYJKoZIhvcNAQEBBQAD\nggIPADCCAgoCggIBAMQMI439s/UPqvWtWkPDj0XS9SVn3kkRcewVSqoR5hSPmuHn\nzcYxk0FJVB0erIsL2OSaWTtIoMMBstZa9PGWG6vYe8vVF4LxyXoIXmGQVaRCmIgY\nUtZ8bk7o/aoqnJV9zVPedGlWVUTthORVXbzyLPwE2Tjp6HUvF98LBOBaFazl8wXE\nlZ8fGfAYuduA8ZCo/tNN2+7NwnRFnpoNUg6S40nxwM7ZWRfOdFtginF1WlJdieEZ\nogxuYxKb8CQAopog13OtE/XA7+Igdhf50VxCJG84LwRB4GCutdLpk68aYrCyb3sP\nhi4oqLPCCfMLchXaNXjGEs9dMfVyhbIslM5anxYHMqEboyUHwT79VNx+P5HTqMM8\nxcFm+MPzKudlqY8L1NGkEkm9UerNw+QZzvv/Av5BKypTqMjdcB7M34F6g07nFLxu\nOUVzSjOkFwh7HYmPnAL3qTaqeNmDCk3xwtkNZ/oThhSFT5s1a0PX0SHDWXJ1US9v\niGsmYKw/0Pa0JHRKgZF7Q4RPLkUsZsy09lovjTnr5V0lKa/NbydDWaLMwJBQBQY7\n5lHrXtJbsaPqorXfFsEX3Tn1ioUo54evq7D/AFHM1yBExzYuGOFjK1z7Sn1HpOU3\naZZoSb7stjXVNSjX9arqFzMCzBq2wvqViIkoT0wEg/BhHFSr5wQN5D0xRb/bAgMB\nAAGggZ8wgZwGCSqGSIb3DQEJDjGBjjCBizCBiAYDVR0RBIGAMH6BE3JmdHRlc3RA\nZmgtdHJpZXIuZGWBZ3JmdHRlc3RAcnouZmgtdHJpZXIuZGUgSi5URVNUQHJ6LmZo\nLXRyaWVyLmRlIHJmdHRlc3RAcnouaG9jaHNjaHVsZS10cmllci5kZSByZnR0ZXN0\nQGhvY2hzY2h1bGUtdHJpZXIuZGUwDQYJKoZIhvcNAQELBQADggIBAKGf8ztChN8j\nTGyyIGa0mblAEtYKjIUBSS4b9iJY+/xQa+g9yj00hu7UWJWJQogKEq4g0ayh7of/\njl8aE0AjOFQHseMd4DMUZsHQl+KGfX16Pm0TIzdUT+73TMef26eK7s1jnU/5XOfU\nnfnczsLu0TDcI7+WsM9gVD1JuX5NqhbZP2WFD/m3i6Akc0Fog9m7WhfATCFoiU88\n/hvQAF9Z+gviHwPT8ooNCPb+BvywtXfYBPRgwm6tln7wdb0n55LnHVqQPUdJL2yn\nuwsT89uCj3raXSxbs60ok7xUDx+d7VW1Py2utsDv++4rwoVkyZXXZYRhcYw59B85\npF5eBPfQ+0tZoeNwWxHwmzWBGTNJfoofOWFo+KDWk+HOmnVDnl2edfv+yLdnaMi4\nyqvHpzsPEfyoPvggmQp7n/eNQLZ9LzgnQjvaBStcmUrlTRvT7PRQ6wcCcKNAPJMZ\nI1XHFnChTyYbpXJmfHclZ17qbmHADiJW53zdNkqM3iKQcddZIDgGzQyXncTf6Fj7\n7gT+AD+El7ZpWdOt1lhCfKuorBdAvhMnV/lzgdQP0X+PMW9DApfPVdjJaJsnmHx4\nt3vz6Qn/z53d7K342p868z6yFgDOk04gdf/FdgGz1f3OSVWyMZ8ABFBhKgs0RtKe\nE4yURYnwCIR/YC9SoEKyzWyHgcIdP9F6\n-----END CERTIFICATE REQUEST-----",
  "certType": 16307,
  "term": 365,
  "eppn": "",
  "email": "rfttest@hochschule-trier.de",
  "secondaryEmails": [
    "rfttest@fh-trier.de",
    "rfttest@rz.fh-trier.de",
    "J.TEST@rz.fh-trier.de",
    "rfttest@rz.hochschule-trier.de",
    "rfttest@hochschule-trier.de"
  ]
}

Response:
{
  "orderNumber": 1054086955,
  "backendCertId": "1054086955"
}

* Returned orderNumber:
  1054086955

* Downloading p7b file:
  ./data/rfttest@hochschule-trier.de-20220717124259.p7b

* Compare e-mail addesses:
  ./data/rfttest@hochschule-trier.de-20220717124259.p7b

  Wanted: rfttest@hochschule-trier.de rfttest@rz.hochschule-trier.de J.TEST@rz.fh-trier.de rfttest@rz.fh-trier.de rfttest@fh-trier.de
  CSR:    rfttest@fh-trier.de rfttest@rz.fh-trier.de J.TEST@rz.fh-trier.de rfttest@rz.hochschule-trier.de rfttest@hochschule-trier.de (upper in reverse order)
  P7B:    rfttest@rz.fh-trier.de rfttest@hochschule-trier.de rfttest@rz.hochschule-trier.de J.TEST@rz.fh-trier.de rfttest@fh-trier.de rfttest@hochschule-trier.de
```

