#!/bin/bash

# TODO allow for external CA and/or external certs

#generating certificates
# https://gist.github.com/fntlnz/cf14feb5a46b2eda428e000157447309

# Generate CA certificate
 openssl genrsa -out ca.key.pem 4096
 openssl req -x509 -new -nodes -key ca.key.pem -subj "/C=ES/ST=PO/O=org.gradiant/CN=ca.openverso" -sha256 -days 1024 -out cacert.pem


# Create cert
openssl genrsa -out hss.key.pem 2048
openssl req -new -sha256 -key hss.key.pem -subj "/C=ES/ST=PO/O=org.gradiant/CN=$CERT_CN" -out hss.cert.pem
# Sign cert
openssl x509 -req -in hss.cert.pem -CA cacert.pem -CAkey ca.key.pem -CAcreateserial -out hss.cert.pem -days 500 -sha256

# Warning, we have the ca.key.pem in /certs folder