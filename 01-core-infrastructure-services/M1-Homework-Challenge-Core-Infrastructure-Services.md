# Homework M1: Core Infrastructure Services

Main goal is to build further on what was demonstrated during the
practice

## Tasks

Utilizing what was discussed and shown during the lecture, try to do the
following:

- Create an **Ubuntu Server 20.04** (or 22.04, or 24.04) based virtual
  machine using the **B1s** size or similar

- Add a **second hard disk** with **20 GB** in size, format it with a
  file system (i.e. **EXT4**) and mount it

- Install **Apache** web server (the package is named **apache2**) and
  make sure it is started and set to start automatically on boot

- Adjust the configuration of **Apache** (the default virtual host
  configuration is at **/etc/apache2/sites-available/000-default.conf**)
  to make it listen on port **8080** instead of port **80**

- Make sure that the service is accessible from Internet

- Create a simple **index.html** page that displays **Hello Azure**

You are free to use any approach (**Azure Portal**, **Azure CLI**,
**Azure PowerShell Module**) or a mixture of them

## Proof

Prepare a document that shows what you accomplished and how you did it.
It can include (not limited to):

- The commands you used to achieve the above tasks

- Any configuration files produced while solving the tasks

- A few pictures showing intermediary steps or results
