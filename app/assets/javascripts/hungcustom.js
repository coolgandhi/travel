// More Info Slider
$(document).ready(function(){
    $("#toggle").click(function(){
        $("#panel").slideToggle("slow");
        if ($(this).text() == "Show More"){
          $(this).text("Hide This")
        }
        else{
          $(this).text("Show More")
        };
    });
});
