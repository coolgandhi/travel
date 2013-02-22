var makeCaptionAccordion;
// using jQuery-UI to make the rightcaption an accordion
makeCaptionAccordion = function() {
var icons = {
    header: " icon-chevron-down",
    activeHeader: " icon-chevron-up"
  };

$(".rightcaption").accordion({
  collapsible: true,
  icons: icons,
  autoHeight: false,
  clearStyle: true
});
};

var bodyBackgroundImageSwitch;
bodyBackgroundImageSwitch = function() {
var timetype = slides[gallery.pageIndex].timetype

switch (timetype) {
 case "1":
 case "2":
    $('div.evening_bg').fadeOut(2000)
    $('div.afternoon_bg').fadeOut(2000)
    $('body').removeClass('afternoon_bg').removeClass('evening_bg')
    $('body').addClass('morning_bg')
    // $('body').animate({ backgroundColor: '#DEEFFA' }, 2000)
    $('div.morning_bg').fadeIn(2000)
    break;
 case "3":
 case "4":
    $('div.morning_bg').fadeOut(2000)
    $('div.evening_bg').fadeOut(2000)
    $('body').removeClass('morning_bg').removeClass('evening_bg')
    $('body').addClass('afternoon_bg')
    // $('body').animate({ backgroundColor: '#8dc0d9' }, 2000)
    $('div.afternoon_bg').fadeIn(2000)
    break;
 case "5":
 case "6":
 case "7":
    $('div.morning_bg').fadeOut(2000)
    $('div.afternoon_bg').fadeOut(2000)
    $('body').removeClass('afternoon_bg').removeClass('morning_bg')
    $('body').addClass('evening_bg')
    // $('body').animate({ backgroundColor: '#365165' }, 2000)
    $('div.evening_bg').fadeIn(2000)
    break;
}
}

// function loaded() {
//     setTimeout(function () {
//     gallery = new SwipeView('#swipewrapper', { numberOfPages: slides.length, hastyPageFlip: true, loop: true });
//   }, 8000);
// }
// window.addEventListener('load', loaded, false);


//removing this line per cubiq.org/swipeview comment to re-enable vertical scroll
// document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);

// var slides = $('#loadjs').data('activities')
// var gallery = new SwipeView('#swipewrapper', { numberOfPages: slides.length, hastyPageFlip: true, loop: true });

var fireSwipe;
function fireSwipe() {
  var el,
  i,
  page,
  dots = document.querySelectorAll('#navswipe li');
  // dots2 = document.querySelectorAll('#navswipe2 li'),
  slides = $('#loadjs').data('activities') //this returns an array of hashes formatted in trip_helper.rb

  gallery = new SwipeView('#swipewrapper', { numberOfPages: slides.length, hastyPageFlip: true, loop: true });
  // prevent swipeview from resizing itself on orientation change, instead use `resize` event per git issue 16
  window.removeEventListener('orientationchange', gallery, false);
  window.addEventListener('resize', function(e) {
  gallery.__resize();
  });

  // Load initial data
  for (i=0; i<3; i++) {
  page = i==0 ? slides.length-1 : i-1;
  $.ajax({
    beforeSend: function() {
      $('.swipe-loading-indicator').show();
      },
    type: 'GET',
    url: slides[page].renderpartial,
    data: {activityid: slides[page].activityid, layout: slides[page].layout},
    ajaxI: i, // Capture the current value of 'i'
    dataType: 'html',
    complete: function(){
      $('.swipe-loading-indicator').hide();
      },
    success: function(data){
      $(gallery.masterPages[this.ajaxI]).append(data);
      picturefill(); //need to call this to get picturefill to fire on ajax loaded pics
      $('.relative_image').resizeToParent({parent: '#bloop'});
      bodyBackgroundImageSwitch();
      makeCaptionAccordion();
    }
  });
  }

  gallery.onFlip(function () {
  var el,
    del,
    eel,
    upcoming,
    i;

  for (i=0; i<3; i++) {
    upcoming = gallery.masterPages[i].dataset.upcomingPageIndex;

    if (upcoming != gallery.masterPages[i].dataset.pageIndex) {

      $.ajax({
        beforeSend: function() {
          $('.swipe-loading-indicator').show();
          },
        type: 'GET',
        url: slides[upcoming].renderpartial,
        data: {activityid: slides[upcoming].activityid, layout: slides[upcoming].layout},
        ajaxI: i, // Capture the current value of 'i'
        dataType: 'html',
        complete: function(){
          $('.swipe-loading-indicator').hide();
          },
        success: function(data){
          $(gallery.masterPages[this.ajaxI]).html(data);
          picturefill(); //need to call this to get picturefill to fire on ajax loaded pics
          $('.relative_image').resizeToParent({parent: '#bloop'});
          bodyBackgroundImageSwitch();
          makeCaptionAccordion();
        }
      });
    }
  }

  document.querySelector('#navswipe .selected').className = '';
  dots[gallery.pageIndex].className = 'selected';

  //scrollTo implementation here for scrolling filmstrip container to go with what's active
  var $scrollTarget = $('.filmstrip').find('li:eq('+ (gallery.pageIndex) + ')');
  $('.filmstrip').scrollTo($scrollTarget, 500, { offset:{ top:-150 } } );

  });

  gallery.onMoveOut(function () {
  gallery.masterPages[gallery.currentMasterPage].className = gallery.masterPages[gallery.currentMasterPage].className.replace(/(^|\s)swipeview-active(\s|$)/, '');
  });

  gallery.onMoveIn(function () {
  var className = gallery.masterPages[gallery.currentMasterPage].className;
  /(^|\s)swipeview-active(\s|$)/.test(className) || (gallery.masterPages[gallery.currentMasterPage].className = !className ? 'swipeview-active' : className + ' swipeview-active');
  });

  return gallery
}

$(document).ready(function() {
  fireSwipe();
});