# zurich-devops

## 1. Terraform
You can find the terraform scripts under the terraform folder. Folder contains a few files:
- provider.tf: Defines the provider (AWS in this case) and the configuration
- ecr.tf: Script to provision one or more AWS ECR
- variables.tf: Variables used by the ecr.tf script

### Steps:
1. Install terraform and AWS CLI
2. Configure your AWS CLI credentials
3. Navigate into the terraform folder
4. Run ```terraform init```
5. Run ```terraform plan```
6. Enter the names of the ECR registry you want to create in a set of string, eg ```["ecr1", "ecr2"]```
7. Once checking the output and everything looks good, run ```terraform apply``` with the same input

## 2. Reusable CI/CD Pipeline Template
You can find all the workflow yaml files for the reusable yaml template in the ```.github/workflows``` folder. 

### build.yaml 
This is a reusable pipeline CI/CD template that builds and runs unit tests of the desired application, build the docker image for the application and push it to ECR.
It supports several programming languages.
It has a ```workflow_call``` trigger and takes the few mandatory arguments below:
- language: This will be the programming language of the application. It can only take ```java```, ```nodejs``` and ```python```
- language-version: This will be the version of the programming language, i.e. if you want to use java 17, then you can enter ```17``` for this argument
- image-name: This will be the name of the image that will be built. It has to correspond to the name of the repository in ECR you want to push to
- image-version: This will be the tag of the image
- working-directory: This will be the relative path of your project from the root folder

The pipeline will first call another reusable pipeline to build and run the unit test of the application based on the programming language specified:
- java: ```maven.yaml``` will be called
- nodejs: ```nodejs.yaml``` will be called
- python: ```python.yaml``` will be called

After building and testing the application, the pipeline will finally call the ```docker-image-build.yaml``` pipeline to build the docker image and push it to ECR

Some samples of how this pipeline is used for microservices built with each programming language can be found in the following yaml files:
- ```ms-java.yaml``` for Java (application code and dockerfile can be found in ms-java folder)
- ```ms-nodejs.yaml``` for NodeJs (application code and dockerfile can be found in ms-nodejs folder)
- ```ms-python.yaml``` for Python (application code and dockerfile can be found in ms-python folder)

## 3. Branching Strategy
Below are the type of branches for a branching strategy suitable for multi-developer collaboration:

| Branch | Purpose |
| --- | --- |
| main | Stable/Production Code |
| develop | Branch for ongoing development for the next release |
| feature/* | Branch that each developer creates when they want to work on new features |
| release/* | Branch to finalize the changes that will be going to staging then to production |
| hotfix/* | Branch to fix urgent bugs in production |

Explanation:
- We will have a ```main``` branch that will be the code in production. 
- A ```develop``` branch will be created from ```main``` branch and this will be the development branch that developers will work on for the next release. 
- When a developer wants to work on a ticket, he will create a ```feature``` branch from ```develop``` branch and make his changes there. 
- Once he is done, he will need to pull latest changes from ```develop``` branch and create a PR. 
- Once the PR review is complete, the developer will merge the ```feature``` branch back into the ```develop``` branch.
- Once the ```feature``` branch is merged, the CI/CD pipeline can be run for ```develop``` branch to deploy the changes into the SIT environment
- A code freeze can be set at a specific time in the sprint so that no new features are merged into develop branch in preparation to deploy the ```develop``` branch into UAT environment.
- Once SIT testing is completed, the ```develop``` branch can be deployed to UAT environment. 
- When all development tickets for the release has been completed, a ```release``` branch can be created from ```develop``` branch to lock down the changes for the release
- This branch can be deployed into a staging/pre-prod environment so that UAT tests, smoke test or performance test can be run.
- Once the testing is completed, the ```release``` branch can be deployed into production
- If there is any production issues that needs urgent fixing, a ```hotfix``` branch can be created from the ```main``` branch
- After the fix is done, the ```hotfix``` branch can be deployed into staging/pre-prod environment for testing
- Once the fix tested successfully, the ```hotfix``` branch can be deployed into production