# DevOps with Docker - Exercises PART 3

## Deployment Pipelines

### Exercise 3.1: Your pipeline

**Solution**

Github repository: <https://github.com/itsjan/devops-pipeline-express-app/>

![screenshot](ex3_1.png)

### Exercise 3.2: A deployment pipeline to a cloud service
In Exercise 1.16 you deployed a containerized app to a cloud service.

Now it is time to improve your solution by setting up a deployment pipeline for it so that every push to GitHub results in a new deployment to the cloud service.

You will most likely find a ready-made GitHub Action that does most of the heavy lifting your you... Google is your friend!

Submit a link to the repository with the config. The repository README should have a link to the deployed application.




**Solution**

Link to GitHub repo: <https://github.com/itsjan/P3-Arcade-Game>

Notes: 
Each Render service has a deploy hook URL you can use to trigger a deploy via a GET or POST request. Your service’s deploy hook URL is available from its Settings page on the [Render Dashboard](https://dashboard.render.com/).

<https://docs.render.com/deploy-an-image>

![screenshot](ex3_2.png)


### Exercise 3.3: Scripting magic
Create a now script/program that downloads a repository from GitHub, builds a Dockerfile located in the root and then publishes it into the Docker Hub.

**Solution**


```bash
#!/bin/bash
# file builder.sh

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <github-repo> <docker-hub-repo>"
    exit 1
fi

REPO=$1
HUB_REPO=$2

TMP_DIR=$(mktemp -d)
git clone https://github.com/$REPO.git $TMP_DIR
cd $TMP_DIR
docker build -t $HUB_REPO .
docker push $HUB_REPO
```

### 3.4: Building images from inside of a container
As seen from the Docker Compose file, the Watchtower uses a volume to docker.sock socket to access the Docker daemon of the host from the container:

services:
watchtower:
  image: containrrr/watchtower
  volumes:
    - /var/run/docker.sock:/var/run/docker.sock
  # ...

In practice this means that Watchtower can run commands on Docker the same way we can "command" Docker from the cli with docker ps, docker run etc.

We can easily use the same trick in our own scripts! So if we mount the docker.sock socket to a container, we can use the command docker inside the container, just like we are using it in the host terminal!

Dockerize now the script you did for the previous exercise. You can use images from this repository to run Docker inside Docker!


Note that now the Docker Hub credentials are defined as environment variables since the script needs to log in to Docker Hub for the push.

Submit the Dockerfile and the final version of your script.

Hint: you quite likely need to use ENTRYPOINT in this Exercise. See Part 1 for more.

**Solution**

Dockerfile
```dockerfile
FROM docker

WORKDIR /usr/local/bin

COPY ./builder.sh /usr/local/bin/builder.sh
RUN chmod +x /usr/local/bin/builder.sh

ENTRYPOINT [ "sh", "builder.sh" ]

```

builder.sh
```sh
#!/bin/bash
# file builder.sh

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <github-repo> <docker-hub-repo>"
    exit 1
fi

REPO=$1
HUB_REPO=$2

TMP_DIR=$(mktemp -d)
git clone https://github.com/$REPO.git $TMP_DIR
cd $TMP_DIR
docker build -t $HUB_REPO .
docker login -u $DOCKER_USER -p $DOCKER_PWD
docker push $HUB_REPO
```
command to run:

```bash
docker run -e DOCKER_USER=<username>` \   # change to your username
  -e DOCKER_PWD=<password>` \             # change to your password
  -v /var/run/docker.sock:/var/run/docker.sock \
  builder mluukkai/express_app itsjan/testataan
```
