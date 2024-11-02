# Running the Nukkit server
In order to be able to configure the server it is required to run the container in an interactive configureation. 

## Docker
It is required to use the `-it` switches

```
docker run -it -p 19132:19132/udp -v nukkit-data:/data nukkit
```
This command will create a Docker volume for the data. 

## Docker compose
It is required to add the correct arguments to the image example in the [provided compose file](./docker_compose.yml). 
```
stdin_open: true # docker run -i
tty: true        # docker run -t
```
### Configuration
The docker compose is configured using a .env file (example [here](./.env))

### Bind volume workaround
In order for the server to be able to save into the bind volume it is required to set the owner of the `/data` folder to the `minecraft user` by running the following commands after the startup. 

```
docker exec -it -u root nukkit /bin/bash
```

```
cd /data && chown minecraft ./ && chgrp minecraft ./
```
Then it is required to exit the container shell and follow the [startup section](#startup)
# Configuration
To issue any commands to the server use the following Docker command.
```
docker attach nukkit
```

## Startup
In order to create the required configuration file it is required to use the attach command and set the language to eg. English by inputting `eng` and pressing enter.  

## Server commands
In order to issue commands to the server it needs to be launched correctly, see [this section](#running-the-nukkit-server).

After issueing the requested commands exit the interactive mode with `ctrl+p` and `ctrl+q`
