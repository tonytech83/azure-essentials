## Problem (Variant A)

You are expected to create the following set of resources:

![variant-a](../media/Picture1.png)

### Tasks

#### Infrastructure - 5 tasks, 12 pts

- (T101, 1 pts) Create a resource group named **RG-Solution**

  - (**1**)

- (T102, 2 pts) Create an artifact (availability set or virtual machine
  scale set) that provides high availability for virtual machines and
  name it **AS-VM**

  - (7) _RG-Solution -> Create -> **Availability Set** -> set name -> **Update domains set** to 2 -> **Create**_

- (T103, 4 pts) Create a set of **two** **Ubuntu 22.04** (or newer)
  virtual machines each with a password set as an authentication method.
  If created in an availability set, name them **VM-x**, where **x** is
  a sequence number

  - (8) _RG-Solution -> Create -> **Virtual machine** -> set name -> **Availability options** set to **Availability set** -> select created Availability set -> Security type: Standard -> Image: Ubuntu Server 24.04 -> Size: Standard_B1s -> set user and pass -> **Public inbound ports**: None -> **Networking** -> check if Virtual network is set -> set **Public IP** to None -> **Create**_
  - (9) Create **VM-2**

- (T104, 3 pts) Create a container registry with **Basic** SKU
  - (10) _RG-Solution -> Create -> **Container Registry** -> **Create**_
- (T105, 2 pts) Enable the Admin user
  - (11) \_RG-Solution -> prepexam24102025 -> **Settings** -> **Access keys** -> set Admin user

#### Networking - 5 tasks, 12 pts

- (T201, 1 pts) Create a virtual network named **NET** with address
  space **10.0.0.0/16**

  - (4) _RG-Solution -> Create -> Virtual network -> set name -> IP addresses -> edit Subnet_ -> set name -> change Starting address to requested -> Save -> Create

  - (5) _RG-Solution -> NET -> Settings -> Subnets -> select created Subnet -> select created Security group -> Save_

- (T202, 2 pts) Create a subnet named **NET-SUB-VM** with address space
  **10.0.1.0/24**

- (T203, 2 pts) Create a network security group **SG-VM**, attach it to
  the **NET-SUB-VM** subnet, and create two **inbound** rules -- one to
  allow communication on port **22/tcp** and a second one to allow
  communication on port **80/tcp**

  - (2) _RG-Solution -> Create -> Network Security Group_
  - (3) _RG-Solution -> SG-VM -> Settings -> Inbound security rules -> Add -> SSH with name port_22_ -_RG-Solution -> SG-VM -> Settings -> Inbound security rules -> Add -> HTTP with name port_80_

- (T204, 5 pts) Create an external load balancer named **LBP** with the
  corresponding set of backend pool, health probe, and load balancing
  rule that maps external port **80/tcp** to internal port **80/tcp**.
  It should have public IP address

  - (6) _RG-Solution -> Create -> Load Balancer -> set name -> Type: Public -> Frontend IP configuration -> Add -> name LBP-FE -> Public IP address create new -> Name LBP-FE-IP -> Save -> Save -> Create_

- (T205, 2 pts) Create a set of NAT rules to allow connection over SSH
  to each VM

#### Databases - 3 tasks, 7 pts

- (T301, 3 pts) Create SQL Server and a database

- (T302, 2 pts) Configure connectivity to the server

- (T303, 2 pts) Initialize the database with the help of the
  **create-structures.sql** file part of the supporting files set

#### Containers and Images - 5 tasks, 10 pts

- (T401, 2 pts) Add the SQL connection string to the **config.php** file
  in the **docker/web** folder

- (T402, 2 pts) Build the Docker image from the **Dockerfile** that is
  in the **docker** folder

- (T403, 2 pts) Tag the Docker image for the Azure Container Registry

- (T404, 2 pts) Publish the Docker image to the Azure Container Registry

- (T405, 2 pts) Create container instance of the image and make sure
  that the app is working and showing correct results

#### Software and App Deployment - 8 tasks, 19 pts

- (T501, 3 pts) Install **Apache + PHP** on all **VMs**

- (T502, 2 pts) Install **all supplementary software** on all **VMs** to
  allow them to communicate with the SQL Server database

- (T503, 3 pts) Deploy and configure (add connection string) all **php
  files** (part of the supporting files set) to all VMs

- (T504, 2 pts) Have a fully working VM-based web application

- (T505, 3 pts) Create a PHP code-based (not container-based) web
  application (App Service) \*

- (T506, 2 pts) Add the SQL connection string to the **index.php** file
  in the **webapp** folder

- (T507, 2 pts) Deploy the web application code to Azure

- (T508, 2 pts) Make sure that the web app is working and showing
  correct results
