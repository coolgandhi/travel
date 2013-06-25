(function(trips_namespace, $, undefined_) {

  //removing this line per cubiq.org/swipeview comment to re-enable vertical scroll
  // document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);

  var fireSwipe;
  function fireSwipe() {
    var el,
    i,
    page,
    dots = document.querySelectorAll('#navswipe li');
    // dots2 = document.querySelectorAll('#navswipe2 li'),
    trips_namespace.slides = $('#loadjs').data('activities') //this returns an array of hashes formatted in trip_helper.rb

    trips_namespace.gallery = new SwipeView('#swipewrapper', { numberOfPages: trips_namespace.slides.length, hastyPageFlip: true, loop: true, handleMouseSwiping: false });
    // prevent swipeview from resizing itself on orientation change, instead use `resize` event per git issue 16
    // window.removeEventListener('swipeview-touchstart', this.preventDefault(), false);

    window.removeEventListener('orientationchange', trips_namespace.gallery, false);
    window.addEventListener('resize', function(e) {
    trips_namespace.gallery.__resize();
    });

    var total = 3;
    if (trips_namespace.slides.length < 3){
      total = trips_namespace.slides.length;
    }
    // Load initial data
    for (i=0; i<total; i++) {
    page = i==0 ? trips_namespace.slides.length-1 : i-1;
    $.ajax({
      beforeSend: function() {
        $('.swipe_loading_indicator').show();
        $(".swipe_loading_indicator_header").hide();
        },
      type: 'GET',
      url: trips_namespace.slides[page].renderpartial,
      data: {activityid: trips_namespace.slides[page].activityid, layout: trips_namespace.slides[page].layout},
      ajaxI: i, // Capture the current value of 'i'
      dataType: 'html',
      complete: function(){
        $('.swipe_loading_indicator').hide();
        },
      success: function(data){
        $(trips_namespace.gallery.masterPages[this.ajaxI]).append(data);
        picturefill(); //need to call this to get picturefill to fire on ajax loaded pics
        $('.relative_image').resizeToParent({parent: '#bloop'});
        // trips_namespace.bodyBackgroundImageSwitch();
        trips_namespace.daySwatchSwitch();
        trips_namespace.scrollToComments();
        // trips_namespace.makeCaptionAccordion();
        // trips_namespace.fireSwipeViewUsefulButton();
      }
    });
    }

    trips_namespace.gallery.onFlip(function () {
    var el,
      del,
      eel,
      upcoming,
      i;

    var total = 3;
    if (trips_namespace.slides.length < 3){
      total = trips_namespace.slides.length;
    }

    for (i=0; i<total; i++) {
      upcoming = trips_namespace.gallery.masterPages[i].dataset.upcomingPageIndex;

      if (upcoming != trips_namespace.gallery.masterPages[i].dataset.pageIndex) {

        $.ajax({
          beforeSend: function() {
            $('.swipe_loading_indicator').show();
            $(".swipe_loading_indicator_header").hide();
            },
          type: 'GET',
          url: trips_namespace.slides[upcoming].renderpartial,
          data: {activityid: trips_namespace.slides[upcoming].activityid, layout: trips_namespace.slides[upcoming].layout},
          ajaxI: i, // Capture the current value of 'i'
          dataType: 'html',
          complete: function(){
            $('.swipe_loading_indicator').hide();
            },
          success: function(data){
            $(trips_namespace.gallery.masterPages[this.ajaxI]).html(data);
            picturefill(); //need to call this to get picturefill to fire on ajax loaded pics
            $('.relative_image').resizeToParent({parent: '#bloop'});
            // trips_namespace.bodyBackgroundImageSwitch();
            trips_namespace.daySwatchSwitch();
            trips_namespace.scrollToComments();
            // trips_namespace.makeCaptionAccordion();
            trips_namespace.fireSwipeViewUsefulButton();
          }
        });
      }
    }

		
    document.querySelector('#navswipe .selected').className = 'mediaa';
        
    if (trips_namespace.slides[trips_namespace.gallery.pageIndex].layout == 'about_author' )
    {
      dots[dots.length - 1].className = 'mediaa selected';      
    }
    else
    { 
      dots[trips_namespace.slides[trips_namespace.gallery.pageIndex].activityday].className = 'mediaa selected';
    }

    //close the map modal
    trips_activities_namespace.closeMapModal();
    trips_namespace.closeOverviewModal();

    });

    trips_namespace.gallery.onMoveOut(function () {
    trips_namespace.gallery.masterPages[trips_namespace.gallery.currentMasterPage].className = trips_namespace.gallery.masterPages[trips_namespace.gallery.currentMasterPage].className.replace(/(^|\s)swipeview-active(\s|$)/, '');
    });

    trips_namespace.gallery.onMoveIn(function () {
    var className = trips_namespace.gallery.masterPages[trips_namespace.gallery.currentMasterPage].className;
    /(^|\s)swipeview-active(\s|$)/.test(className) || (trips_namespace.gallery.masterPages[trips_namespace.gallery.currentMasterPage].className = !className ? 'swipeview-active' : className + ' swipeview-active');
    });
  }


  $(document).ready(function() {
    if ($('#swipewrapper').length){
      fireSwipe();
    }


		$('ul#navswipe li').click(function(e) {
			if ($(this).index() == 0) {
				$('#trip_overview_modal').modal('show');
				document.querySelector('#navswipe .selected').className = 'mediaa';
				$('#trip_overview').attr('class', 'mediaa selected');
			}
		});
  });

})(window.trips_namespace = window.trips_namespace || {}, jQuery);