# SharePoint Online. Site Collection Provisioning


### Summary ###
Solution for create site collections through a customization form using CSOM for Office 365 from provider hosted add-in. This solution based on examples [OfficeDev - Site Collection Provisioning](http://github.com/OfficeDev/PnP/blob/master/Samples/Provisioning.SiteCollectionCreation), [Self-Service Site Provisioning using Apps for SharePoint 2013](http://blogs.msdn.microsoft.com/richard_dizeregas_blog/2013/04/04/self-service-site-provisioning-using-apps-for-sharepoint-2013/)] and [Tenant extensions](https://github.com/OfficeDev/PnP-Sites-Core/tree/master/Core/OfficeDevPnP.Core/AppModelExtensions).

### Applies to ###
-  Office 365 Multi Tenant (MT)

### Solution ###
Solution | Author(s)
---------|----------
Provisioning.SiteCollectionCreation | Yuliia Afanasenko, Ivan Kalinichenko - GSI & Donetsk National University
 
### Version history ###
Version  | Date | Comments
---------| -----| --------
1.0  | March 30th 2016 (to update) | Initial release

### Disclaimer ###
**THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.**

----------

# Installation #
**To register SharePoint App**
  1. Before this step, you must have App's Catalog, If it's not exist, you must create it. Navigate to your SharePoint tenancy app's catalog and add to catalog URL **/_layouts/15/AppRegNew.aspx**. For example: ```https://<YOUR-APP-CATALOG-URL>/_layouts/15/AppRegNew.aspx```
  
      **AppRegNew page form**
      
      ![](https://i-msdn.sec.s-msft.com/dynimg/IC802667.png)
      
  2. Enter values for the follow form fields:
      - **Client ID** - Choose **Generate**.
      - **Client Secret** - Choose **Generate**.
      - **Title** - A user-friendly title. For example: **Create Site add-in**.
      - **App Domain** - The host name of the Web App. Web App - remote component of the SharePoint App. **Go to step "Deploy Web App to Azure", after you finished this step, you will have generated Web App host name. For example: <YOU-SITE-NAME>.azurewebsites.net**
      - **Redirect URI** - The value must be a complete endpoint URL to your Web App including the protocol, which must be HTTPS. For example: **https://<YOU-SITE-NAME>.azurewebsites.net/Pages/Default.aspx?{StandardTokens}&amp;IsDlg=1&amp;SPHasRedirectedToSharePoint=1**. **You must replace only <YOU-SITE-NAME> in this url**
      
  3. Choose **Create** on the form. The page will reload and show a confirmation of the values you entered. **Make a record of these values in a form that is easy to copy and paste to your notepad.** Then click **OK**.

  4. Now you need to grant permissions to the app principal. You will have to navigate to another page which is the **/_layouts/AppInv.aspx**. For example: ```https://<YOUR-APP-CATALOG-URL>/_layouts/AppInv.aspx```. Paste your client ID, which you generated early and click **lookup**. The lookup returns the following information for a particular client ID. Past code below without changes.

	```XML
	<AppPermissionRequests AllowAppOnlyPolicy="true">
	  <AppPermissionRequest Scope="http://sharepoint/content/tenant" Right="FullControl" />
	</AppPermissionRequests>
	```
  5. Edit **AppManifest.xml**:
  	- Download **[Provisioning.SiteCollectionCreation.app](https://github.com/gsiua/SPOSiteCollectionCreation/blob/master/BuildPackage/Provisioning.SiteCollectionCreation.app)** from current repository (Click "View Raw").
  	- Rename file extensions from app to zip (**Provisioning.SiteCollectionCreation.app** to **Provisioning.SiteCollectionCreation.zip**). 
  	- Open this archive and copy **AppManifest.xml** to your Desktop Folder or other computer's folder. 
  	- Edit this file, replace URI in the ```<Start Page>YOUR-REDIRECT-URI</Start Page>``` section to your Redirect URI, which was generated early.
  	- Replace **ClientId** to your Client ID, which was generated early.
  	- Copy changed **AppManifest.xml** to archive **Provisioning.SiteCollectionCreation.zip**
  	- Return file extensionto app (name must be **Provisioning.SiteCollectionCreation.app**)
  6. **Add App to App Catalog**
 	For an app to be consumed, it must be added to an app catalog.
	- Navigate to the app catalog and select Apps for SharePoint.
	- Select New App and upload the **Provisioning.SiteCollectionCreation.app** file.

  **Deploy Web App to Azure**
  1. Click button **Deploy to Azure** [![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://azuredeploy.net/) <a href="http://armviz.io/#/?load=https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/201-web-app-github-deploy/azuredeploy.json" target="_blank"><img src="http://armviz.io/visualizebutton.png"/></a>
  2. Choose web site configuration and fill **Client ID**, **Client Secret**.
  
  **Deploy Web App to dedicated server**
  1. Use Web Deploy module for IIS or **[Contoso.Provisioning.SiteCollectionCreationWeb.deploy.cmd](https://github.com/gsiua/SPOSiteCollectionCreation/blob/master/BuildPackage/Contoso.Provisioning.SiteCollectionCreationWeb.deploy.cmd)** for deploy on your server. Package with web app - **[Contoso.Provisioning.SiteCollectionCreationWeb.zip](https://github.com/gsiua/SPOSiteCollectionCreation/blob/master/BuildPackage/Contoso.Provisioning.SiteCollectionCreationWeb.zip)**

# Dependencies #

- Microsoft.Online.SharePoint.Client.Tenant
- Microsoft.SharePoint.Client.dll
- Microsoft.SharePoint.Client.Runtime.dll
- [OfficeDev - Site Collection Provisioning](http://github.com/OfficeDev/PnP/blob/master/Samples/Provisioning.SiteCollectionCreation)
- [Self-Service Site Provisioning using Apps for SharePoint 2013](http://blogs.msdn.microsoft.com/richard_dizeregas_blog/2013/04/04/self-service-site-provisioning-using-apps-for-sharepoint-2013/)]
- [Setting up provider hosted add-in to Windows Azure for Office365 tenant](http://blogs.msdn.com/b/vesku/archive/2013/11/25/setting-up-provider-hosted-app-to-windows-azure-for-office365-tenant.aspx)
