# Homework M4: Azure for Developers

The main goal is to build further on what was demonstrated during the
practice

## Tasks

For this homework challenge you are expected to do the following:

1.  Create SQL Database and initialize it from the **db/seed.sql** file
    in the supporting files

2.  Get the PHP (sql extension) connection string and use it later in
    the application's code

3.  Create a container image out of the application that is included in
    the **app/** folder in the supporting files

\*For base image use **shekeriev/php:8.3-apache-sql\***

4.  Create a container registry and publish your application container
    image there

5.  Create a container instance out of the published image and see if
    the application is working as expected

Extra task: If you feel adventurous, try to extend the application, to
show the rank of the displayed city

## Proof

Prepare a document that shows what you accomplished and how you did it.
It can include (not limited to):

1.  The commands you used to achieve the above tasks

2.  Any configuration files produced while solving the tasks

3.  A few pictures showing intermediary steps or results

## Solution

1. [Azure Portal](./01-portal/portal.md)

2. [Azure CLI](./02-azure-cli/azure-cli.md)

3. [Terraform](./03-terraform/terraform.md)
