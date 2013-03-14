// (function(d, s, id) {
//   var js, fjs = d.getElementsByTagName(s)[0];
//   if (d.getElementById(id)) return;
//   js = d.createElement(s); js.id = id;
//   js.src = "//connect.facebook.net/en_US/all.js";
//   // "#xfbml=1&appId=371948146237702";
//   fjs.parentNode.insertBefore(js, fjs);
// }(document, 'script', 'facebook-jssdk'));

// Load the SDK's source Asynchronously
// Note that the debug version is being actively developed and might 
// contain some type checks that are overly strict. 
// Please report such bugs using the bugs tool.
(function(d, debug){
   var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
   if (d.getElementById(id)) {return;}
   js = d.createElement('script'); js.id = id; js.async = true;
   js.src = "//connect.facebook.net/en_US/all" + (debug ? "/debug" : "") + ".js";
   ref.parentNode.insertBefore(js, ref);
 }(document, /*debug*/ false));

window.fbAsyncInit = function() {
    FB.init({
      appId  : '371948146237702',
      status : false, // check login status
      cookie : true, // enable cookies to allow the server to access the session
      xfbml  : true  // parse XFBML
    });

		FB.Event.subscribe('edge.create', function(response) {
			// alert('You liked the URL: ' + response); 
			site_wide_namespace.trackSocial('facebook', 'like', response);
		});

		FB.Event.subscribe('edge.remove', function(response) {
		  site_wide_namespace.trackSocial('facebook', 'unlike', response);
		});
		
		FB.Event.subscribe('message.send', function(response) {
			site_wide_namespace.trackSocial('facebook', 'send', response);
		});

		FB.Event.subscribe('comment.create', function(response) {
			site_wide_namespace.trackSocial('facebook', 'commented', response);
		});
		
		FB.Event.subscribe('comment.remove', function(response) {
			site_wide_namespace.trackSocial('facebook', 'uncommented', response);
		});
		
	};
	
