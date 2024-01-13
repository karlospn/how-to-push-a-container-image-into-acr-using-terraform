# How to push a container image to Azure Container Registry (ACR) using Terraform

This repository shows you a 3 ways to push a container image to Azure Container Registry using Terraform

# **Pre-Requisites**

- An ACR with admin user and password enabled.

In the ``/prereqs`` folders you'll find a Terraform that create the ACR and also a Resource Group.

# **Content**

## **Using the Terraform Docker provider**

> You can find this scenario source code in ``/src/using_docker_provider`` folder.

This scenario utilizes the Terraform Docker provider to built the application image and push it to the Azure Container Registry (ACR). It provider uses the ACR admin user and password for logging into the ACR.

This is not an official Terraform provider built by Docker. There isn't an official one in existence. It has a few quirks, but it is well-built overall.    
Here's the link to the provider if you want to take a look: 

- https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs


## **Using the Terraform null_resource resource alongside with the AZ CLI**

> You can find this scenario source code in ``/src/using_null_resource_with_az_cli`` folder.

This scenario utilizes the Terraform ``null_resource`` resource to execute a series of AZ CLI commands to built the application image and push it to the Azure Container Registry (ACR). 

## **Using the Terraform null_resource resource and Docker commands**

> You can find this scenario source code in ``/src/using_null_resource_with_docker_commands`` folder.

This scenario utilizes the Terraform ``null_resource`` resource to execute a series of Docker commands to built the application image and push it to the Azure Container Registry (ACR). 