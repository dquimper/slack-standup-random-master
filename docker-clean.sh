# Stop and remove all containers
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

# remove all volumes
docker volume rm -f $(docker volume ls -q)

# Remove all images
docker rmi -f $(docker images -a -q)

