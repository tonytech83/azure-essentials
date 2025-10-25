## Problem (Variant B)

You are expected to create the following set of resources:

![variant-b](../media/Picture2.png)

### Tasks

#### Infrastructure - 5 tasks, 14 pts

- (T101, 1 pts) Create a resource group named **RG-SolutionB**

- (T102, 3 pts) Create a container registry with **Basic** SKU

- (T103, 2 pts) Enable the Admin user

- (T104, 6 pts) Create an Azure Kubernetes Service resource with **one
  node** of size **B2s**

- (T105, 2 pts) **Link** the ACR to the AKS

#### Containers and Images - 7 tasks, 17 pts

- (T201, 2 pts) Add the SQL connection string to the **index.php** file
  in the **docker/web** folder

- (T202, 2 pts) Build the Docker image from the **Dockerfile** that is
  in the **docker** folder

- (T203, 2 pts) Tag the Docker image for the Azure Container Registry

- (T204, 2 pts) Publish the Docker image to the Azure Container Registry

- (T205, 3 pts) Adjust the **deployment.yaml** file in the **manifests**
  folder to point to the published Docker image

- (T206, 3 pts) Publish the manifests to the Kubernetes cluster (Azure
  Kubernetes Service)

- (T207, 3 pts) Make sure that the app is working and showing correct
  results

#### Databases - 3 tasks, 7 pts

- (T301, 3 pts) Create SQL Server and a database

- (T302, 2 pts) Configure connectivity to the server

- (T303, 2 pts) Initialize the database with the help of the
  **create-structures.sql** file part of the supporting files set

#### Web Apps and Functions - 8 tasks, 22 pts

- (T401, 3 pts) Create a PHP code-based (not container-based) web
  application (App Service) \*

- (T402, 2 pts) Add the SQL connection string to the **index.php** file
  in the **webapp** folder

- (T403, 2 pts) Deploy the web application code to Azure

- (T404, 2 pts) Make sure that the web app is working and showing
  correct results

- (T405, 3 pts) Create a code-based **Function App** with **.NET Core**
  as runtime \*

- (T406, 3 pts) Create a **Timer triggered** function. It must execute
  **every two minutes** and insert a row with **SubmittedName=TIMER** in
  the database (table **SubmittedItems**)

- (T407, 5 pts) Create an HTTP **triggered** function. When executed it
  must accept a single parameter (**name**) and store the value in the
  database (table **SubmittedItems**). If, however, executed without
  one, it should store an item with the label **EMPTY**

- (T408, 2 pts) Make sure that you have executed the HTTP triggered
  function successfully several times with various values for the
  parameter. For example, **EXAM**, **TEST**, etc.

_\* Note that you may need to create an additional resource group(s)_

## Clean up

Don't forget to stop and delete all resources that you won't need

You can delete a resource group with all referenced resources directly

If you have any doubts, visit the **All resources** option in **Azure
Portal** to check if there are any unnecessary resources left and delete
them manually

### _Solution_

- Create a resource group named **RG-SolutionB**

```sh
az login

az group create \
--name RG-SolutionB \
--location northeurope
```

- Create a **Container registry** with **Basic** SKU
