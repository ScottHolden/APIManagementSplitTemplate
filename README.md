# API Management Split Template Example

A quick example of splitting up swagger, policy, and template within a deployment, using file based environment parameters.

- `swagger.json` - API Swagger Def
- `policy.xml` - API Level Policy
- `azure.template.json` - ARM Template
- `azure.parameters.<environment>.json` - Per Environment ARM Template Parameters
- `deploy.ps1` - Powershell Deployment Script


## To deploy: 
- Spin up an API Management instance, make note of the `Subscription Id`, `Resource Group Name`, and `API Management Name` to use below
- Check the details within the 'dev' environment parameters file:
    - `apiManagementServiceName` should be set to the resource name of your API Management service
- `.\deploy.ps1 -SubscriptionId "sub-id-here" -ResourceGroup "resource-group-here" -Environment "dev"`