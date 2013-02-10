// jQuery(function() {
// //   console.log($('#loadjs').data('activities'));
// // });
//   var makeCaptionAccordion;
//   // using jQuery-UI to make the rightcaption an accordion
//   makeCaptionAccordion = function() {
//     var icons = {
//         header: " icon-chevron-down",
//         activeHeader: " icon-chevron-up"
//       };

//     $(".rightcaption").accordion({
//       collapsible: true,
//       icons: icons,
//       autoHeight: false,
//       clearStyle: true
//     });
//   };

//   var bodyBackgroundImageSwitch;
//   bodyBackgroundImageSwitch = function() {
//     var timetype = slides[gallery.pageIndex].timetype

//     switch (timetype) {
//      case "1":
//      case "2":
//         $('img.evening_bg').fadeOut(2000)
//         $('img.afternoon_bg').fadeOut(2000)
//         $('body').removeClass().addClass('morning_bg')
//         $('img.morning_bg').fadeIn(2000)
//         break;
//      case "3":
//      case "4":
//         $('img.morning_bg').fadeOut(2000)
//         $('img.evening_bg').fadeOut(2000)
//         $('body').removeClass().addClass('afternoon_bg')
//         $('img.afternoon_bg').fadeIn(2000)
//         break;
//      case "5":
//      case "6":
//      case "7":
//         $('img.morning_bg').fadeOut(2000)
//         $('img.afternoon_bg').fadeOut(2000)
//         $('body').removeClass().addClass('evening_bg')
//         $('img.evening_bg').fadeIn(2000)
//         break;
//     }
//   }

//   //removing this line per cubiq.org/swipeview comment to re-enable vertical scroll
//   // document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);

//   var gallery,
//   el,
//   i,
//   page,
//   dots = document.querySelectorAll('#navswipe li'),
//   // dots2 = document.querySelectorAll('#navswipe2 li'),
//   slides = $('#loadjs').data('activities')
//    //this returns an array of hashes formatted in trip_helper.rb
//   ;

//   gallery = new SwipeView('#swipewrapper', { numberOfPages: slides.length, hastyPageFlip: true, loop: true });

//   // Load initial data
//   for (i=0; i<3; i++) {
//     page = i==0 ? slides.length-1 : i-1;

//     $.ajax({
//       type: 'GET',
//       url: slides[page].renderpartial,
//       data: {activityid: slides[page].activityid, layout: slides[page].layout},
//       ajaxI: i, // Capture the current value of 'i'
//       dataType: 'html',
//       success: function(data){
//         $(gallery.masterPages[this.ajaxI]).append(data);
//         picturefill(); //need to call this to get picturefill to fire on ajax loaded pics
//         $('.relative_image').resizeToParent({parent: '#bloop'});
//         bodyBackgroundImageSwitch();
//         makeCaptionAccordion();
//       }
//     });

//     //I added to change text of trip-title-sub-text Day x of X in Location
//     // document.querySelector('span.trip-title-sub-text').innerHTML = ' - Day '+ slides[gallery.pageIndex].activityday + ' of ' + <%=@trip.duration%> + ' in ' + '<%= @trip.location[:place] %>' + ' for <%=@trip.traveler_type[:traveler_type_name]%>';
//   }

//   gallery.onFlip(function () {
//     var el,
//       del,
//       eel,
//       upcoming,
//       i;

//     for (i=0; i<3; i++) {
//       upcoming = gallery.masterPages[i].dataset.upcomingPageIndex;

//       if (upcoming != gallery.masterPages[i].dataset.pageIndex) {

//         $.ajax({
//           type: 'GET',
//           url: slides[upcoming].renderpartial,
//           data: {activityid: slides[upcoming].activityid, layout: slides[upcoming].layout},
//           ajaxI: i, // Capture the current value of 'i'
//           dataType: 'html',
//           success: function(data){
//             $(gallery.masterPages[this.ajaxI]).html(data);
//             picturefill(); //need to call this to get picturefill to fire on ajax loaded pics
//             $('.relative_image').resizeToParent({parent: '#bloop'});
//             bodyBackgroundImageSwitch();
//             makeCaptionAccordion();
//           }
//         });
//       }
//     }

//   document.querySelector('#navswipe .selected').className = '';
//   dots[gallery.pageIndex].className = 'selected';
//   // document.querySelector('#navswipe2 .selected').className = '';
//   // dots2[gallery.pageIndex].className = 'selected';

//     //I added to change text of trip-title-sub-text Day x of X in Location
//     // if (slides[gallery.pageIndex].activityday)
//     // {
//     //   document.querySelector('span.trip-title-sub-text').innerHTML = ' - Day '+ slides[gallery.pageIndex].activityday + ' of ' + <%=@trip.duration%> + ' in ' + '<%= @trip.location[:place] %>' + ' for <%=@trip.traveler_type[:traveler_type_name]%>';
//     // }
//     // else
//     // {
//     //   document.querySelector('span.trip-title-sub-text').innerHTML = ' '
//     // };

//     //scrollTo implementation here for scrolling filmstrip container to go with what's active
//     var $scrollTarget = $('.filmstrip').find('li:eq('+ (gallery.pageIndex) + ')');
//     $('.filmstrip').scrollTo($scrollTarget, 500, { offset:{ top:-150 } } );

//   });

//   gallery.onMoveOut(function () {
//     gallery.masterPages[gallery.currentMasterPage].className = gallery.masterPages[gallery.currentMasterPage].className.replace(/(^|\s)swipeview-active(\s|$)/, '');
//   });

//   gallery.onMoveIn(function () {
//     var className = gallery.masterPages[gallery.currentMasterPage].className;
//     /(^|\s)swipeview-active(\s|$)/.test(className) || (gallery.masterPages[gallery.currentMasterPage].className = !className ? 'swipeview-active' : className + ' swipeview-active');


//   });
// });