function printResults(redirectPath, pageSize, totalRows, totalColumns, currentPage) {
 redirectPath = redirectPath + "?pageSize=" + pageSize + "&totalRows=" + totalRows + "&totalColumns=" + totalColumns + "&currentPage=" + currentPage;
	$.ajax({
	  url: redirectPath,
	  dataType: 'json',
	  success: function(data){
		 	var tbody = document.getElementById("results").getElementsByTagName("TBODY")[0];		  	
		  	var offset=(currentPage - 1) * pageSize;
		  	var rowCounter=offset;
		  	deleteTableData();
		  	while(eval("data.row" + rowCounter ) != null){
		  		var row = document.createElement("TR")
		  		for(var j = 0; j < totalColumns;j++){
		  			var td1 = document.createElement("TD")
		  			td1.appendChild(document.createTextNode(   eval("data.row" +rowCounter+"[" + j +"]")  ))
			    	row.appendChild(td1);
		  		}
			    tbody.appendChild(row);
			    rowCounter++;
		    }
	  }
	});
}

function dbPaging(operation){
	var currentPage = parseInt($('#currentPage').val());
	currentPage = currentPage + (operation); 
	var numberPages = calculateNumberPages(parseInt($('#totalRows').val()), parseInt($('#pageSize').val()));
	if(currentPage > numberPages){
		currentPage = numberPages; 
	}
	if(currentPage == 0){
		currentPage = 1; 
	}
	$('#currentPage').val(currentPage);
	setPage(currentPage);
	printResults($('#redirectPath').val(),$('#pageSize').val(), $('#totalRows').val(), $('#totalColumns').val(), currentPage);
}

function calculateNumberPages(totalNumberOfItems, pageSize){
	var result = totalNumberOfItems % pageSize;
	if (result == 0)
		return totalNumberOfItems / pageSize;
	else
		return parseInt(totalNumberOfItems / pageSize) + 1;
}

function setPage(currentPage){
	$('#displayPage').html(currentPage); 
}

function deleteTableData(){
      var table = document.getElementById("results");
      for(var i = table.rows.length - 1; i > 1; i--)
      {
      	table.deleteRow(i);
      }
}