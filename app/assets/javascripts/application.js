// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery
//= require jquery_ujs
//= require jquery.atwho
//= require bootstrap-sprockets
//= require popper
//= require_tree .
//= require_tree ./channels
//

$(document).on('turbolinks:load', function(){
  toggleLoad()

  // Toggle the side navigation
  $("#sidebarToggle, #sidebarToggleTop").on('click', function(e) {
    $("body").toggleClass("sidebar-toggled");
    $(".sidebar").toggleClass("toggled");
    $(".form").toggleClass("sidebar-toggled");
    if ($(".sidebar").hasClass("toggled")) {
      $('.sidebar .collapse').collapse('hide');
    };
  });

  // Close any open menu accordions when window is resized below 768px
  $(window).resize(function() {
    if ($(window).width() < 768) {
      $('.sidebar .collapse').collapse('hide');
      $('#accordionSidebar').addClass('toggled');
      $('#right-panel').removeClass('active');
    };
  });
  
  if ($(window).width() < 768) {
    $('#accordionSidebar').addClass('toggled');
  }

  // Prevent the content wrapper from scrolling when the fixed side navigation hovered over
  $('body.fixed-nav .sidebar').on('mousewheel DOMMouseScroll wheel', function(e) {
    if ($(window).width() > 768) {
      var e0 = e.originalEvent,
        delta = e0.wheelDelta || -e0.detail;
      this.scrollTop += (delta < 0 ? 1 : -1) * 30;
      e.preventDefault();
    }
  });

  // Scroll to top button appear
  $(document).on('scroll', function() {
    var scrollDistance = $(this).scrollTop();
    if (scrollDistance > 100) {
      $('.scroll-to-top').fadeIn();
    } else {
      $('.scroll-to-top').fadeOut();
    }
  });

  // Smooth scrolling using jQuery easing
  $(document).on('click', 'a.scroll-to-top', function(e) {
    var $anchor = $(this);
    $('html, body').stop().animate({
      scrollTop: ($($anchor.attr('href')).offset().top)
    }, 1000, 'easeInOutExpo');
    e.preventDefault();
  });

  // Close button action to go Back
  $('.close').on('click', function(){
    history.go(-1);
    return false
  })

  // Keypress ESC goto Index
  // $(window).on('keyup', function(e){
    // if (e.keyCode == 27) document.location.href="/";
    // return false
  // })

  if ($(window).width() > 768) {
    $(document).click(function(){
      $('.panel-collapse.in')
        .collapse('hide');
      $('.collapse')
        .collapse('hide');
    });
  }

  // set active_chatroom color
  var active_chatroom;
  var active_chatroom = $(`[data-behavior='messages']`).data('chatroom-id');
  var active_link = $(`[data-behavior='chatroom-link'][data-chatroom-id='${active_chatroom}']`).parent()
  active_link.css('background-color', '#333')


})

function toggleLoad() {
    $("#chatroom-loader").removeClass('loader')
}




