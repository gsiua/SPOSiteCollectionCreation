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
**To register by using AppRegNew.aspx**
  1. Navigate to http://SharePointWebsite/_layouts/15/AppRegNew.aspx on the tenancy.
  
      **AppRegNew page form**
      
      ![](https://i-msdn.sec.s-msft.com/dynimg/IC802667.png)
      
  2. Enter values for the follow form fields:
      - **Add-in ID** - Also known as client ID, is a GUID that can be generated (when you choose **Generate**). The value must be unique for each add-in, and must be lower case. The following is an example of an add-in client ID: **a5f89717-5ef9-4ee1-ac7c-5a6be65f5db7**.
      - **Add-in Secret** - Also known as the client secret, an opaque string. It is generated on the AppRegNew.aspx page by using the **Generate** button. The following is an example of an add-in secret: **7834cfGyPWrQITHSKRlhnrWzk2F6ZOUeml9h3v1znOg=**.
      - **Title** - A user-friendly title; for example, **Create Site add-in**. Users are prompted to grant or deny the add-in the permissions that the add-in is requesting. This title appears as the name of the add-in on the consent prompt.
      - **Add-in Domain** - The host name of the remote component of the SharePoint Add-in. If the remote application isn't using port 443, the add-in domain must also include the port number. The add-in domain must match the URL bindings you use for your web application. Do not include protocol ("https:") or "/" characters in this value. If your web application host is using a DNS CNAME alias, use the alias. Some examples: www.domain.com:3333, www.domain.com
      - **Redirect URI** - The endpoint in your remote application to which ACS sends an authentication code. The value must be a complete endpoint URL including the protocol, which must be HTTPS. For example: **https://www.domain.com/Pages/Default.aspx?{StandardTokens}&amp;IsDlg=1&amp;SPHasRedirectedToSharePoint=1**
      
  3. Choose Create on the form. The page will reload and show a confirmation of the values you entered. Make a record of these values in a form that is easy to copy and paste.

  4. Now you need to grant permissions to the add-in principal.  You will have to navigate to another page in SharePoint which is the **“_layouts/AppInv.aspx”**. This is where you will grant the application Tenant permissions. To do a lookup, you have to remember the client ID (also known as the add-in ID) that was used to register the add-in. The lookup returns the following information for a particular client ID.

	```XML
	<AppPermissionRequests AllowAppOnlyPolicy="true">
	  <AppPermissionRequest Scope="http://sharepoint/content/tenant" Right="FullControl" />
	</AppPermissionRequests>
	```
  5. Edit **AppManifest.xml** in **BuildPackage/Provisioning.SiteCollectionCreation.app**. Rename **Provisioning.SiteCollectionCreation.app** to **Provisioning.SiteCollectionCreation.zip**. In this package in the **AppManifest.xml** change domain example.com on your web site domain and edit **ClientId**. Return file name to **Provisioning.SiteCollectionCreation.app*.

**Web App deployment Scenarios**
  **Deploy Web App to Azure**
  1. Click button **Deploy to Azure** [![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://azuredeploy.net/) <a href="http://armviz.io/#/?load=https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/201-web-app-github-deploy/azuredeploy.json" target="_blank"><img src="http://armviz.io/visualizebutton.png"/></a>
  2. Choose web site configuration and fill **Client ID**, **Client Secret**.
  **Deploy Web App to dedicated server**
  1. Use Web Deploy module for IIS or ```XML BuildPackage/Contoso.Provisioning.SiteCollectionCreationWeb.deploy.cmd ``` for deploy on your server. Package with web app - ```XML BuildPackage/Contoso.Provisioning.SiteCollectionCreationWeb.zip ```

**Add App to App Catalog**
 For an app to be consumed, it must be added to an app catalog.

	1. Navigate to the app catalog and select Apps for SharePoint.

	2. Select New App and upload the .app file produced from the last set of steps.

# Dependencies #

- Microsoft.Online.SharePoint.Client.Tenant
- Microsoft.SharePoint.Client.dll
- Microsoft.SharePoint.Client.Runtime.dll
- [OfficeDev - Site Collection Provisioning](http://github.com/OfficeDev/PnP/blob/master/Samples/Provisioning.SiteCollectionCreation)
- [Self-Service Site Provisioning using Apps for SharePoint 2013](http://blogs.msdn.microsoft.com/richard_dizeregas_blog/2013/04/04/self-service-site-provisioning-using-apps-for-sharepoint-2013/)]
- [Setting up provider hosted add-in to Windows Azure for Office365 tenant](http://blogs.msdn.com/b/vesku/archive/2013/11/25/setting-up-provider-hosted-app-to-windows-azure-for-office365-tenant.aspx)
