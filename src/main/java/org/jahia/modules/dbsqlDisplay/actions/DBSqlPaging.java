package org.jahia.modules.dbsqlDisplay.actions;

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

/**
 * The Class DBSqlPaging is an Action that is in charge of the paging done for the 
 * module DBSqlDisplay.
 * 
 * @author Juan Pablo Albuja
 */
public class DBSqlPaging extends Action{
	
	/** The name. */
	private String name;
	
	/** The logger. */
	private transient static Logger logger = org.slf4j.LoggerFactory.getLogger(DBSqlPaging.class);
	
	/* (non-Javadoc)
	 * @see org.jahia.bin.Action#doExecute(javax.servlet.http.HttpServletRequest, org.jahia.services.render.RenderContext, org.jahia.services.render.Resource, org.jahia.services.content.JCRSessionWrapper, java.util.Map, org.jahia.services.render.URLResolver)
	 */
	@Override
	public ActionResult doExecute(HttpServletRequest req, RenderContext renderContext, Resource resource, JCRSessionWrapper session, Map<String, List<String>> parameters, URLResolver urlResolver)
			throws Exception {
			logger.info("DBSqlPaging Ajax Action");
			//Set paging information variables			
			int sEcho = Integer.parseInt((parameters.get("sEcho")).get(0).toString());
			int pageSize = Integer.parseInt((parameters.get("iDisplayLength")).get(0).toString());
			int displayStart = Integer.parseInt((parameters.get("iDisplayStart")).get(0).toString());
			int totalColumns = Integer.parseInt((parameters.get("iColumns")).get(0).toString());
			int maxSize = Integer.parseInt((parameters.get("maxSize")).get(0).toString());
			//Set JSon Object
			JSONObject json = new JSONObject();
			//Get the ResultSet
			HttpSession sessionHTTP = req.getSession();
			Object[][] resultSet = (Object[][])sessionHTTP.getAttribute("resultSet");
			//Create the returnArray and populate it
			Object[][] returnArray = null;			
			int totalRows = 0;
			if(resultSet!= null){
				totalRows = resultSet.length;
				totalRows = (totalRows <= maxSize?totalRows:maxSize);
				//Paging operations
				if((displayStart + pageSize) > totalRows){
					pageSize = totalRows - displayStart;
				}
				returnArray = new Object[pageSize][totalColumns];
				//Fill the result Set
				int returnRowIndex = 0;
				for(int i = displayStart; i < displayStart + pageSize;i++){
					for(int j = 0;j<totalColumns;j++){
						String item = (String)((resultSet[i][j])==null?"null":(resultSet[i][j].toString()));
						returnArray[returnRowIndex][j] = item;   
					}
					returnRowIndex++;
				}
			}
			//Return JSon
			json.put("aaData",returnArray);
			json.put("sEcho", sEcho);
			json.put("iTotalRecords", totalRows);
			json.put("iTotalDisplayRecords", totalRows);	
			ActionResult result = new ActionResult(HttpServletResponse.SC_OK, null, json);
			result.setJson(json);
			return result;
	}
	
	/* (non-Javadoc)
	 * @see org.jahia.bin.Action#isRequireAuthenticatedUser()
	 */
	public boolean isRequireAuthenticatedUser(){
		return false;
	}
	
	/* (non-Javadoc)
	 * @see org.jahia.bin.Action#getName()
	 */
	public String getName() {
		return this.name;
	}
	
	/* (non-Javadoc)
	 * @see org.jahia.bin.Action#setName(java.lang.String)
	 */
	public void setName(String name){
		this.name = name;
	}

}
