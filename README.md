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
  21222 = GÉANT Personal email signing and encryption

* Person Request:
{
  "organizationId": 28420,
  "firstName": "Juergen",
  "middleName": "",
  "lastName": "Test",
  "commonName": "Dr. Juergen Test",
  "validationType": "HIGH",
  "phone": "",
  "email": "rfttest@hochschule-trier.de",
  "secondaryEmails": [
    "rfttest@hochschule-trier.de",
    "rfttest@rz.hochschule-trier.de",
    "J.TEST@rz.fh-trier.de",
    "rfttest@rz.fh-trier.de",
    "rfttest@fh-trier.de"
  ]
}

* Find Person by Email...
Response:
{
  "personId": 320542
}

* Updating Person 320542 ...
Response:
OK

* Enroll Request:
{
  "orgId": 28420,
  "firstName": "Juergen",
  "middleName": "",
  "lastName": "Test",
  "commonName": "Dr. Juergen Test",
  "csr": "-----BEGIN CERTIFICATE REQUEST-----\nMIIFsjCCA5oCAQAwgc4xCzAJBgNVBAYTAkRFMUAwPgYDVQQKDDdIb2Noc2NodWxl\nIFRyaWVyIC0gVHJpZXIgVW5pdmVyc2l0eSBvZiBBcHBsaWVkIFNjaWVuY2VzMQ4w\nDAYDVQQHDAVUcmllcjEOMAwGA1UEEQwFNTQyOTMxFjAUBgNVBAkMDVNjaG5laWRl\ncnNob2YxGTAXBgNVBAMMEERyLiBKdWVyZ2VuIFRlc3QxKjAoBgkqhkiG9w0BCQEW\nG3JmdHRlc3RAaG9jaHNjaHVsZS10cmllci5kZTCCAiIwDQYJKoZIhvcNAQEBBQAD\nggIPADCCAgoCggIBAK423YscNpKfhh0m55DaLh0vKKTxaoTILLlYPPfxxiYz+Ms1\nhwA87iqpTdJvW+66cFBjJ02fj2G+gLuL+3Gd3uwOZrggVIjeEnn7WCwZjHAKcW5h\nkedyAd/uFMWz7hZsdKSP/gRKg3Gf8yOK+K83Ywatwcm0ntWFJqxNWvzcPU83jX7A\n+YYJIuVAG3xhQ6nbSQDLmSu9DhjAej81CNID7B7aSZs0MWJyzL7XxPqcniFgxfnp\nS6juxh4vGPk9EH3HcgTaWXie0OeDTWDryfImnh5Cw8XDHNExa/DqFZcoHjkfI7HH\nTYfGqItLTL5XmytdjBVxos8DrztGyQPrWl8XtNa0rIZ0497RMLETubBfD0bd0JhG\n1rtS7AsUu2GLftTRJgKua2YRuoksWSNd6TIgSVMTt+Iu7eUpCZojS+5Xdhkdd5AC\nflbpMcdCu8hwmwbf3eAIK7KfzRbGfMfzRwsJuW18Rl4TadyClm0lkmq3cZF7nWXe\nLTcfySQwpKihisscxHIJEzJQ0xHiflXNUNCUmVedLO2tmuDmQCngZRV5FHs0PQ2h\nwle4621w90cum0MgrpRoPGgPKHGkScIug0JJ2PuahyNI+Eh8gWUpGgm/btRpJlWr\nv5MYqnISMYKmYFwWzCoAPfmKJbvJTmzdfEhtVCG6Ps++QVAL0PcV4mzB1shRAgMB\nAAGggZ0wgZoGCSqGSIb3DQEJDjGBjDCBiTCBhgYDVR0RBH8wfYF7cmZ0dGVzdEBo\nb2Noc2NodWxlLXRyaWVyLmRlIHJmdHRlc3RAcnouaG9jaHNjaHVsZS10cmllci5k\nZSBKLlRFU1RAcnouZmgtdHJpZXIuZGUgcmZ0dGVzdEByei5maC10cmllci5kZSBy\nZnR0ZXN0QGZoLXRyaWVyLmRlMA0GCSqGSIb3DQEBCwUAA4ICAQBQDTUd/T85kQW/\nBLhKk7k0cwu6uMo40FWW6tXe2VDIv15OqtyZ87VVpotNwBaliEGpUwOmX0J1WXrX\noIvRwpLEkJfRAyJRxeM0KtA3ZuE6H/GzYjN+j6I706W+2KPiqs6yUc5gNP1cgzed\nL02DCRilPWExmF/MbAbGJohIodmNW/k5fJuTHy9s0TySRWwTtlj6ctu4GdUdFm1s\nw6pBNt4LmPPgB/lktSJMnpYU0gLAG/Orkc2+nWTy0obj0hshbCJ7uUczIC6OdaCN\naTk7eiNoLfrkgCOg+svEfhRdM6PbIzJ+3kxgYx4TlEDrb7e9ahOHvekaX1mzIpR9\nWZu/GF/BCProoYFw2jStmSd88KtrMxf6hZ/JOnxIW2Yu5Q12KGYh1TKSM4om4Nhg\nTpGMMEGIkbMT+9k8CQAC7CC6/egOHHylJB4WIY0oUUs8a9ngENw0p/XaYaGMbgVN\nUXnIrTwKgoX8sAwl6WrOkHTDatiy36VbC2CNsZAxNXaNJStsQsj6civey/hsGzma\nxJncUduACRiF8ItDPohG6k53r8EbcZ2RnwU1Q82thCwxp2eJONnXR0dVORWGVM0D\n06S9fpu5EralISjjmGAQEvKMKVrfcQmShLTwHX+ASA5ySY5VLeHC8kvKwO8skiEx\n/eKx30W74VhO83WxYBO11IVdm1xHyw==\n-----END CERTIFICATE REQUEST-----",
  "certType": 21222,
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
  "orderNumber": 1923182777,
  "backendCertId": "1923182777"
}

