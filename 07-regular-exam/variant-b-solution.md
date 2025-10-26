## Solution - Variant B

- Create a resource group named **RG-SolutionB**

```sh
az group create \
--name RG-SolutionB \
--location northeurope
```

- Create a **Container registry** with Basic SKU

```sh
az acr create \
--resource-group RG-SolutionB \
--name examprepcr \
--sku Basic \
--admin-enabled true \
--public-network-enabled true \
--tags purpose=exam
```

- Add a **CanNotDelete (Delete)** lock on the container registry and name it **Exam-Lock**

```sh
az lock create \
--name Exam-Lock \
--lock-type CanNotDelete \
--resource-group RG-SolutionB \
--resource-name examprepcr \
--resource-type "Microsoft.ContainerRegistry/registries"
```

- Create an **Azure Kubernetes Service** resource with one node of smallest size you see fit

```sh
az aks create \
--resource-group RG-SolutionB \
--name exam-k8s \
--location northeurope \
--node-count 1 \
--node-vm-size Standard_L2as_v4 \
--nodepool-name agentpool \
--os-sku Ubuntu \
--zones 1 2 3 \
--kubernetes-version 1.32.7 \
--enable-managed-identity \
--generate-ssh-keys \
--attach-acr examprepcr \
--tier free
```

- Create **SQL Server**

```sh
az sql server create \
--resource-group RG-SolutionB \
--name exam-sql-server \
--location northeurope \
--admin-user tonytech \
--admin-password "New_1234512345"
```

- Create **Database**

```sh
az sql db create \
--resource-group RG-SolutionB \
--server exam-sql-server \
--name DB \
--edition Basic \
--backup-storage-redundancy Local
```

- Configure connectivity to the **SQL server**

```sh
# Allow Azure services to access the server
az sql server firewall-rule create \
--resource-group RG-SolutionB \
--server exam-sql-server \
--name AllowAzureServices \
--start-ip-address 0.0.0.0 \
--end-ip-address 0.0.0.0

# Allow current client IP to access the server
az sql server firewall-rule create \
--resource-group RG-SolutionB \
--server exam-sql-server \
--name AllowClientIP \
--start-ip-address $(curl -s ifconfig.me) \
--end-ip-address $(curl -s ifconfig.me)
```

- Initialize the database from the `variant-b/db/create-structures.sql` file

```sh
sqlcmd -S exam-sql-server.database.windows.net \
       -d DB \
       -U tonytech \
       -P "New_1234512345" \
       -C \
       -i variant-b/db/create-structures.sql
```

- Add the SQL connection string to the `index.php` file in the `variant-b/app1/web` folder

  > Take the PHP connection string form: **Resource group** -> **Database** -> **Settings** -> **Connection strings** -> **PHP** tab

- Build the container image from the **Dockerfile** that is in the **app1** folder

```sh
docker build . -t php-app
```

- Tag the Docker image for the **Azure Container Registry**

```sh
docker tag php-app examprepcr.azurecr.io/php-app:v1
```

- Login to just created **Azure Container registry**

```sh
az acr login --name examprepcr
```

- Push the image to remote registry

```sh
docker push examprepcr.azurecr.io/php-app:v1
```

- Adjust the deployment.yaml file in the app1/manifests folder to point to the published image

- Download cluster credentials
  > **Resource group** -> **Kubernetes cluster** -> **Connect**

```sh
az aks get-credentials --resource-group RG-SolutionB --name exam-k8s --overwrite-existing
```

- Publish the manifests to the Kubernetes cluster (Azure Kubernetes Service)

```sh
kubectl apply -f deployment.yaml -f service.yaml
```

- Make sure that the app is working and showing correct results
  > Take the IP address of service > Kubernetes service -> Kubernetes resources -> Services and ingresses -> filter by **default** namespace

![variant-b-pic-1](./media/variant-b-pic-1.png)

- Create a Linux-based **App Service Plan**, name it ASP-LINUX, and select either **F1** or **B1** pricing plan

```sh
az appservice plan create \
--name asp-exam \
--resource-group RG-SolutionB \
--location northeurope \
--sku B1 \
--is-linux
```

- Create a **PHP** code-based web application utilizing the existing service plan for **app2**

```sh
az webapp create \
--resource-group RG-SolutionB \
--plan asp-exam \
--name exam-web-app2 \
--runtime "PHP|8.3" \
--basic-auth Enabled
```

- Take SFTP settings for connection to **app2**

```sh
az webapp deployment list-publishing-profiles \
--name exam-web-app2 \
--resource-group RG-SolutionB \
--query "[?publishMethod=='FTP'].[publishUrl,userName,userPWD]" \
--output tsv
```

- Deploy the files inside `variant-b/app2` with SFTP client to Web App server with name `exam-web-app2`

- Take FQDN of `exam-web-app2`

```sh
az webapp show \
--name exam-web-app2 \
--resource-group RG-SolutionB \
--query defaultHostName \
-o tsv

exam-web-app2.azurewebsites.net
```

- Make sure that the web app is working and showing correct results

![variant-b-pic-2](./media/variant-b-pic-2.png)

- Create a **PHP** code-based web application utilizing the existing service plan for **app3**

```sh
az webapp create \
--resource-group RG-SolutionB \
--plan asp-exam \
--name exam-web-app3 \
--runtime "PHP|8.3" \
--basic-auth Enabled
```

- Add the SQL connection string to the `variant-b\app3\index.php` file

- Take SFTP settings for connection to **app3**

