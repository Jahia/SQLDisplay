package org.jahia.modules.dbsqlDisplay.actions;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.jahia.bin.Action;
import org.jahia.bin.ActionResult;
import org.jahia.services.content.JCRSessionWrapper;
import org.jahia.services.render.RenderContext;
import org.jahia.services.render.Resource;
import org.jahia.services.render.URLResolver;
import org.json.JSONObject;
import org.slf4j.Logger;

public class DBSqlPaging extends Action{
	
	private String name;
	private transient static Logger logger = org.slf4j.LoggerFactory.getLogger(DBSqlPaging.class);
	
	@Override
	public ActionResult doExecute(HttpServletRequest req, RenderContext renderContext, Resource resource, JCRSessionWrapper session, Map<String, List<String>> parameters, URLResolver urlResolver)
			throws Exception {
			logger.info("DBSqlPaging Ajax Action");
			//Set paging information variables			
			int pageSize = Integer.parseInt((parameters.get("pageSize")).get(0).toString());
			int totalRows = Integer.parseInt((parameters.get("totalRows")).get(0).toString());
			int totalColumns = Integer.parseInt((parameters.get("totalColumns")).get(0).toString());
			int currentPage = Integer.parseInt((parameters.get("currentPage")).get(0).toString());
			//Set variables on json
			JSONObject json = new JSONObject();
			//Get the ResultSet
			HttpSession sessionHTTP = req.getSession();
			Object[][] resultSet = (Object[][])sessionHTTP.getAttribute("resultSet");
			LinkedList<String> linkedList = null;
			//Paging operations
			int offset=(currentPage - 1) * pageSize;
			if((offset + pageSize) > totalRows){
				pageSize = totalRows;
			}else{
				pageSize = pageSize + offset;
			}
			//Store in the json
			if(resultSet!= null){
				for(int i = offset; i < pageSize;i++){
					linkedList = new LinkedList<String>();
					for(int j = 0;j<totalColumns;j++){
						Object register = ((resultSet[i][j])==null?"null":(resultSet[i][j]));  
						linkedList.add(register.toString());	
					}
					json.put("row" + i, linkedList);
				}
			}
			ActionResult result = new ActionResult(HttpServletResponse.SC_OK, null, json);
			result.setJson(json);
			return result;
	}
	
	public boolean isRequireAuthenticatedUser(){
		return false;
	}
	
	public String getName() {
		return this.name;
	}
	
	public void setName(String name){
		this.name = name;
	}

}
