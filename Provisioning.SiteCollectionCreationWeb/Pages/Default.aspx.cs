using Microsoft.Online.SharePoint.TenantAdministration;
using Microsoft.SharePoint.Client;
using OfficeDevPnP.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Security;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Contoso.Provisioning.SiteCollectionCreationWeb
{
    public partial class Default : System.Web.UI.Page
    {
        bool flag = false;

        protected void Page_PreInit(object sender, EventArgs e)
        {

            Uri redirectUrl;
            switch (SharePointContextProvider.CheckRedirectionStatus(Context, out redirectUrl))
            {
                case RedirectionStatus.Ok:
                    return;
                case RedirectionStatus.ShouldRedirect:
                    Response.Redirect(redirectUrl.AbsoluteUri, endResponse: true);
                    break;
                case RedirectionStatus.CanNotRedirect:
                    Response.Write("An error occurred while processing your request.");
                    Response.End();
                    break;
            }

        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // define initial script, needed to render the chrome control
            string script = @"
            function chromeLoaded() {
                $('body').show();
            }

            //function callback to render chrome after SP.UI.Controls.js loads
            function renderSPChrome() {
                //Set the chrome options for launching Help, Account, and Contact pages
                var options = {
                    'appTitle': document.title,
                    'onCssLoaded': 'chromeLoaded()'
                };

                //Load the Chrome Control in the divSPChrome element of the page
                var chromeNavigation = new SP.UI.Controls.Navigation('divSPChrome', options);
                chromeNavigation.setVisible(true);
            }";

            //register script in page
            Page.ClientScript.RegisterClientScriptBlock(typeof(Default), "BasePageScript", script, true);

            var tenantStr = Page.Request["SPHostUrl"].ToLower().Replace("-my", "").Substring(8);
            tenantStr = tenantStr.Substring(0, tenantStr.IndexOf("."));
            var webUrl = String.Format("https://{0}.sharepoint.com/{1}/", tenantStr, "teams");
            lblBasePath.Text = webUrl;

            if (!flag)
            {
                btnCreate.Enabled = false;
            }
            btnCancel.Attributes.Add("onclick", "javascript:closeDialog();return false;");
            if (!this.IsPostBack)
            {
                //configure buttons based on display type
                if (Page.Request["IsDlg"] == "1")
                    btnCancel.Attributes.Add("onclick", "javascript:closeDialog();return false;");
                else
                    btnCancel.Click += btnCancel_Click;
            }
        }

        protected void ExistSite_TextChanged(object sender, EventArgs e)
        {
            var tenantStr = Page.Request["SPHostUrl"].ToLower().Replace("-my", "").Substring(8);
            tenantStr = tenantStr.Substring(0, tenantStr.IndexOf("."));
            var tenantAdminUri = new Uri(String.Format("https://{0}-admin.sharepoint.com", tenantStr));
            string realm = TokenHelper.GetRealmFromTargetUrl(tenantAdminUri);
            var token = TokenHelper.GetAppOnlyAccessToken(TokenHelper.SharePointPrincipal, tenantAdminUri.Authority, realm).AccessToken;

            var webUrl = String.Format(lblBasePath.Text + txtUrl.Text);

            var spContext = SharePointContextProvider.Current.GetSharePointContext(Context);
            using (var clientContext = TokenHelper.GetClientContextWithAccessToken(tenantAdminUri.ToString(), token))
            {

                var tenant = new Tenant(clientContext);

                flag = TenantExtensions.IsSiteActive(tenant, webUrl);

                if (flag)
                {
                    ExistName.Text = "Сайт з таким URL вже існує.";
                    txtUrl.BorderColor = System.Drawing.Color.Red;
                    flag = true;
                    btnCreate.Enabled = false;
                }
                else
                {
                    ExistName.Text = "";
                    txtUrl.BorderColor = System.Drawing.Color.DarkGray;
                    btnCreate.Enabled = true;
                    lblFullPath.Text = webUrl;
                    lblFullPath.NavigateUrl = webUrl;
                }
            }
        }



        protected void btnCreate_Click(object sender, EventArgs e)
        {

            var spContext = SharePointContextProvider.Current.GetSharePointContext(Context);
            string newWebUrl = string.Empty;
            using (ClientContext ctx = spContext.CreateUserClientContextForSPHost())
            {
                newWebUrl = CreateSiteCollection(ctx, Page.Request["SPHostUrl"], txtUrl.Text,
                                                listSites.SelectedValue, txtTitle.Text, txtDescription.Text, DropDownListLCID.SelectedValue);
            }


            //ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "RedirectToSite", "navigateParent('" + newWebUrl + "');", true);
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {

        }

        private string CreateSiteCollection(ClientContext ctx, string hostWebUrl, string url, string template, string title, string description, string lcid)
        {
            //get the base tenant admin urls
            var tenantStr = hostWebUrl.ToLower().Replace("-my", "").Substring(8);
            tenantStr = tenantStr.Substring(0, tenantStr.IndexOf("."));

            //get the current user to set as owner
            var currUser = ctx.Web.CurrentUser;
            ctx.Load(currUser);
            ctx.ExecuteQuery();

            //create site collection using the Tenant object
            var webUrl = String.Format("https://{0}.sharepoint.com/{1}/{2}", tenantStr, "teams", url);

            var tenantAdminUri = new Uri(String.Format("https://{0}-admin.sharepoint.com", tenantStr));
            string realm = TokenHelper.GetRealmFromTargetUrl(tenantAdminUri);
            var token = TokenHelper.GetAppOnlyAccessToken(TokenHelper.SharePointPrincipal, tenantAdminUri.Authority, realm).AccessToken;

            using (var adminContext = TokenHelper.GetClientContextWithAccessToken(tenantAdminUri.ToString(), token))
            {
                var tenant = new Tenant(adminContext);
                SiteEntity properties = new SiteEntity()
                {
                    Url = webUrl,
                    SiteOwnerLogin = currUser.Email,
                    Title = title,
                    Template = template,
                    StorageMaximumLevel = 10240,
                    UserCodeMaximumLevel = 100,
                    Lcid = Convert.ToUInt32(lcid)
                };
                bool removeFromRecycleBin = false;
                bool wait = true;
            
                string siteUri = TenantExtensions.CreateSiteCollection(tenant, properties, removeFromRecycleBin, wait);

                if (!TenantExtensions.IsSiteActive(tenant, webUrl))
                {
                    ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "progressDisplay", "progressDisplay();", true);
                }
                else {
                    ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "urlDisplay", "urlDisplay();", true);
                }
                return siteUri;
                //start the SPO operation to create the site
                //SpoOperation op = tenant.CreateSite(properties);
                //adminContext.Load(tenant);
                //adminContext.Load(op, i => i.IsComplete, i => i.PollingInterval);
                //adminContext.ExecuteQuery();


                // Set timeout for the request - notice that since we are using web site, this could still time out
                //adminContext.RequestTimeout = Timeout.Infinite;

                //check if site creation operation is complete

                //while (!op.IsComplete)
                //{

                //    //wait and try again
                //    System.Threading.Thread.Sleep(30000);
                //    op.RefreshLoad();
                //    if (!op.IsComplete)
                //    {
                //        adminContext.ExecuteQuery();
                //    }
                //}
            }

            //get the new site collection
            //var siteUri = new Uri(webUrl);
            //token = TokenHelper.GetAppOnlyAccessToken(TokenHelper.SharePointPrincipal, siteUri.Authority, realm).AccessToken;
            //using (var newWebContext = TokenHelper.GetClientContextWithAccessToken(siteUri.ToString(), token))
            //{
            //    var newWeb = newWebContext.Web;

            //    newWebContext.Load(newWeb);
            //    newWebContext.ExecuteQuery();

            //    new LabHelper().SetThemeBasedOnName(newWebContext, newWeb, newWeb, "Orange");

            //    // All done, let's return the newly created site
            //    return newWeb.Url;
            //}
        }

    }
}