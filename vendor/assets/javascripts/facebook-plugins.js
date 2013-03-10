(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/en_US/all.js";
  //#xfbml=1&appId=371948146237702";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));

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
	
