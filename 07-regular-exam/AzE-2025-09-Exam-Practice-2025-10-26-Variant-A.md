# Exam: AzE 2025.09 -- 26.10.2025 (Variant A) {#exam-aze-2025.09-26.10.2025-variant-a}

## Rules

- Be sure to follow exactly the **IP addresses**, **resource names, file
  names, etc.** as requested in the tasks

- Tasks execution order should not be derived from the order in which
  they are listed below

- Тhere are tasks that depend on the successful completion of one or
  more other tasks

- All resources are expected to be in **one region** (of your choice).
  If you deviate from this, state the reason(s)

- If not stated explicitly, use the smallest and cheapest possible
  resource option that will do the job

- Feel free to set up public IP addresses or other options to virtual
  machines or other resources for debugging purposes

- **The aim is]{.underline}** not to build a production-ready solution
  but a **working one]{.underline}**

**_NOTE: This document has 3 pages]{.underline}. Make sure you read
all of them]{.underline}_**

## Goal

You are expected to create the following set of resources:

!Picture1](./media/Picture1.png)

### Tasks

#### Infrastructure and Organization - 12 pts

- (T101, 1 pts) Create a resource group named **RG-SolutionA**

- (T102, 2 pts) Create an aligned availability set and name it
  AS-VM

- (T103, 4 pts) Create a set of **two** **Ubuntu 22.04** (or newer)
  virtual machines, each with a password set as an authentication
  method. Name them **VM-x**, where **x** is the sequence number

- (T104, 2 pts) Create a container registry with **Basic** SKU

- (T105, 1 pts) Enable the **Admin** user in the registry

- (T106, 1 pts) Add a tag **purpose** with value **exam** on the
  container registry

- (T107, 1 pts) Add a **CanNotDelete** (**Delete**) lock on the
  container registry and name it **Exam-Lock**

#### Networking - 12 pts

- (T201, 1 pts) Create a virtual network named **NET** with address
  space **10.0.0.0/16**

- (T202, 1 pts) Create a subnet named **NET-SUB-VM** with address space
  **10.0.1.0/24**

- (T203, 1 pts) Create a network security group **SG-VM** and attach it
  to the **NET-SUB-VM** subnet and create two **inbound** rules:

  - (T203.1, 1 pts) one, named **Rule-SSH**, to allow communication on
    port **22/tcp**

  - (T203.2, 1 pts) and a second one, named **Rule-HTTP**, to allow
    communication on port **80/tcp**

- (T204, 1 pts) Create an external load balancer named **LBP** with the
  corresponding set of

  - (T204.1, 1 pts) frontend configuration, named **LBP-FE**, with a
    public IP address, named **LBP-IP**

  - (T204.2, 1 pts) backend pool, named **LBP-BEP**

  - (T204.3, 1 pts) health probe, named **LBP-HP**

  - (T204.4, 1 pts) and load balancing rule, named **LBP-RULE**, that
    maps external port **80/tcp** to internal port **80/tcp**

- (T205, 2 pts) Add a set of NAT rules to the load balancer to allow
  connection over SSH to each VM and name them **LBP-NAT-SSH-1** and
  **LBP-NAT-SSH-2**. Create also an outbound rule (**LBP-OUT**) if
  needed

#### Databases - 6 pts

- (T301, 3 pts) Create SQL Server and a database

- (T302, 2 pts) Configure connectivity to the server

- (T303, 1 pts) Initialize the database from the
  **db/create-structures.sql** file

#### Containers and Images - 8 pts

- (T401, 1 pts) Add the SQL connection string to the **config.php**
  file in the **app4/web** folder

- (T402, 1 pts) Build the container image from the Dockerfile that is
  in the app4 folder

- (T403, 1 pts) Tag the container image for the Azure Container
  Registry

- (T404, 1 pts) Publish the container image to the Azure Container
  Registry

- (T405, 2 pts) Create container instance out of the image

- (T406, 2 pts) Make sure that the app is working and showing correct
  results

#### Software and App Deployment - 22 pts

##### Apps on VMs

- (T501, 2 pts) Install **Apache + PHP** on the **VMs**

- (T502, 2 pts) Install **the required software** on the **VMs** that
  will allow them to work with the SQL Server database

- (T503, 2 pts) Add the SQL connection string to the **config.php**
  file in the **app1** folder

- (T504, 2 pts) Deploy the application (**app1**) to the VMs

- (T505, 2 pts) Have a fully working VM-based web application reachable
  via the load balancer

##### Web Apps

- (T506, 2 pts) Create a Linux-based App Service Plan, name it
  **ASP-LINUX**, and select either **F1** or **B1** pricing plan

- (T507, 1 pts) Create a **PHP** code-based web application utilizing
  the existing service plan

  - (T507.1, 1 pts) Make sure the **basic authentication** is
    enabled

  - (T507.2, 1 pts) Deploy the web application (**app2**) code to
    Azure

  - (T507.3, 1 pts) Make sure that the web app is working and showing
    correct results

- (T508, 1 pts) Create a **PHP** code-based web application utilizing
  the existing service plan

  - (T508.1, 1 pts) Make sure the **basic authentication** is
    enabled

  - (T508.2, 1 pts) Add the SQL connection string to the **config.php**
    file in the **app3** folder

  - (T508.3, 1 pts) Deploy the web application (**app3**) code to
    Azure

  - (T508.4, 2 pts) Make sure that the web app is working and showing
    correct results

## Proof

Prepare a short document that describes clearly and concisely all the
significant steps that led to your solution

It is **mandatory]{.underline}** to include **pictures of the working
applications** (each one of them)

It is **mandatory]{.underline}** to include an **exported
visualization of the solution**. Go to the **Resource group** \>
**Resource visualizer**, click the **Export** button and select the
**High** or **Best quality** option for the format you want. Note that
you may need to click the **Refresh** button first, and then the **Zoom
to fit** button

It is **mandatory]{.underline}** to include an **exported template of
the solution**. Go to the **Resource group** \> **Automation** \>
**Export template** and click the **Download** button

Feel free to include additional information, pictures, and any
supporting files

## Clean up

Once you are done and you upload the solution, don't forget to delete
(mind the locks) all resources that you won't need
