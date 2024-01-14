# How to push a container image to Azure Container Registry (ACR) using Terraform

This repository provides three available options for pushing a container image to Azure Container Registry using Terraform.

# **Pre-Requisites**

- An ACR with admin user and password enabled.

In the ``/prereqs`` folder you'll find a set of Terraform files that creates a **Resource Group**, an **ACR** and also an **Azure Linux Service Plan**.

The Azure Service Plan has been created to test the image pushed to ACR using Terraform. If you prefer an alternative to Azure Web Apps, you can replace it with another service, such as Azure Container Apps, and it will work in the same manner.

# **Content**

## **Using the Terraform Docker provider**

> You can find this scenario source code in ``/src/using_docker_provider`` folder.

This scenario utilizes the **Terraform Docker provider** to built the application image and push it to the Azure Container Registry (ACR). The Terraform Docker provider uses the ACR admin user and password to login into the ACR.

This scenario also creates an Azure Web App that uses the image that has been pushed, allowing us to test it in a live environment.

Let me make a remark here, **this is not an official Terraform provider built by Docker**. There isn't an official one in existence. This is a provider built by some external company, it has a few quirks, but it is well-built overall.    

To execute this scenario, you'll need to have Docker installed and running on your local machine or wherever you choose to run it.

Here's the link to the provider if you want to take a look: 

- https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs


## **Using the Terraform null_resource resource alongside with the AZ CLI**

> You can find this scenario source code in ``/src/using_null_resource_with_az_cli`` folder.

This scenario utilizes the Terraform ``null_resource`` resource to execute a series of AZ CLI commands to built the application image and push it to the Azure Container Registry (ACR). 

The AZ CLI command executed in this scenario is the ``az acr build`` command.
```bash
az acr build --registry
             [--agent-pool]
             [--auth-mode {Default, None}]
             [--build-arg]
             [--file]
             [--image]
             [--log-template]
             [--no-format]
             [--no-logs]
             [--no-push]
             [--no-wait]
             [--platform]
             [--resource-group]
             [--secret-build-arg]
             [--target]
             [--timeout]
             [<SOURCE_LOCATION>]

```

This command queues a job in ACR that builds and pushes the image into the ACR.

- **However, what's the advantage of this scenario over the previous one?**

The ``null_resource`` is typically more complex to use and is often considered a last resort in Terraform workflows.    
In this case, the benefit of using it alongside the ``az acr build`` command is that it allows us to execute it on a machine that doesn't have Docker installed. This is because the ``az acr build`` command simply queues a build job within the ACR, eliminating the need to have Docker installed on your local machine.

![az-acr-build-command-example](https://raw.githubusercontent.com/karlospn/how-to-push-a-container-image-into-acr-using-terraform/main/docs/terraform-push-app-az-acr-build-command.png)

Another advantage of using this scenario is that you don't need to enable the admin user and password on the ACR, addressing a common security concern.     
To run the ``az acr build`` command, you need at least to have the ``Contributor`` role in Azure.

This scenario, similar to the previous one, creates an Azure Web App that uses the image that has been pushed, allowing us to test it in a live environment.

## **Using the Terraform null_resource resource and Docker commands**

> You can find this scenario source code in ``/src/using_null_resource_with_docker_commands`` folder.

This scenario employs the Terraform ``null_resource`` resource to execute a sequence of Docker commands for building the application image and pushing it to the Azure Container Registry (ACR).

To be more specific, it executes the following Docker commands:

- ``docker build``: Used to build the container app image.
- ``docker login``: Used for login into the ACR. To login, it uses the ACR admin user and password.
- ``docker push:`` Used to push the image into the ACR.

**And what's the advantage of this scenario over the previous one?** In my opinion, there is no advantage; I consider this the least preferable of the three scenarios. I would opt to run the other two scenarios before considering this one.

This scenario, similar to the previous ones, creates an Azure Web App that uses the image that has been pushed, allowing us to test it in a live environment.