```sh
az webapp deployment list-publishing-profiles \
--name exam-web-app3 \
--resource-group RG-SolutionB \
--query "[?publishMethod=='FTP'].[publishUrl,userName,userPWD]" \
--output tsv
```

- Deploy the files inside `variant-a/app3` with SFTP client to Web App server with name `exam-web-app3`

- Take FQDN of `exam-web-app3

```sh
az webapp show \
--name exam-web-app3 \
--resource-group RG-Solutionb \
--query defaultHostName \
-o tsv

exam-web-app3.azurewebsites.net
```

- Make sure that the web app is working and showing correct results

![variant-b-pic-3](./media/variant-b-pic-3.png)

- Build the container image from the **Dockerfile** that is in the **app4** folder

```sh
docker build . -t app4
```

- Tag the container image for the Azure Container Registry

```sh
docker tag app4 examprepcr.azurecr.io/app4:v1
```

- Publish the container image to the Azure Container Registry

```sh
docker push examprepcr.azurecr.io/app4:v1
```

- Take **Azure Container registry** password

```sh
export ACR_PASSWORD="$(az acr credential show --name examprepcr --query 'passwords[0].value' -o tsv | tr -d '\r\n')"
```

- Create container instance out of the image

```sh
az container create \
--resource-group RG-SolutionB \
--name exam-container \
--image examprepcr.azurecr.io/app4:v1 \
--dns-name-label exam-app4 \
--ports 80 \
--os-type linux \
--cpu 1 \
--memory 1.5 \
--location northeurope \
--registry-login-server examprepcr.azurecr.io \
--registry-username examprepcr \
--registry-password "$ACR_PASSWORD"
```

- Take **FQDN** of container

```sh
az container show -g RG-SolutionB -n exam-container --query "{FQDN:ipAddress.fqdn}"

{
  "FQDN": "exam-app4.northeurope.azurecontainer.io"
}
```

- Make sure that the app is working and showing correct results

![variant-b-pic-4](./media/variant-b-pic-4.png)

- Create a code-based **Function App** with **.NET 8 (LTS) in-process model** as runtime

  > Go to Resource group -> Create -> Function App -> Consumption -> set name: examprepfa -> Runtime stack: .NET -> Version: 8(LTS), in-process model -> Region: North Europe -> **Deployment -> Basic authentication: \***Enable\*\*\* -> Create

- Take Connection string for ADO.NET (SQL authentication)

- Create an application setting/variable that holds the connection string for the database

  > Go to Function App -> Settings -> Environment variables -> Connection strings -> Add -> Name: SQLConnectionString -> Value: SQL connection string from above -> Type: SQLAzure -> Apply -> Apply -> Confirm

- Create a **Timer triggered** function, named **ExamTimerTrigger**

  > Go to Function App -> Create function -> Select a template: Timer trigger -> Function name: ExamTimerTrigger -> Schedule: 0 \*/2 \_ \* \* \*

- Set Integration

  > Integration -> Outputs -> Add output -> Binding Type: Azure SQL Output Binding -> Name: submittedItem -> Table Name: SubmittedItems -> SQL Connection string setting -> ConnectionString -> Add

- Paste code in **Code + Test**

```csharp
#r "Newtonsoft.Json"

using System.Net;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Primitives;
using Newtonsoft.Json;

public class SubmittedItem
{
  public string SubmittedName { get; set; }
}

public static void Run(TimerInfo myTimer, ILogger log, out SubmittedItem submittedItem)
{
  log.LogInformation($"C# Timer trigger function executed at: {DateTime.Now}");
  submittedItem = new SubmittedItem();
  submittedItem.SubmittedName = "TIMER";
}
```

- Create an **HTTP triggered** function, named **ExamHTTPTrigger**

  > Go to Function App -> Create function -> Select a template: HTTP Trigger -> Function name: ExamHTTPTrigger -> Authorization level: Function -> Create

- Set **Integration**

  > Integration -> Outputs -> Add output -> Binding Type: Azure SQL Output Binding -> Name: submittedItem -> Table Name: SubmittedItems -> SQL Connection string setting -> ConnectionString -> Add

- Paste code in **Code + Test**

```csharp
#r "Newtonsoft.Json"

using System.Net;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Primitives;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

public class SubmittedItem
{
    public string SubmittedName { get; set; }
}

public static IActionResult Run(HttpRequest req, ILogger log, out SubmittedItem submittedItem)
{
    log.LogInformation("C# HTTP trigger function processed a request.");

    string name = req.Query["name"];

    submittedItem = new SubmittedItem();
    submittedItem.SubmittedName = string.IsNullOrEmpty(name) ? "EMPTY" : name;

    string responseMessage = string.IsNullOrEmpty(name)
        ? "This HTTP triggered function executed successfully. Pass a name in the query string."
        : $"This HTTP triggered function executed successfully. It was called with name={name}.";

    return new OkObjectResult(responseMessage);
}
```

- Execute the function at least once without parameter, and at least once with **item=EXAM**

![variant-b-pic-5](./media/variant-b-pic-5.png)

## Resource visualizer

![Resource visualizer](./media/RG-SolutionB.png)

- Remove the Lock

```sh
az lock delete \
--name Exam-Lock \
--resource-group RG-SolutionB \
--resource-name examprepcr \
--resource-type "Microsoft.ContainerRegistry/registries"
```

- Delete the **Resource group**

```sh
az group delete --name RG-SolutionB --yes --no-wait
```
