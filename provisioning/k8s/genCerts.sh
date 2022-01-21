#!/usr/bin/env bash


# https://betterprogramming.pub/trusted-self-signed-certificate-and-local-domains-for-testing-7c6e6e3f9548


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CERT_DIR=$SCRIPT_DIR/certs

rm -rf $CERT_DIR
mkdir -p $CERT_DIR



# generate root-ca: styra-sa.com
openssl genrsa -out "$CERT_DIR/styra-demo.com.key" 4096
openssl req -new -x509 -nodes \
  -sha256 -days 365 \
  -key "$CERT_DIR/styra-demo.com.key" \
  -out "$CERT_DIR/styra-demo.com.crt" \
  -subj "/C=US/ST=CA/L=Redwood City/O=Styra Inc./OU=Customer Success/CN=styra-demo.com"



# # banking.styra-demo.com
# cat > "$CERT_DIR/banking.styra-demo.com.csr.cnf" <<EOL
# [req]
# default_bits = 4096
# prompt = no
# default_md = sha256
# distinguished_name = dn

# [dn]
# C=US
# ST=CA
# L=Redwood City
# O=Styra Inc.
# OU=Customer Success
# CN=banking.styra-demo.com
# EOL

# cat > "$CERT_DIR/banking.styra-demo.com.csr.v3.ext" <<EOL
# authorityKeyIdentifier=keyid,issuer
# basicConstraints=CA:FALSE
# keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
# subjectAltName = @alt_names

# [alt_names]
# DNS.1 = banking.styra-demo.com
# EOL

# openssl req -new -nodes \
#   -sha256 \
#   -newkey rsa:4096 \
#   -keyout "$CERT_DIR/banking.styra-demo.com.key" \
#   -out "$CERT_DIR/banking.styra-demo.com.csr" \
#   -config "$CERT_DIR/banking.styra-demo.com.csr.cnf"

# openssl x509 -req \
#   -sha256 \
#   -days 365 \
#   -CAkey "$CERT_DIR/styra-demo.com.key" \
#   -CA "$CERT_DIR/styra-demo.com.crt" \
#   -CAcreateserial \
#   -out "$CERT_DIR/banking.styra-demo.com.crt" \
#   -in "$CERT_DIR/banking.styra-demo.com.csr" \
#   -extfile "$CERT_DIR/banking.styra-demo.com.csr.v3.ext"


# rm "$CERT_DIR/banking.styra-demo.com.csr" 
# rm "$CERT_DIR/banking.styra-demo.com.csr.cnf"
# rm "$CERT_DIR/banking.styra-demo.com.csr.v3.ext"
# rm "$CERT_DIR/styra-demo.com.srl"


# wildcard.styra-demo.com
cat > "$CERT_DIR/wildcard.styra-demo.com.csr.cnf" <<EOL
[req]
default_bits = 4096
prompt = no
default_md = sha256
distinguished_name = dn

[dn]
C=US
ST=CA
L=Redwood City
O=Styra Inc.
OU=Customer Success
CN=*.styra-demo.com
EOL

cat > "$CERT_DIR/wildcard.styra-demo.com.csr.v3.ext" <<EOL
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = *.styra-demo.com
EOL

openssl req -new -nodes \
  -sha256 \
  -newkey rsa:4096 \
  -keyout "$CERT_DIR/wildcard.styra-demo.com.key" \
  -out "$CERT_DIR/wildcard.styra-demo.com.csr" \
  -config "$CERT_DIR/wildcard.styra-demo.com.csr.cnf"

openssl x509 -req \
  -sha256 \
  -days 365 \
  -CAkey "$CERT_DIR/styra-demo.com.key" \
  -CA "$CERT_DIR/styra-demo.com.crt" \
  -CAcreateserial \
  -out "$CERT_DIR/wildcard.styra-demo.com.crt" \
  -in "$CERT_DIR/wildcard.styra-demo.com.csr" \
  -extfile "$CERT_DIR/wildcard.styra-demo.com.csr.v3.ext"


rm "$CERT_DIR/wildcard.styra-demo.com.csr" 
rm "$CERT_DIR/wildcard.styra-demo.com.csr.cnf"
rm "$CERT_DIR/wildcard.styra-demo.com.csr.v3.ext"
rm "$CERT_DIR/styra-demo.com.srl"