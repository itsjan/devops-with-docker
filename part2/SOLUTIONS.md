# DevOps with Docker - Exercises PART 2

- [DevOps with Docker - Exercises PART 2](#devops-with-docker---exercises-part-2)
  - [Migrating to Docker Compose](#migrating-to-docker-compose)
    - [Exercise 2.1](#exercise-21)
    - [Exercise 2.2](#exercise-22)
    - [Exercise 2.3](#exercise-23)
  - [Docker Networking](#docker-networking)
    - [Exercise 2.4](#exercise-24)

## Migrating to Docker Compose

### Exercise 2.1
Let us now leverage the Docker Compose with the simple webservice that we used in the Exercise 1.3

Without a command devopsdockeruh/simple-web-service will create logs into its /usr/src/app/text.log.

Create a docker-compose.yml file that starts devopsdockeruh/simple-web-service and saves the logs into your filesystem.

Submit the docker-compose.yml, and make sure that it works simply by running docker compose up if the log file exists.

**Solution**
```yml
name: ex2_1-simple-web-service

services:
  simple-web-service:
    image: devopsdockeruh/simple-web-service
    ports:
      - "8080:8080"
    volumes:
      # bind log file to a local file.
      # file text.log must exist (touch text.log)
      - ./text.log:/usr/src/app/text.log
```

### Exercise 2.2

Read about how to add the command to docker-compose.yml from the documentation.

The familiar image devopsdockeruh/simple-web-service can be used to start a web service, see the exercise 1.10.

Create a docker-compose.yml, and use it to start the service so that you can use it with your browser.

Submit the docker-compose.yml, and make sure that it works simply by running docker compose up

**Solution**

```yml
name: ex2_2-simple-web-service

services:
  simple-web-service:
    image: devopsdockeruh/simple-web-service
    ports:
      - "8080:8080"
    command: server
```

### Exercise 2.3
As we saw previously, starting an application with two programs was not trivial and the commands got a bit long.

In the previous part we created Dockerfiles for both frontend and backend of the example application. Next, simplify the usage into one docker-compose.yml.

Configure the backend and frontend from part 1 to work in Docker Compose.

Submit the docker-compose.yml

**Solution**

```yml
name: example-front-and-back

services:
  example-frontend:
    build: example-frontend
    image: example-frontend  
    restart: "no"
    ports:
      - 5555:5000 
    depends_on:
      - example-backend
  
  example-backend:
    build: example-backend
    image: example-backend
    restart: "no"
    ports:
      - 8080:8080
```

---

## Docker Networking

### Exercise 2.4
In this exercise you should expand the configuration done in Exercise 2.3 and set up the example backend to use the key-value database Redis.

Redis is quite often used as a cache to store data so that future requests for data can be served faster.

The backend uses a slow API to fetch some information. You can test the slow API by requesting /ping?redis=true with curl. The frontend app has a button to test this.

So you should improve the performance of the app and configure a Redis container to cache information for the backend. The documentation of the Redis image might contain some useful info.

The backend README should have all the information that is needed for configuring the backend.

When you've correctly configured the button will turn green.

Submit the docker-compose.yml



**Solution**

```yml
name: example-front-and-back

services:
  example-frontend:
    build: example-frontend
    image: example-frontend  
    restart: "no"
    ports:
      - 5555:5000 
    depends_on:
      - example-backend
  
  example-backend:
    build: example-backend
    image: example-backend
    restart: "no"
    depends_on:
      - redis
    ports:
      - 8080:8080
  
  redis:
    image: redis
    restart: "unless-stopped"
```