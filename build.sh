docker rmi -f syter/csgo
docker build -f Dockerfile -t syter/csgo:latest .
docker tag syter/csgo:latest registry.hub.docker.com/library/syter/csgo:latest
docker push syter/csgo:latest