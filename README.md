# johnkins

docker build -t johnkins .

docker run -p 80:8080 -p 50001:50001 -v /john:/john --restart=always -d johnkins
