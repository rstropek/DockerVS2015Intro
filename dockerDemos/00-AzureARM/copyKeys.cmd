REM Script for copying certs to Docker client using pscp

echo y | %1\pscp -l training -pw P@ssw0rd! ca.pem training@%2:/home/training/.docker/
echo y | %1\pscp -l training -pw P@ssw0rd! cert.pem training@%2:/home/training/.docker/
echo y | %1\pscp -l training -pw P@ssw0rd! key.pem training@%2:/home/training/.docker/

