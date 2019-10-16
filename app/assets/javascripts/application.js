// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.  //
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
//= require jquery3
//= require jquery_ujs
//= require jquery.atwho
//= require popper 
//= require_tree .
//

// full-page loader
$(function() {
  document.addEventListener('turbolinks:request-start', function() {
    $('.loading-block').removeClass('d-none');
  });

  document.addEventListener("turbolinks:request-end", function(){
    $('.loading-block').addClass('d-none');
  });
});

$(document).on('turbolinks:load', function(e){

  // Toggle the side navigation
  $("#sidebarToggleTop").on('click', function(e) {
    $("body").toggleClass("sidebar-toggled");
    $(".sidebar").toggleClass("toggled");
    $(".form").toggleClass("sidebar-toggled");
    if ($(".sidebar").hasClass("toggled")) {
      $('.sidebar .collapse').collapse('hide');
    }
  });

  // Close any open menu accordions when window is resized below 768px
  $(window).resize(function() {
    if ($(window).width() < 768) {
      $('.sidebar .collapse').collapse('hide');
      $('#right-panel').removeClass('active');
      $('#accordionSidebar').addClass('toggled');
    } else{
      $('#accordionSidebar').removeClass('toggled');
    }
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

  //Close collapse panel when document on click
  if ($(window).width() > 768) {
    $(document).click(function(){
      $('.panel-collapse.in')
        .collapse('hide');
      $('.collapse')
        .collapse('hide');
    });
  }

  // set active_chatroom color
  var active_chatroom = $(`[data-behavior='messages']`).data('chatroom-id');
  if ($(`[data-behavior='editChatroom']`).length !== 0){
    active_chatroom = $('[data-behavior="editChatroom"]').data('chatroom-id');
  }
  let active_link = $(`[data-behavior='chatroom-link'][data-chatroom-id='${active_chatroom}']`)
  active_link.parent().css('background-color', '#fec52a')
  active_link.parent().children(1).css({'color':'#333', 'font-weight': 700})
  active_link.css({'color':'#333', 'font-weight': 700})
})
