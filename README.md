## Build images

* Activate a Python virtual environment and install Flask as a dependency:

```sh
cd /path/to/python-docker
python3 -m venv .venv
source .venv/bin/activate
(.venv) $ pip install Flask
(.venv) $ pip install mysql-connector-python
(.venv) $ pip freeze > requirements.txt
```

* Test the application:
```sh
(venv) $ python -m flask run 
```

* Build, tag and publish the Docker image
```sh
export DOCKER_HUB_ID="YOUR DOCKER HUB ID" # user id in the docker hub container registry
docker build -t ${DOCKER_HUB_ID}/python-docker:latest -t ${DOCKER_HUB_ID}/python-docker:v1.0.0 .
docker push ${DOCKER_HUB_ID}/python-docker:latest # publish image latest version
docker push ${DOCKER_HUB_ID}/python-docker:v1.0.0 # publish image v1.0.0
docker images # list images
```

## Run containers
### `docker run` CLI
* Run MySQL database
```sh
docker volume create mysql
docker volume create mysql_config
docker network create mysqlnet
docker run --rm -d -v mysql:/var/lib/mysql \
 -v mysql_config:/etc/mysql -p 3306:3306 \
 --network mysqlnet \
 --name mysqldb \
 -e MYSQL_ROOT_PASSWORD=p@ssw0rd1 \
 mysql
```
* Run webserver
```sh
docker run \
  --rm -d \
  --network mysqlnet \
  --name rest-server \
  -p 5000:5000 \
  ${DOCKER_HUB_ID}/python-docker:latest
```
* Remove container, volume and network created
```sh
docker rm --force ${MYSQLDB_CONTAINER_ID} ${WEBSERVER_CONTAINER_ID} # use `docker ps` cli to find the container ids
docker volume rm mysql_config
docker volume rm mysql
docker network rm mysqlnet
```

### `docker-compose`
* Run MySQL database and webserver and create all the required resources (network, volume, etc.):
```sh
docker compose -f docker-compose.dev.yaml up --build
```

# References
* https://docs.docker.com/language/python/