$(document).ready(function() {
  $("td").on("click",function() {
  	if ($(this).css("background-color") == "rgb(255, 255, 255)")
    {
      $(this).css("background-color","red");
  		var index = $(this).data("index");
      console.log(index)
  		$.post('/',{index: index},function(response){
        console.log(response)
        var index = response.index
  			$("[data-index = "+index+"]").css("background-color","blue");
          if (response.gameOver == true){
            $('#you_lose').css("visibility","visible");
          }
      });
    };
  });
  $(".you_first").on("click",function() {
    $.post('/',{skip: "true"},function(response){
      var index = response.index
      $("[data-index = "+index+"]").css("background-color","blue");
    });
  });
});
