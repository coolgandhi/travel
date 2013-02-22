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

    trips_namespace.gallery = new SwipeView('#swipewrapper', { numberOfPages: trips_namespace.slides.length, hastyPageFlip: true, loop: true });
    // prevent swipeview from resizing itself on orientation change, instead use `resize` event per git issue 16
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
        $('.swipe-loading-indicator').show();
        },
      type: 'GET',
      url: trips_namespace.slides[page].renderpartial,
      data: {activityid: trips_namespace.slides[page].activityid, layout: trips_namespace.slides[page].layout},
      ajaxI: i, // Capture the current value of 'i'
      dataType: 'html',
      complete: function(){
        $('.swipe-loading-indicator').hide();
        },
      success: function(data){
        $(trips_namespace.gallery.masterPages[this.ajaxI]).append(data);
        picturefill(); //need to call this to get picturefill to fire on ajax loaded pics
        $('.relative_image').resizeToParent({parent: '#bloop'});
        trips_namespace.bodyBackgroundImageSwitch();
        trips_namespace.makeCaptionAccordion();
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
            $('.swipe-loading-indicator').show();
            },
          type: 'GET',
          url: trips_namespace.slides[upcoming].renderpartial,
          data: {activityid: trips_namespace.slides[upcoming].activityid, layout: trips_namespace.slides[upcoming].layout},
          ajaxI: i, // Capture the current value of 'i'
          dataType: 'html',
          complete: function(){
            $('.swipe-loading-indicator').hide();
            },
          success: function(data){
            $(trips_namespace.gallery.masterPages[this.ajaxI]).html(data);
            picturefill(); //need to call this to get picturefill to fire on ajax loaded pics
            $('.relative_image').resizeToParent({parent: '#bloop'});
            trips_namespace.bodyBackgroundImageSwitch();
            trips_namespace.makeCaptionAccordion();
          }
        });
      }
    }

    document.querySelector('#navswipe .selected').className = '';
    dots[trips_namespace.gallery.pageIndex].className = 'selected';

    //scrollTo implementation here for scrolling filmstrip container to go with what's active
    var $scrollTarget = $('.filmstrip').find('li:eq('+ (trips_namespace.gallery.pageIndex) + ')');
    $('.filmstrip').scrollTo($scrollTarget, 500, { offset:{ top:-150 } } );

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
  });

})(window.trips_namespace = window.trips_namespace || {}, jQuery);