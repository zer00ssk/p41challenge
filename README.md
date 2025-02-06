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

### Authenticating Azure Credentials 

#### Azure Client ID, Client Secret and Tenant ID
![image](https://github.com/user-attachments/assets/2a34e667-0feb-42ac-9d82-a4965fd032fc)
Go to Microsoft Entra ID

![image](https://github.com/user-attachments/assets/bc6dd993-8920-4a98-abfa-ffb529df36fc)
First thing, the Tenant ID can be seen. Copy the same for Tenant ID.
Once the page is opened, click on "Manage" 
Then, click on App Registrations, under the Manage menu. 
In the "App Registrations" page, go to "All Applications" tab, and see choose the appropriate application for Client ID. 

For Client Secret, click on the Application. The application page will be opened.
![image](https://github.com/user-attachments/assets/2e7b8b58-19ea-43f5-982b-34042d2fb5ec)

Then, click on "manage" menu, "Certificates & secrets" page. You can see the page appear. Click on "Client Secrets" tab. Below, would be a list of secret(s).
The Client secret value will be visible. If its not visible, create a new one by clicking the "New Client Secret". After creating, the value will be visible ONLY FOR THE FIRST TIME. Ensure to COPY THE VALUE AND STORE IT SOMEWHERE SAFE for FUTURE REFERENCES.

#### Azure Subscription ID 
![image](https://github.com/user-attachments/assets/1b44cb72-4377-4533-9f50-4454a3e03043)
Search for subscrpition in the search bar and click on Subscription. List of subscriptins will appear. Click on the appropriate subscription. 

After clicking, the subscription overview page will appear.

![image](https://github.com/user-attachments/assets/b8dedaf2-46b4-4f97-acea-4f38b9540570)
Copy the subscription ID. 

#### Paste the details in terraform.tfvars

THe details copied in the previous tasks, are to be pasted in the terraform.tfvars file, in the `terraform` directory. 

```
# paste the details in the variables specified
azure-client-id = ""
azure-client-secret = ""
azure-subscription = ""
azure-tenant = ""
```
### Running the Terraform deployment

- Clone the git repository to the machine of your choice. 

- Ensure Terraform is installed in the machine
  ```
  terraform -v
  ```
  If Terraform is not installed, follow the steps give in the [official terraform documentation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

- Once Terraform in ensure that it is installed in the machine, jump to the directory there terraform files exist.
  ```
  cd /p41challenge/terraform
  ```
- Run the Terraform commands to plan and apply the infrastructure.
  ```
  terraform plan

  terraform apply
  ```
After deployment is completed, check the infrastructure created in the Azure resources. 


Cheers, you are done!!
Thank you!
