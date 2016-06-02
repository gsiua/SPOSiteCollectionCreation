//postMessage to SharePoint for closing dialog 
function closeDialog() {
    var target = parent.postMessage ? parent : (parent.document.postMessage ? parent.document : undefined);
    target.postMessage('CloseDialog', '*');
}

function navigateParent(url) {
    $("#progress").css("display", "block");
    var target = parent.postMessage ? parent : (parent.document.postMessage ? parent.document : undefined);
    target.postMessage( 'NavigateParent=' + url, '*');
}
function urlDisplay() {
    $("#inputField").css("display", "none");
    $("#btnCreate").css("display", "none");
    $("#btnCancel").css("position", "absolute");
    $("#btnCancel").css("bottom", "35px");
    $("#btnCancel").css("right", "35px");
    $("#btnCancel").attr("value", "ОK");
    $("#finishWarning").css("display", "block");
}
function progressDisplay() {
    var eightMinutes = 60 * 8,
    display = document.querySelector('#clockdiv');
    startTimer(eightMinutes, display);

    setTimeout(function () {
        $("#progress").css("display", "block");
        $("#waitingTime").css("display", "block");
        $("#clockdiv").css("display", "block");
        $("#inputField").css("display", "none");
        $("#btnCreate").css("display", "none");
        $("#btnCancel").css("position", "absolute");
        $("#btnCancel").css("bottom", "35px");
        $("#btnCancel").css("right", "35px");
        $("#btnCancel").attr("value", "ОK");
    }, 10);
    setTimeout(function () {
        $("#waitingTime").css("display", "none");
        $("#clockdiv").css("display", "none");
        $("#progress").css("display", "none");
        $("#finishWarning").css("display", "block");
        $("#footer").css("display", "none");
    }, 480000);
}

function startTimer(duration, display) {
    var timer = duration, minutes, seconds;
    setInterval(function () {
        minutes = parseInt(timer / 60, 10);
        seconds = parseInt(timer % 60, 10);

        minutes = minutes < 10 ? "0" + minutes : minutes;
        seconds = seconds < 10 ? "0" + seconds : seconds;

        display.textContent = minutes + ":" + seconds;

        if (--timer < 0) {
            timer = duration;
        }
    }, 1000);
}

//Wait for the page to load 
var context;
$(document).ready(function () {

    //Get the isDialog from url parameters
    var isDialog = decodeURIComponent(getQueryStringParameter('IsDlg'));
    $("#finishWarning").css("display", "none");
    $("#inputField").css("display", "block");
    //Get the URI decoded SharePoint site url from the SPHostUrl parameter. 
    var spHostUrl = decodeURIComponent(getQueryStringParameter('SPHostUrl'));
    var appWebUrl = decodeURIComponent(document.URL.split('?')[0].split('&'));

    //Build absolute path to the layouts root with the spHostUrl 
    var layoutsRoot = spHostUrl + '/_layouts/15/';

    //load all appropriate scripts for the page to function 
    $.getScript(layoutsRoot + 'SP.Runtime.js',
        function () {
            $.getScript(layoutsRoot + 'SP.js',
                function () {
                    //Execute the correct script based on the isDialog 
                    if (isDialog == '0') {
                        //Load the SP.UI.Controls.js file to render the App Chrome 
                        $.getScript(layoutsRoot + 'SP.UI.Controls.js', renderSPChrome);
                    }
                    else if (isDialog == '1') {
                        //Create a Link element for the defaultcss.ashx resource 
                        var linkElement = document.createElement('link');
                        linkElement.setAttribute('rel', 'stylesheet');
                        linkElement.setAttribute('href', layoutsRoot + 'defaultcss.ashx');

                        //Add the linkElement as a child to the head section of the html 
                        var headElement = document.getElementsByTagName('head');
                        headElement[0].appendChild(linkElement);

                        //load view  
                        chromeLoaded();
                    }

                    //load remaining scripts 
                    $.getScript(layoutsRoot + 'SP.RequestExecutor.js', function () {
                        context = new SP.ClientContext.get_current();
                        var factory = new SP.ProxyWebRequestExecutorFactory(appWebUrl);
                        context.set_webRequestExecutorFactory(factory);
                    });
                });
        });
});

//function to get a parameter value by a specific key 
function getQueryStringParameter(urlParameterKey) {
    var params = document.URL.split('?')[1].split('&');
    var strParams = '';
    for (var i = 0; i < params.length; i = i + 1) {
        var singleParam = params[i].split('=');
        if (singleParam[0] == urlParameterKey)
            return singleParam[1];
    }
}

//show body once the chrome is loaded 
function chromeLoaded() {
    $('body').show();
}

//resize the UI 
function PostResizeMessage(w, h) {
    var target = parent.postMessage ? parent : (parent.document.postMessage ? parent.document : undefined);
    var regex = new RegExp(/[Ss]ender[Ii]d=([\daAbBcCdDeEfF]+)/);
    results = regex.exec(this.location.search);
    if (null !== results && null !== results[1]) {
        target.postMessage('<message senderId=' + results[1] + '>resize(' + w + ',' + h + ')</message>', '*');
    }
}

function MakeSSCDialogPageVisible() {
    var dlgMadeVisible = false;
    try {
        var dlg = window.top.g_childDialog;
        if (Boolean(window.frameElement) && Boolean(window.frameElement.makeVisible)) {
            window.frameElement.makeVisible();
            dlgMadeVisible = true;
        }
    }
    catch (ex) {
    }
    if (!dlgMadeVisible && Boolean(top) && Boolean(top.postMessage)) {
        var message = "MakePageVisible";
        top.postMessage(message, "*");
    }
}

function UpdateSSCDialogPageSize() {
    var dlgResized = false;
    try {
        var dlg = window.top.g_childDialog;
        if (!fIsNullOrUndefined(dlg)) {
            dlg.autoSize();
            dlgResized = true;
        }
    }
    catch (ex) {
    }
    if (!dlgResized && Boolean(top) && Boolean(top.postMessage)) {
        var message = "PageWidth=600;PageHeight=570";
        top.postMessage(message, "*");
    }
}