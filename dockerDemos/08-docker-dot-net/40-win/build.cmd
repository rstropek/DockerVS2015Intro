xcopy "..\02-dotnet-fx-sample\out" ".\app\" /e /y

docker rm -f basta-win
docker rmi rstropek/basta-win
docker build -t rstropek/basta-win .
docker run -d --name basta-win -p 80:80 rstropek/basta-win
docker inspect -f "{{ .NetworkSettings.Networks.nat.IPAddress }}" basta-win
