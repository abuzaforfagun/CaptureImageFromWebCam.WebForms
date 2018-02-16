<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="CaptureImageFromWebCam.WebForms.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script src='<%=ResolveUrl("~/Webcam_Plugin/jquery.webcam.js") %>' type="text/javascript"></script>
<script type="text/javascript">
var pageUrl = '<%=ResolveUrl("~/WebForm1.aspx") %>';
$(function () {
    jQuery("#webcam").webcam({
        width: 320,
        height: 240,
        mode: "save",
        swffile: '<%=ResolveUrl("~/Webcam_Plugin/jscam.swf") %>',
        debug: function (type, status) {
            $('#camStatus').append(type + ": " + status + '<br /><br />');
        },
        onSave: function (data) {
            $.ajax({
                type: "POST",
                url: pageUrl + "/GetCapturedImage",
                data: '',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (r) {
                    $("[id*=imgCapture]").css("visibility", "visible");
                    $("[id*=imgCapture]").attr("src", r.d);
                },
                failure: function (response) {
                    alert(response.d);
                }
            });
        },
        onCapture: function () {
            webcam.save(pageUrl);
        }
    });
});
function Capture() {
    webcam.capture();
    return false;
}
</script>
    <form id="form1" runat="server">
        <table border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td align="center">
            <u>Live Camera</u>
        </td>
        <td>
        </td>
        <td align="center">
            <u>Captured Picture</u>
        </td>
    </tr>
    <tr>

        <td>
            <div id="webcam">
            </div>
        </td>
        <td>
            &nbsp;
        </td>
        <td>
            <asp:Image ID="imgCapture" runat="server" Style="visibility: hidden; width: 320px;
                height: 240px" />
        </td>
    </tr>
    <tr>
        <td>Name</td>
        <td><asp:TextBox runat="server" ID="txtName"></asp:TextBox></td>
    </tr>
    <tr>
        <td>Email</td>
        <td><asp:TextBox runat="server" ID="txtEmail"></asp:TextBox></td>
    </tr>
</table>
<br />
<asp:Button ID="btnCapture" Text="Capture" runat="server" OnClientClick="return Capture();" />
<asp:Button ID="btnSubmit" Text="Save" runat="server" OnClick="btnSubmit_Click"/>
<br />
<span id="camStatus"></span>
    </form>
</body>
</html>
