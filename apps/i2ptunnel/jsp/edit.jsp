<%
    // NOTE: Do the header carefully so there is no whitespace before the <?xml... line

    String cspNonce = Integer.toHexString(net.i2p.util.RandomSource.getInstance().nextInt());

    response.setHeader("X-Frame-Options", "SAMEORIGIN");
    // edit pages need script for the delete button 'are you sure'
    response.setHeader("Content-Security-Policy", "default-src 'self'; style-src 'self' 'unsafe-inline'; script-src 'self' 'unsafe-inline' 'nonce-" + cspNonce + "'; form-action 'self'; frame-ancestors 'self'; object-src 'none'; media-src 'none'");
    response.setHeader("X-XSS-Protection", "1; mode=block");
    response.setHeader("X-Content-Type-Options", "nosniff");
    response.setHeader("Referrer-Policy", "no-referrer");
    response.setHeader("Accept-Ranges", "none");

%><%@page pageEncoding="UTF-8"
%><%@page trimDirectiveWhitespaces="true"
%><%@page contentType="text/html" import="net.i2p.i2ptunnel.web.EditBean"
%><% 
boolean __isClient = false;
boolean __invalid = false;
int curTunnel = -1;
String tun = request.getParameter("tunnel");
if (tun != null) {
  try {
    curTunnel = Integer.parseInt(tun);
    __isClient = EditBean.staticIsClient(curTunnel);
  } catch (NumberFormatException nfe) {
    __invalid = true;
  }
} else {
  String type = request.getParameter("type");
  __isClient = EditBean.isClient(type);
}
%><?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html>
<jsp:useBean class="net.i2p.i2ptunnel.web.EditBean" id="editBean" scope="request" />
<jsp:useBean class="net.i2p.i2ptunnel.ui.Messages" id="intl" scope="request" />
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <title><%=intl._t("Hidden Services Manager")%> - <%=(__isClient ? intl._t("Edit Client Tunnel") : intl._t("Edit Hidden Service"))%></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="/themes/console/images/favicon.ico" type="image/x-icon" rel="shortcut icon" />
    <link href="<%=editBean.getTheme()%>i2ptunnel.css?<%=net.i2p.CoreVersion.VERSION%>" rel="stylesheet" type="text/css" /> 
<style type='text/css'>
  input.default { width: 1px; height: 1px; visibility: hidden; }
</style>
<script src="/js/resetScroll.js?<%=net.i2p.CoreVersion.VERSION%>" type="text/javascript"></script>
<script src="js/tableSlider.js?<%=net.i2p.CoreVersion.VERSION%>" type="text/javascript"></script>
<script nonce="<%=cspNonce%>" type="text/javascript">
  var deleteMessage = "<%=intl._t("Are you sure you want to delete?")%>";
</script>
<script src="js/delete.js?<%=net.i2p.CoreVersion.VERSION%>" type="text/javascript"></script>
</head>
<body id="tunnelEditPage">
<%
if (__invalid) {
    %>Invalid tunnel parameter<%
} else {
    if (editBean.isInitialized()) {
%>
  <form method="post" action="list">
    <div class="panel">
<%
        if (__isClient) {
            %><%@include file="editClient.jsi" %><%
        } else {
            %><%@include file="editServer.jsi" %><%
        }
%>
    </div>
  </form>
<%
    } else {
        %><div id="notReady"><%=intl._t("Tunnels not initialized yet; please retry in a few moments.")%></div><%
    }  // isInitialized()
}
%>
</body>
</html>
