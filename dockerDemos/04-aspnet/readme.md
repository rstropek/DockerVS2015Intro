# .NET Sample

```sh
docker build -t sff-test --target test .

docker-compose -f docker-compose-tests.yaml build
docker-compose -f docker-compose-tests.yaml run test

docker-compose build
docker-compose up
docker-compose down
```
