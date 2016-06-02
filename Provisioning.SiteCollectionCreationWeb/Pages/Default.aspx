<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Contoso.Provisioning.SiteCollectionCreationWeb.Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Почати новий сайт</title>
    <link rel="Stylesheet" type="text/css" href="../Styles/AppStyles.css" />
    <script type="text/javascript" src="../Scripts/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="../Scripts/app.js"></script>

    <script type="text/javascript"> 
        $(document).ready(function () { 
            var isDialog = decodeURIComponent(getQueryStringParameter('IsDlg')); 
            if (isDialog == '1') { 
                MakeSSCDialogPageVisible(); 
                UpdateSSCDialogPageSize(); 
            }
            $('.liSiteType').click(function () {
                $('.liSiteType').removeClass('ms-core-listMenu-selected');
                $(this).addClass('ms-core-listMenu-selected');
                $('#divBasePath').html($(this).attr('data-BasePath'));
                $('#hdnSelectedTemplate').val($(this).attr('data-Template'));
            });
        }); 
 
    </script> 
</head>
<body style="display: none; overflow: auto;">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnableCdn="True" AsyncPostBackTimeout="2000" />
        <div id="divSPChrome"></div>
        <asp:UpdateProgress ID="progress" runat="server" AssociatedUpdatePanelID="update" DynamicLayout="true">
            <ProgressTemplate>
                <div id="divWaitingPanel" style="position: absolute; z-index: 3; background: rgb(255, 255, 255); width: 100%; bottom: 0px; top: 0px;">
                    <div style="top: 35%; position: absolute; left: 12%; text-align:center;">
                        <img alt="Працюємо над цим..." src="data:image/gif;base64,R0lGODlhEAAQAIAAAFLOQv///yH/C05FVFNDQVBFMi4wAwEAAAAh+QQFCgABACwJAAIAAgACAAACAoRRACH5BAUKAAEALAwABQACAAIAAAIChFEAIfkEBQoAAQAsDAAJAAIAAgAAAgKEUQAh+QQFCgABACwJAAwAAgACAAACAoRRACH5BAUKAAEALAUADAACAAIAAAIChFEAIfkEBQoAAQAsAgAJAAIAAgAAAgKEUQAh+QQFCgABACwCAAUAAgACAAACAoRRACH5BAkKAAEALAIAAgAMAAwAAAINjAFne8kPo5y02ouzLQAh+QQJCgABACwCAAIADAAMAAACF4wBphvID1uCyNEZM7Ov4v1p0hGOZlAAACH5BAkKAAEALAIAAgAMAAwAAAIUjAGmG8gPW4qS2rscRPp1rH3H1BUAIfkECQoAAQAsAgACAAkADAAAAhGMAaaX64peiLJa6rCVFHdQAAAh+QQJCgABACwCAAIABQAMAAACDYwBFqiX3mJjUM63QAEAIfkECQoAAQAsAgACAAUACQAAAgqMARaol95iY9AUACH5BAkKAAEALAIAAgAFAAUAAAIHjAEWqJeuCgAh+QQJCgABACwFAAIAAgACAAACAoRRADs=" style="width: 32px; height: 32px;" />
                        <span class="ms-accentText" style="font-size: 36px;">&nbsp;Будь ласка, зачекайте...</span><br/><span class="ms-accentText" style="font-size: 36px;" id="waitingTime">Це займе близько 8 хвилин...</span>
                        <div id="clockdiv" class="ms-accentText" style="font-size: 36px;"></div>
                    </div>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
        <asp:UpdatePanel ID="update" runat="server" ChildrenAsTriggers="true" >
            <ContentTemplate>
                  <div style="width: 450px; margin-left:50px; ">    
                    <div id="inputField">                                             
                        <div id="divFieldTitle" style="display: table;">
                            <h3 class="ms-core-form-line">Назва сайту</h3>
                            <div class="ms-core-form-line">
                                <asp:TextBox ID="txtTitle" runat="server" CssClass="ms-fullWidth"></asp:TextBox>
                                <p class="ms-core-form-line descript">Назва буде відображатися на кожній сторінці цього сайту.</p>
                            </div>
                            <h3 class="ms-core-form-line">URL сайту</h3>
                            <div style="float: left; white-space: nowrap; padding-bottom: 10px; width: 450px;">
                                <div style="width: 320px; font-size: 13px; float: left; padding-top: 2px;" id="divBasePath">
                                    <asp:Label ID="lblBasePath" runat="server" ></asp:Label>
                                </div>
                                <div style="width: 130px; float: left;" >
                                    <asp:TextBox ID="txtUrl" runat="server" CssClass="ms-fullWidth"  OnTextChanged="ExistSite_TextChanged" AutoPostBack="true"></asp:TextBox>                              
                                    <asp:Label ID="ExistName" class="exist-name" runat="server"></asp:Label>
                                    <p class="ms-core-form-line descript url-desc">URL може містити тільки ці символи A-Z, a-z, 0-9</p>
                                </div> 
                            </div>
                        </div>
                        <h3 class="ms-core-form-line">Мова сайту</h3>
                        <div class="ms-core-form-line">
                            <asp:DropDownList ID="DropDownListLCID" runat="server" onchange="OnWebLangChange()">
                                <asp:ListItem Text="Українська" Value="1058" Selected="True"/>
                                <asp:ListItem Text="Русский" Value="1049" />
                                <asp:ListItem Text="English" Value="1033"  />
                            </asp:DropDownList>
                        </div>
                        <h3 class="ms-core-form-line">Шаблон сайту</h3>
                        <div class="ms-core-form-line">
                            
                            <asp:ListBox ID="listSites" runat="server" CssClass="ms-fullWidth" onchange="OnWebTemplateChange()" Rows="8">
                                <asp:ListItem value="STS#0" Selected="True" Text="Сайт групи"></asp:ListItem>   
                                <asp:ListItem value="BLOG#0">Блог</asp:ListItem>
                                <asp:ListItem value="COMMUNITY#0">Сайт спільноти</asp:ListItem> 
                                <asp:ListItem value="PROJECTSITE#0">Сайт проекту</asp:ListItem>
                                <asp:ListItem value="BDR#0">Центр документів</asp:ListItem>  
                                <asp:ListItem value="COMMUNITYPORTAL#0">Портал спільноти</asp:ListItem>  
                                <asp:ListItem value="BLANKINTERNETCONTAINER#0">Портал публікації</asp:ListItem>
                                <asp:ListItem value="ENTERWIKI#0">Корпоративний вікі-сайт</asp:ListItem>   
                            </asp:ListBox>

                            <asp:ListBox ID="listSites0" runat="server" style="display:none" >
                                <asp:ListItem value="STS#0" Selected="True">Сайт групи</asp:ListItem>   
                                <asp:ListItem value="BLOG#0">Блог</asp:ListItem>
                                <asp:ListItem value="COMMUNITY#0">Сайт спільноти</asp:ListItem> 
                                <asp:ListItem value="PROJECTSITE#0">Сайт проекту</asp:ListItem>
                                <asp:ListItem value="BDR#0">Центр документів</asp:ListItem>  
                                <asp:ListItem value="COMMUNITYPORTAL#0">Портал спільноти</asp:ListItem>  
                                <asp:ListItem value="BLANKINTERNETCONTAINER#0">Портал публікації</asp:ListItem>
                                <asp:ListItem value="ENTERWIKI#0">Корпоративний вікі-сайт</asp:ListItem>   
                            </asp:ListBox>
                            <asp:ListBox ID="listSites1" runat="server" style="display:none" >
                                <asp:ListItem value="STS#0" Selected="True">Сайт группы</asp:ListItem>   
                                <asp:ListItem value="BLOG#0">Блог</asp:ListItem>
                                <asp:ListItem value="COMMUNITY#0">Сайт сообщества</asp:ListItem> 
                                <asp:ListItem value="PROJECTSITE#0">Сайт проекта</asp:ListItem>
                                <asp:ListItem value="BDR#0">Центр документов</asp:ListItem>  
                                <asp:ListItem value="COMMUNITYPORTAL#0">Портал сообщества</asp:ListItem>  
                                <asp:ListItem value="BLANKINTERNETCONTAINER#0">Портал публикации</asp:ListItem>
                                <asp:ListItem value="ENTERWIKI#0">Корпоративный вики-сайт</asp:ListItem>   
                            </asp:ListBox>

                           <asp:ListBox ID="listSites2" runat="server" style="display:none">
                                <asp:ListItem value="STS#0" Selected="True">Team Site</asp:ListItem>   
                                <asp:ListItem value="BLOG#0">Blog</asp:ListItem>
                                <asp:ListItem value="COMMUNITY#0">Community Site</asp:ListItem> 
                                <asp:ListItem value="PROJECTSITE#0">Project Site</asp:ListItem>
                                <asp:ListItem value="BDR#0">Document Center</asp:ListItem>  
                                <asp:ListItem value="COMMUNITYPORTAL#0">Community Portal</asp:ListItem>  
                                <asp:ListItem value="BLANKINTERNETCONTAINER#0">Publishing Portal</asp:ListItem>
                                <asp:ListItem value="ENTERWIKI#0">Enterprise Wiki</asp:ListItem>   
                            </asp:ListBox>
                        </div>

                        <div class="ms-core-form-line HidDescription" id="HidDescription00" style="display:none"><p class="ms-core-form-line">Розташування для спільної роботи із групою людей.</p></div> 
                        <div class="ms-core-form-line HidDescription" id="HidDescription01" style="display:none"><p class="ms-core-form-line">Место для совместной работы с группой пользователей.</p></div> 
                        <div class="ms-core-form-line HidDescription" id="HidDescription02" style="display:none"><p class="ms-core-form-line">A place to work together with a group of people.</p></div> 
                        
                        <div class="ms-core-form-line HidDescription" id="HidDescription10" style="display:none"><p class="ms-core-form-line">Сайт, на якому особа чи група можуть публікувати ідеї, спостереження та професійні матеріали, які відвідувачі можуть коментувати.</p></div> 
                        <div class="ms-core-form-line HidDescription" id="HidDescription11" style="display:none"><p class="ms-core-form-line">Сайт для пользователя или рабочей группы, где можно записывать идеи, результаты наблюдений и накопленные знания, давая возможность посетителям сайта добавлять свои комментарии.</p></div> 
                        <div class="ms-core-form-line HidDescription" id="HidDescription12" style="display:none"><p class="ms-core-form-line">A site for a person or team to post ideas, observations, and expertise that site visitors can comment on.</p></div> 

                        <div class="ms-core-form-line HidDescription" id="HidDescription20" style="display:none"><p class="ms-core-form-line">Розташування, у якому учасники спільноти обговорюють цікаві для них теми. Учасники можуть шукати потрібний вміст, досліджуючи категорії, сортуючи дискусії за популярністю або переглядаючи лише ті дописи, які містять найкращі відповіді. Учасники отримують бали репутації за участь у спільноті, наприклад за початок дискусій і відповіді на них, додавання до дописів позначки ''Подобається'' та визначення найкращих відповідей.</p></div>
                        <div class="ms-core-form-line HidDescription" id="HidDescription21" style="display:none"><p class="ms-core-form-line">Место для совместной работы с группой пользователей.</p></div>
                        <div class="ms-core-form-line HidDescription" id="HidDescription22" style="display:none"><p class="ms-core-form-line">A place where community members discuss topics of common interest. Members can browse and discover relevant content by exploring categories, sorting discussions by popularity or by viewing only posts that have a best reply. Members gain reputation points by participating in the community, such as starting discussions and replying to them, liking posts and specifying best replies.</p></div>

                        <div class="ms-core-form-line HidDescription" id="HidDescription30" style="display:none"><p class="ms-core-form-line">Сайт для керування проектом і співпраці над ним. Цей шаблон сайту поєднує в одному місці всі стани, зв’язки та артефакти, які стосуються проекту.</p></div>
                        <div class="ms-core-form-line HidDescription" id="HidDescription31" style="display:none"><p class="ms-core-form-line">Сайт для совместной работы над проектом и управления им. Этот шаблон сайта позволяет сосредоточить в одном месте все данные о состоянии и взаимодействии, а также артефакты, относящиеся к проекту.</p></div>
                        <div class="ms-core-form-line HidDescription" id="HidDescription32" style="display:none"><p class="ms-core-form-line">A site for managing and collaborating on a project. This site template brings all status, communication, and artifacts relevant to the project into one place.</p></div>

                        <div class="ms-core-form-line HidDescription" id="HidDescription40" style="display:none"><p class="ms-core-form-line">Сайт для централізованого керування документами установи.</p></div>
                        <div class="ms-core-form-line HidDescription" id="HidDescription41" style="display:none"><p class="ms-core-form-line">Сайт, предназначенный для централизованного управления документами организации.</p></div>
                        <div class="ms-core-form-line HidDescription" id="HidDescription42" style="display:none"><p class="ms-core-form-line">A site to centrally manage documents in your enterprise.</p></div>

                        <div class="ms-core-form-line HidDescription" id="HidDescription50" style="display:none"><p class="ms-core-form-line">Сайт для пошуку спільнот.</p></div>
                        <div class="ms-core-form-line HidDescription" id="HidDescription51" style="display:none"><p class="ms-core-form-line">Сайт для поиска сообществ.</p></div>
                        <div class="ms-core-form-line HidDescription" id="HidDescription52" style="display:none"><p class="ms-core-form-line">A site for discovering communities.</p></div>

                        <div class="ms-core-form-line HidDescription" id="HidDescription60" style="display:none"><p class="ms-core-form-line">Початкова ієрархія сайтів для великого порталу в інтрамережі або веб-сайту для Інтернету. Цей сайт можна легко настроювати за допомогою корпоративної символіки. Він містить домашню сторінку, зразок підсайту для прес-релізів, центр пошуку та сторінку входу. Зазвичай такий сайт має значно більше читачів, ніж кореспондентів, і використовується для публікації веб-сторінок із застосуванням робочих циклів затвердження.</p></div>
                        <div class="ms-core-form-line HidDescription" id="HidDescription61" style="display:none"><p class="ms-core-form-line">Начальная иерархия для корпоративного веб-сайта в Интернете или большого портала в интрасети. Такой сайт может быть легко настроен с применением фирменной символики. Содержит домашнюю страницу, образец дочернего сайта для пресс-релизов, центр поиска и страницу входа. Обычно такой сайт имеет больше читателей, чем корреспондентов, и используется для публикации веб-страниц с применением рабочих процессов утверждения документов.</p></div>
                        <div class="ms-core-form-line HidDescription" id="HidDescription62" style="display:none"><p class="ms-core-form-line">A starter site hierarchy for an Internet-facing site or a large intranet portal. This site can be customized easily with distinctive branding. It includes a home page, a sample press releases subsite, a Search Center, and a login page. Typically, this site has many more readers than contributors, and it is used to publish Web pages with approval workflows.</p></div>

                        <div class="ms-core-form-line HidDescription" id="HidDescription70" style="display:none"><p class="ms-core-form-line">Сайт для публікування відомостей, які ви маєте та якими бажаєте поділитися зі співробітниками. Він надає можливість зручного редагування вмісту в одному розташуванні, співавторства, обговорення та керування проектами.</p></div>                   
                        <div class="ms-core-form-line HidDescription" id="HidDescription71" style="display:none"><p class="ms-core-form-line">Сайт для публикации знаний, которыми вы обладаете и которые вы хотите сделать общими для корпоративной среды. Он предоставляет возможность удобного редактирования контента в одном месте, средства соавторства, обсуждения и управления проектом.</p></div>                   
                        <div class="ms-core-form-line HidDescription" id="HidDescription72" style="display:none"><p class="ms-core-form-line">A site for publishing knowledge that you capture and want to share across the enterprise. It provides an easy content editing experience in a single location for co-authoring content, discussions, and project management.</p></div>                   

                        <div id="divFieldDescription">
                            <h3 class="ms-core-form-line">Опис</h3>
                            <div class="ms-core-form-line" onclick="functionUrl">
                                <asp:TextBox ID="txtDescription" runat="server" CssClass="ms-fullWidth" TextMode="MultiLine" Rows="2" ></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div id="finishWarning" style="display: none;">
                        <h1 class="ms-core-form-line">Сайт створено за адресою</h1>
                        <asp:HyperLink ID="lblFullPath" CssClass="ms-accentText" style="font-size: 20px;" runat="server"  Target="_blank"></asp:HyperLink>
                    </div>
                    <div id="divButtons" style="float: right;">
                        <asp:Button ID="btnCreate" runat="server" Text="Створити" CssClass="ms-ButtonHeightWidth" OnClick="btnCreate_Click" />
                        <asp:Button ID="btnCancel" runat="server" Text="Відмінити" CssClass="ms-ButtonHeightWidth" OnClick="btnCancel_Click" />
                    </div>    
                    <div class="footer-logo" id="footer">
                        <a target="_blank" href="https://www.gsi.ua">
                            <img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAD4AAAAQAgMAAAAzCSSRAAAACXBIWXMAAA7EAAAOxAGVKw4bAAAAIGNIUk0AAHolAACAgwAA+f8AAIDoAABSCAABFVgAADqXAAAXb9daH5AAAAAMUExURf///4++PPJQIv+5AAwy9xAAAAABdFJOUwBA5thmAAAAHklEQVQY02NgwABMq1atahANDQ1h/v///4HhLoAGAAcrZos6aSdIAAAAAElFTkSuQmCC" />
                        </a>
                        <p>Designed by</p>
                        <a target="_blank" href="https://www.gsi.ua">GSI</a>
                     </div>             
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", OnWebTemplateChange);
        function OnWebTemplateChange() {
            var index = document.getElementById("listSites").selectedIndex;
            var lang = document.getElementById("DropDownListLCID").selectedIndex;
            if (typeof (index) != "undefined") {
                if (index >= 0) {
                    $('.HidDescription').css('display', 'none');
                    var idDescription = "HidDescription" + index + lang;
                    if (document.getElementById(idDescription) != null) {
                        document.getElementById(idDescription).style.display = "block";
                    }
                }
            }
        }

        document.addEventListener("DOMContentLoaded", OnWebLangChange);
        function OnWebLangChange() {
            var lang = document.getElementById("DropDownListLCID").selectedIndex;
            if (typeof (lang) != "undefined") {
                $('.HidDescription').css('display', 'none');
                var x = document.getElementById("listSites");                    
                var y = document.getElementById("listSites" + lang);
                var listLength = y.length;
                for (var i = 0; i < listLength; i++) {
                    x.options[i].text = y.options[i].text;
                }
            }
        }
    </script>
</body>
</html>
