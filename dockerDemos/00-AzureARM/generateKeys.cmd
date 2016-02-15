REM Generate keys for Docker
REM For details see https://docs.docker.com/engine/security/https/

SET OPENSSL_CONF=c:\Program Files\OpenSSL-Win64\bin\openssl.cfg
%1 genrsa -aes256 -out ca-key.pem -passout pass:test 4096
%1 req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem -config key.config -passin pass:test
%1 genrsa -out server-key.pem -passout pass:test 4096
%1 req -subj "/CN=%2" -sha256 -new -key server-key.pem -out server.csr -config key.config -passin pass:test
%1 x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -passin pass:test
%1 genrsa -out key.pem -passout pass:test 4096
%1 req -subj "/CN=client" -new -key key.pem -out client.csr -passin pass:test
%1 x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out cert.pem -extfile extfile.cnf -passin pass:test
erase *.csr 
erase *.srl