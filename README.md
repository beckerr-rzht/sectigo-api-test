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

* Result:
        Subject: C = DE, O = Hochschule Trier - Trier University of Applied Sciences, L = Trier, postalCode = 54293, street = Schneidershof, CN = Dr. Juergen Test, emailAddress = rfttest@hochschule-trier.de
        Subject Public Key Info:
            X509v3 Subject Alternative Name: 
                email:rfttest@hochschule-trier.de rfttest@rz.hochschule-trier.de J.TEST@rz.fh-trier.de rfttest@rz.fh-trier.de rfttest@fh-trier.de
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
  rfttest@hochschule-trier.de rfttest@rz.hochschule-trier.de J.TEST@rz.fh-trier.de rfttest@rz.fh-trier.de rfttest@fh-trier.de

* Cert-Type:
  16307 = GÉANT Personal Certificate

* Request:
{
  "orgId": 28420,
  "firstName": "Juergen",
  "middleName": "",
  "lastName": "Test",
  "commonName": "Dr. Juergen Test",
  "csr": "-----BEGIN CERTIFICATE REQUEST-----\nMIIFsjCCA5oCAQAwgc4xCzAJBgNVBAYTAkRFMUAwPgYDVQQKDDdIb2Noc2NodWxl\nIFRyaWVyIC0gVHJpZXIgVW5pdmVyc2l0eSBvZiBBcHBsaWVkIFNjaWVuY2VzMQ4w\nDAYDVQQHDAVUcmllcjEOMAwGA1UEEQwFNTQyOTMxFjAUBgNVBAkMDVNjaG5laWRl\ncnNob2YxGTAXBgNVBAMMEERyLiBKdWVyZ2VuIFRlc3QxKjAoBgkqhkiG9w0BCQEW\nG3JmdHRlc3RAaG9jaHNjaHVsZS10cmllci5kZTCCAiIwDQYJKoZIhvcNAQEBBQAD\nggIPADCCAgoCggIBAMQMI439s/UPqvWtWkPDj0XS9SVn3kkRcewVSqoR5hSPmuHn\nzcYxk0FJVB0erIsL2OSaWTtIoMMBstZa9PGWG6vYe8vVF4LxyXoIXmGQVaRCmIgY\nUtZ8bk7o/aoqnJV9zVPedGlWVUTthORVXbzyLPwE2Tjp6HUvF98LBOBaFazl8wXE\nlZ8fGfAYuduA8ZCo/tNN2+7NwnRFnpoNUg6S40nxwM7ZWRfOdFtginF1WlJdieEZ\nogxuYxKb8CQAopog13OtE/XA7+Igdhf50VxCJG84LwRB4GCutdLpk68aYrCyb3sP\nhi4oqLPCCfMLchXaNXjGEs9dMfVyhbIslM5anxYHMqEboyUHwT79VNx+P5HTqMM8\nxcFm+MPzKudlqY8L1NGkEkm9UerNw+QZzvv/Av5BKypTqMjdcB7M34F6g07nFLxu\nOUVzSjOkFwh7HYmPnAL3qTaqeNmDCk3xwtkNZ/oThhSFT5s1a0PX0SHDWXJ1US9v\niGsmYKw/0Pa0JHRKgZF7Q4RPLkUsZsy09lovjTnr5V0lKa/NbydDWaLMwJBQBQY7\n5lHrXtJbsaPqorXfFsEX3Tn1ioUo54evq7D/AFHM1yBExzYuGOFjK1z7Sn1HpOU3\naZZoSb7stjXVNSjX9arqFzMCzBq2wvqViIkoT0wEg/BhHFSr5wQN5D0xRb/bAgMB\nAAGggZ0wgZoGCSqGSIb3DQEJDjGBjDCBiTCBhgYDVR0RBH8wfYF7cmZ0dGVzdEBo\nb2Noc2NodWxlLXRyaWVyLmRlIHJmdHRlc3RAcnouaG9jaHNjaHVsZS10cmllci5k\nZSBKLlRFU1RAcnouZmgtdHJpZXIuZGUgcmZ0dGVzdEByei5maC10cmllci5kZSBy\nZnR0ZXN0QGZoLXRyaWVyLmRlMA0GCSqGSIb3DQEBCwUAA4ICAQA2FCQBQdS67NTG\nMuOmcgKuyyynOpg+Vv8b06AoYz0qnFTj5rdn1LgA0XXuMGDvlBvmWdwl5ewk0Lyf\nFCmdzBs4SruagV7ij7fGmTh00LhW06OTI0n1PWy1fNRwVVaVHKax3JSNQINNsrwv\nIiGPHgS1o+OFu+f1wQOrRQeyrldd/bOSAqvkrCzGoVPdcuP89eWXa3QK4jut0hvT\nIz5nhfpO6aH9eDU5VJwkx6QKpfTquw0hPGdaBtzSzjL8nA2bQXDRRN8kkU6QjUmM\nq1RBKz8mExehEGpfVujRvkp0VeHwnrK8NjORugIKQftPwq9dbmEkTZ44H5A4uoGt\nyyrcasAO901nCVLQQilW2SFC9rNkKdGfwAQTum+Jfbh9VGW4B6cHNWcbVZQtrDAE\n6M7tl9A3wfITq6mThICT3PL5vDmJU6zz/Mn+J04prj8uJ7wPTljtskQu6o4Osu9m\nAPgzH1Kyb/8KDh6vKzsGcdzBCXcOnqyVjAiIl05HqTXSy/AMDRkbtFIJB+Ias+r3\nnetpgYQHdwZiE6nrRiRMpuLaapLgdLF0VXQbHeQzuN9aeOXuvUI8v4zIWCVu2DGY\nNPrJAULQX59eXY4BT7FU21hrz9VIZFgz3txG4UFh0T59fuUdCP0qTHM97dAgBoeK\nxGZ4UBJvXHjee9JsZP+qFxWESMgNtA==\n-----END CERTIFICATE REQUEST-----",
  "certType": 16307,
  "term": 365,
  "eppn": "",
  "email": "rfttest@hochschule-trier.de",
  "secondaryEmails": [
    "rfttest@hochschule-trier.de",
    "rfttest@rz.hochschule-trier.de",
    "J.TEST@rz.fh-trier.de",
    "rfttest@rz.fh-trier.de",
    "rfttest@fh-trier.de"
  ]
}

Response:
{
  "orderNumber": 1170803656,
  "backendCertId": "1170803656"
}

* Returned orderNumber:
  1170803656

* Downloading p7b file:
  ./data/rfttest@hochschule-trier.de-20220926155843.p7b

* Compare e-mail addesses:
  ./data/rfttest@hochschule-trier.de-20220926155843.p7b

  Wanted: rfttest@hochschule-trier.de rfttest@rz.hochschule-trier.de J.TEST@rz.fh-trier.de rfttest@rz.fh-trier.de rfttest@fh-trier.de
  CSR:    rfttest@hochschule-trier.de rfttest@rz.hochschule-trier.de J.TEST@rz.fh-trier.de rfttest@rz.fh-trier.de rfttest@fh-trier.de
  P7B:    rfttest@hochschule-trier.de rfttest@rz.hochschule-trier.de J.TEST@rz.fh-trier.de rfttest@rz.fh-trier.de rfttest@fh-trier.de rfttest@hochschule-trier.de
```

