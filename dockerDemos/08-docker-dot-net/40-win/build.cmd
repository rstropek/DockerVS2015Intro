xcopy "..\02-dotnet-fx-sample\out" ".\app\" /e /y

docker rm -f tdsweden-win
docker rmi rstropek/tdsweden-win
docker build -t rstropek/tdsweden-win .
docker run -d --name tdsweden-win -p 80:80 rstropek/tdsweden-win
docker inspect -f "{{ .NetworkSettings.Networks.nat.IPAddress }}" tdsweden-win
