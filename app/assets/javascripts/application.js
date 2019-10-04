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
//= require jquery3
//= require jquery_ujs
//= require jquery.atwho
//= require bootstrap-sprockets
//= require popper
//= require_tree .
//= require_tree ./channels
//

$(document).on('turbolinks:load', function(){
  toggleLoad()
  $.rails.refreshCSRFTokens();

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
  var active_chatroom = $(`[data-behavior='messages']`).data('chatroom-id');
  if ($(`[data-behavior='editChatroom']`).length !== 0){
    active_chatroom = $('[data-behavior="editChatroom"]').data('chatroom-id');
  }
  var active_link = $(`[data-behavior='chatroom-link'][data-chatroom-id='${active_chatroom}']`)
  active_link.parent().css('background-color', '#fec52a')
  active_link.parent().children(1).css({'color':'#333', 'font-weight': 700})
  active_link.css({'color':'#333', 'font-weight': 700})


})
 
function toggleLoad() {
    $("#chatroom-loader").removeClass('loader')
}


(function ($) {
	$.fn.emoji = function (params) {
		var defaults = {
			button: '&#x1F642;',
      place: 'after',
			emojis: ['&#x1F642;', '&#x1F641;', '&#x1f600;', '&#x1f601;', '&#x1f602;', '&#x1f603;', '&#x1f604;', '&#x1f605;', '&#x1f606;', '&#x1f607;', '&#x1f608;', '&#x1f609;', '&#x1f60a;', '&#x1f60b;', '&#x1f60c;', '&#x1f60d;', '&#x1f60e;', '&#x1f60f;', '&#x1f610;', '&#x1f611;', '&#x1f612;', '&#x1f613;', '&#x1f614;', '&#x1f615;', '&#x1f616;', '&#x1f617;', '&#x1f618;', '&#x1f619;', '&#x1f61a;', '&#x1f61b;', '&#x1f61c;', '&#x1f61d;', '&#x1f61e;', '&#x1f61f;', '&#x1f620;', '&#x1f621;', '&#x1f622;', '&#x1f623;', '&#x1f624;', '&#x1f625;', '&#x1f626;', '&#x1f627;', '&#x1f628;', '&#x1f629;', '&#x1f62a;', '&#x1f62b;', '&#x1f62c;', '&#x1f62d;', '&#x1f62e;', '&#x1f62f;', '&#x1f630;', '&#x1f631;', '&#x1f632;', '&#x1f633;', '&#x1f634;', '&#x1f635;', '&#x1f636;', '&#x1f637;', '&#x1f638;', '&#x1f639;', '&#x1f63a;', '&#x1f63b;', '&#x1f63c;', '&#x1f63d;', '&#x1f63e;', '&#x1f63f;', '&#x1f640;', '&#x1f643;', '&#x1f4a9;', '&#x1f644;', '&#x2620;', '&#x1F44C;','&#x1F44D;', '&#x1F44E;', '&#x1F648;', '&#x1F649;', '&#x1F64A;'],
			fontSize: '20px',
			listCSS: { border: '1px solid', 'background-color': '#fff', display: 'none'},
			rowSize: 10,
		};
		var settings = {};
		if (!params) {
			settings = defaults;
		} else {
			for (var n in defaults) {
				settings[n] = params[n] ? params[n] : defaults[n];
			}
		}

		this.each(function (n, input) {
			var $input = $(input);

			function showEmoji() {
				$list.show();
				$input.focus();
				setTimeout(function () {
					$(document).on('click', closeEmoji);
				}, 1);
			}

			function closeEmoji() {
				$list.hide();
				$(document).off('click', closeEmoji);
			}

			function clickEmoji(ev) {
				if (input.selectionStart || input.selectionStart == '0') {
					var startPos = input.selectionStart;
					var endPos = input.selectionEnd;
					input.value = input.value.substring(0, startPos)
						+ ev.currentTarget.innerHTML
						+ input.value.substring(endPos, input.value.length);
				} else {
					input.value += ev.currentTarget.innerHTML;
				}

				closeEmoji();
				$input.focus();
				input.selectionStart = startPos + 2;
				input.selectionEnd = endPos + 2;
			}

			var $button = $("<div id='emoji-button-area'>").html(settings.button).css({cursor: 'pointer', 'font-size': settings.fontSize}).on('click', showEmoji);
			var $list = $('<div id=emoji-list>').css(defaults.listCSS).css(settings.listCSS);
			for (var n in settings.emojis) {
				if (n > 0 && n % settings.rowSize == 0) {
				}
				$('<span>').html(settings.emojis[n]).css({cursor: 'pointer', 'font-size': settings.fontSize}).on('click', clickEmoji).appendTo($list);
			}

			if (settings.place === 'before') {
				$button.insertBefore(this);
			} else {
				$button.insertAfter(this);
			}
			$list.insertAfter($input);
		});
		return this;
	};
}
)(jQuery);

