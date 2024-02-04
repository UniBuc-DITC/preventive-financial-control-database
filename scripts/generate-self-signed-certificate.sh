#!/usr/bin/env bash

# The following command uses the OpenSSL CLI to generate a self-signed TTL certificate.
# It also adds the server's DNS domain to the Subject Alternative Names field
# to ensure no issues arise when accessing the pgAdmin interface using the Google Chrome browser.
#
# Based on https://stackoverflow.com/questions/10175812/how-to-generate-a-self-signed-ssl-certificate-using-openssl/41366949#41366949

openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 \
  -nodes -keyout bd-cfp.unibuc.ro.key -out bd-cfp.unibuc.ro.pem -subj "/CN=bd-cfp.unibuc.ro" \
  -addext "subjectAltName=DNS:bd-cfp.unibuc.ro"
