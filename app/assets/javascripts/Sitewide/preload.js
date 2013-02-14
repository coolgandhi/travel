//<![CDATA[
 $(window).load(function() { // makes sure the whole site is loaded
	 	 //$("#status").hide();
	   //$("#preloader").hide();
    $("#status").fadeOut(); // will first fade out the loading animation
    $("#preloader").delay(100).fadeOut("slow"); // will fade out the white DIV that covers the website.
		//$("#preloader").fadeOut("slow");
 })
//]]>
