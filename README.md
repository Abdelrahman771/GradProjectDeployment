# ITI DevOps Track Graduation Project

Created by: [Abdelrahman Ahmed Ali](https://www.linkedin.com/in/abdelrahman-ahmed-67bb091b0/)

this project's purpose is to deploy a simple Nodejs app in K8s cluster using Jenkins deployed in the same K8s cluster 

## Our deployment would be look like this

![General Deployment](Images/General-Deployment.jpeg)

 we will use this **AWS** infrastructure to deploy our application using Terraform

## Required Infrastructure

![Required Infra](Images/Terraform-Infra.jpeg)

## Deploy our app in EKS(Elastic Kubernetes Service) in AWS

1. Create this infra

   - a VPC
   - at least one public subnet and 2 private subnets
   - Internet Gateway & NAT Gateway
   - one Bastion host
   - one EKS cluster with a Node group

    To deploy this infra we enter those commands in terminal

    ```bash
    terraform init
    terraform apply -auto-aprove
    ```

    **(Note):** in this project we will use Bastion host to install Docker daemon in worker nodes because we EKS latest version "1.24" and it don't have Docker engine like the previous versions

2. Build and push custom jenkins image with Kubectl and docker client to Dockerhub

    ```bash
    cd ./JenkinsInK8s
    docker login
    docker build . -f Dockerfile -t <your-username-in-dockerhub>/jenkins:v1.0
    docker push <your-username-in-dockerhub>/jenkins:v1.0
    ```

3. connect to EKS created cluster

   ```bash
   aws eks --region <region-of-deployed-cluster> update-kubeconfig --name <cluster-name>
   ```

4. install docker engine in worker nodes with Bastion host using ansible

   1. edit ip address and path of the private key of the bastion host and worker nodes in Ansible-files/inventory.ini

   2. edit ip address and path of the private key of bastion host in ~/.ssh/config

   3. apply this playbook with this command

        ```bash
        cd /Ansible-files
        ansible-playbook playbook.yml -i inventory.txt 
        ```

5. deploy our custom jenkins in our EKS cluster

    ```bash
    cd /JenkinsInK8s
    kubectl apply -f .
    kubectl apply -f . #in case the first apply didn't run will
    ```

    then to get url (External IP address) of the exposed jenkins pod we run this command

    ```bash
    kubectl get svc -n jenkins-ns
    ```

    and using this url in our browser the result will be like that

    ***Link:*** <http://aca8496a28e8f4b0cb20b09e062ea548-702571183.us-east-1.elb.amazonaws.com//>

    **output**

    ![Jenkins in EKS](Images/Jenkins.png)

6. Add dockerhub and github credintials in Jenkins agent
7. create pipeline with the provided jenkinsfile which

   - clone app and it's deployment files from [Abdelrahman771/GradprojectApp](https://github.com/Abdelrahman771/GradprojectApp)
   - build image for it
   - push it to container registery (Dockerhub)
   - apply deployment files using kubectl tool

8. start building pipeline and access console output to get link of the deployed app

    ***Link:*** <http://a4b61d05532be409ab0ce926650a0dec-1580022158.us-east-1.elb.amazonaws.com:3000//>

   **output**

   ![Nodejs output](Images/Resault.png)

## cleanup

1. create new pipeline in jenkins to delete app deployment using jenkinsfile-RemoveAPP
2. then in your local machine in JenkinsInK8s

   ```bash
   cd /JenkinsInK8s
   kubectl delete -f .
   ```

3. Destroy Terraform Infra

   ```bash
   terraform destroy
   ```