* Returned orderNumber:
  1923182777

* Downloading p7b file:
  ./data/rfttest@hochschule-trier.de-20231031075259.p7b

  {"code":-183,"description":"Certificate is not collectable."} ... next try in 10s
  {"code":-183,"description":"Certificate is not collectable."} ... next try in 10s
  {"code":-183,"description":"Certificate is not collectable."} ... next try in 10s
  {"code":-183,"description":"Certificate is not collectable."} ... next try in 10s
-----BEGIN PKCS7-----
MIIYpwYJKoZIhvcNAQcCoIIYmDCCGJQCAQExADALBgkqhkiG9w0BBwGgghh8MIIH
0zCCBbugAwIBAgIQd5KdspH4axW7RfOc5IQAXDANBgkqhkiG9w0BAQwFADBGMQsw
...
Jqsil2D4kF501KKaU73yqWjgom7C12yxow+ev+to51byrvLjKzg6CYG1a4XXvi3t
Pxq3smPi9WIsgtRqAEFQ8TmDn5XpNpaYbjEA
-----END PKCS7-----
* Compare e-mail addesses:
  ./data/rfttest@hochschule-trier.de-20231031075259.p7b

  Wanted: rfttest@hochschule-trier.de rfttest@rz.hochschule-trier.de J.TEST@rz.fh-trier.de rfttest@rz.fh-trier.de rfttest@fh-trier.de
  CSR:    rfttest@hochschule-trier.de rfttest@rz.hochschule-trier.de J.TEST@rz.fh-trier.de rfttest@rz.fh-trier.de rfttest@fh-trier.de
  P7B:    rfttest@hochschule-trier.de rfttest@fh-trier.de J.TEST@rz.fh-trier.de rfttest@rz.hochschule-trier.de rfttest@rz.fh-trier.de

```

