# Task 1 - Simple Time Service
Simple Time Service is a Python webserver created with Flask Web framework. Its function is to output Current Time along with IP Address of the machine in which the webserver is running

## Steps for installation

The application code can be found in the in the 'app' folder, named as [sts.py](https://github.com/zer00ssk/p41challenge/blob/challenge_p41/app/sts.py) 
The folder also contains [Dockerfile](https://github.com/zer00ssk/p41challenge/blob/challenge_p41/app/Dockerfile) which will be used for creating image and running a container using the image.

### Copy Code/Pull repository

The repository code can be pulled from this repository using the link
> https://github.com/zer00ssk/p41challenge.git

### Copy contents to Directory

Once cloned, the `sts.py` and `Dockerfile` should be copied to the following directory (Linux Filesystems used)

```
/home/p41test
```
Create the directory for app code:
```
cd /home
mkdir p41test
```
Use this command to copy the contents from the existing directory to the correct directory:
```
cp /existing/directory/path /home/p41test/
```
If any other directory is being used, the same is to be updated in the Dockerfile. It is advised to use any subdirectories placed within `/home` itself.

### Updating Dockerfile appropriately

In the Dockerfile, change the following paths:

```
# insert the path here
3  WORKDIR /home/p41test
```

As specified in the requirements, the Docker container needs to run from a non-root user. Thus, to facilitate this, a new user is being created. Alterations, according to the need, can be done
```
# group name 'appgroup' can be altered accordingly. In the same way, the user named 'appuser' can also be altered accordingly.

5 RUN addgroup -S appgroup

# The directories where the New user's default directory will be created is specified here. If any other directory which isn't in /home is used, the same needs to be updated here.
6
7 RUN adduser -S appuser -G appgroup -h /home -s /sbin/nologin

# And here as well
8 
9 RUN chown -R appuser:appgroup /home
```

After all the alterations, if any, are completed, the image can be built off of this Dockerfile. 

### Building image from Dockerfile

Ensure the present working directory is the same where the Dockerfile exists. In this case, its `/home/p41test`. 

```
cd /home/p41test

# command to build image from Dockerfile
docker build -t <image_name> .

# the image name can be specified as required. Here, its 'p41testimage'
docker build -t p41testimage .

```
The image will be build locally. The image after getting built, can be verified by: 

```
docker image ls
```
This will list the images built locally. Copy the ID of the image.

### Pushing the image to Docker Hub

The locally built image can be pushed to Docker Hub. Following are the steps: 
1. Assuming the user has a Docker Hub created, the user needs to login first.
```
docker login -u <username>
```
Enter the username. Later, prompt for password will be asked. Enter the password and you will be logged in. 

2. The image needs to be tagged accordingly. Paste the image ID in the following command.
```
docker tag <image_id> <user_name>/<image_name>
```

3. Push the iamge to Docker hub"
```
docker push <user_name>/<image_name> 
```
The image will be uploaded to Docker Hub.

### Pulling image from Docker Hub

Once the image is pushed to Docker Hub, the image can be pulled from any machine and container can be created. 
```
# add the appropriate username and imagename, as used above
docker pull <user_name>/<image_name>

# in this case, the repo is as shown below
docker pull cgshash2025/p41testimage
```
The image repository in Docker Hub can be found by clicking [here](https://hub.docker.com/r/cgshash2025/p41testimage)

Once the image is pulled, the container can be created
```
docker run -p 5000:5000 cgshash2025/p41testimage
```
# Task 2 - Terraform and Azure Cloud - Creating Infrastructure

In Task 1, Docker Image was created and pushed to Docker Hub. In this task, Infrastructure in Azure will be created using Terraform for hosting the container/pods using the Docker Image created previously. 

