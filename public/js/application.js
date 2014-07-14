$(document).ready(function() {
  var wait = false
  $(".board td").on("click",function() {
  	if ($(this).css("background-color") == "rgb(255, 255, 255)" && wait == false)
    {
      $(this).css("background-color","red");
      wait = true
  		var index = $(this).data("index");
      console.log(index)
  		$.post('/',{index: index},function(response){
        var index = response.index
  			$("[data-index = "+index+"]").css("background-color","blue");
        wait = false
          if (response.gameOver == true){
            $('#failure_message').css("visibility","visible");
          }
      });
    };
  });
  $(".you_first").on("click",function() {
    if (wait == false)
    {
      wait = true
    $.post('/',{skip: "true"},function(response){
      var index = response.index
      $("[data-index = "+index+"]").css("background-color","blue");
      wait = false
    });
    }
  });
});