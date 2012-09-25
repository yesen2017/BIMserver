<%@page import="org.bimserver.interfaces.objects.SQueryEngine"%>
<%@page import="java.util.List"%>
<%@ include file="usersettingsmenu.jsp"%>
<%
if (request.getParameter("action") != null) {
	String action = request.getParameter("action");
	if (action.equals("enable")) {
		SQueryEngine queryEngine = loginManager.getService().getQueryEngineById(Long.parseLong(request.getParameter("oid")));
		queryEngine.setEnabled(true);
		loginManager.getService().updateQueryEngine(queryEngine);
	} else if (action.equals("disable")) {
		SQueryEngine queryEngine = loginManager.getService().getQueryEngineById(Long.parseLong(request.getParameter("oid")));
		queryEngine.setEnabled(false);
		loginManager.getService().updateQueryEngine(queryEngine);
	} else if (action.equals("setdefault")) {
		loginManager.getService().setDefaultQueryEngine(Long.parseLong(request.getParameter("oid")));
	} else if (action.equals("delete")) {
		loginManager.getService().deleteQueryEngine(Long.parseLong(request.getParameter("oid")));
	}
	response.sendRedirect("queryengines.jsp");
}
%>
<h1>Query Engines</h1>
<a href="addqueryengine.jsp">Add Query Engine</a>
<table class="formatted">
<tr><th>Name</th><th>Classname</th><th>Default</th><th>State</th><th>Actions</th></tr>
<%
	List<SQueryEngine> queryEngines = service.getAllQueryEngines(false);
	for (SQueryEngine queryEngine : queryEngines) {
		boolean isDefault = service.getDefaultQueryEngine() != null && service.getDefaultQueryEngine().getOid() == queryEngine.getOid();
%>
	<tr>
		<td><a href="queryengine.jsp?id=<%=queryEngine.getOid()%>"><%=queryEngine.getName() %></a></td>
		<td><%=queryEngine.getClassName() %></td>
		<td><input type="radio" name="default"<%=queryEngine.getEnabled() ? "" : "disabled=\"disabled\"" %> oid="<%=queryEngine.getOid()%>" <%=service.getDefaultQueryEngine() != null && service.getDefaultQueryEngine().getOid() == queryEngine.getOid() ? "checked" : "" %>/></td>
		<td class="<%=queryEngine.getEnabled() ? "enabled" : "disabled" %>"> <%=queryEngine.getEnabled() ? "Enabled" : "Disabled" %></td>
		<td>
		<%
	if (!isDefault) {
	if (!queryEngine.getEnabled()) {
%>
<a href="queryengines.jsp?action=enable&oid=<%=queryEngine.getOid() %>">Enable</a>
<%
	} else {
%>
<a href="queryengines.jsp?action=disable&oid=<%=queryEngine.getOid() %>">Disable</a>
<%
	}
%>
		<a href="queryengines.jsp?action=delete&oid=<%=queryEngine.getOid()%>">Delete</a>
<%
	}
%>
		</td>
	</tr>
<%
	}
%>
</table>
<script>
$(function(){
	$("input[name=\"default\"]").change(function(){
		document.location = "queryengines.jsp?action=setdefault&oid=" + $(this).attr("oid");
	});
});
</script>