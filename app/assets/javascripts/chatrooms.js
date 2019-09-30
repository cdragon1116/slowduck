$(document).on("turbolinks:load", function() {

  // submit textarea when enter
  $('#new_message').on("keypress", function(e) {
    if (e && e.keyCode === 13) {
      if (!e.shiftKey) {
        e.preventDefault();
        return $(this).submit();
      }
    }
  });

  // when new-message-send scroll bottom
  var element, scrolled;
  scrolled = false;
  if (!scrolled) {
    element = $('[data-behavior=\'messages\']');
    element.animate({
      scrollTop: element.prop('scrollHeight')
    }, 200);
  }
  $('[data-behavior=\'messages\']').on('scroll', function() {
    return scrolled = true;
  });

  // enable keying tab in textarea
  $('textarea').on('keydown', function() {
    var e, s, v;
    if (event.keyCode === 9) {
      v = $(this).val();
      s = $(this).selectionStart;
      e = $(this).selectionEnd;
      $(this).val(v.substring(0, s) + '\u0009' + v.substring(e));
      $(this).selectionStart = $(this).selectionEnd = s + 1;
      return false;
    }
  });

  // Right Panel Toggle Button
  $('#rightPanelCollapse').on('click', function () {
    $('#right-panel').toggleClass('active');
    $('#chatroom').toggleClass('active');
    $('.form').toggleClass('active');
  });

  // textarea mention-tag trigger
  var chatroom = $("[data-behavior='messages']").data('chatroom-id') 
  atwho_users('textarea', chatroom)
  atwho_users('#search-input', chatroom)
  atwho_tags('textarea', chatroom)
  atwho_tags('#search-input', chatroom)

  // append search box result
  $('#search-input').on('keypress', function(e){
    let q = encodeURI($('#search-input').val()).trim()
    if (e && e.keyCode === 13 && q !== "" ) {
      if ( q !== "@" | q !== "#" ){
        $('#search-input').val('')
        request = { query: decodeURIComponent(q) }
        search_messages(request , chatroom)
        return false
      }
    }
  })

  // scroll to see history message
  $('#message-box').scroll(function(){
    if ($('#message-box').scrollTop() == 0){
      let pre_id = $('#inner').children('.message:nth-child(1)').data("message")
      if (pre_id){
        $('.history-loader').css('display','block')
        $.get(`/api/v2/chatrooms/${chatroom}/next_messages.json?pre_id=` + pre_id)
          .then(function(data){
            let messages = data.map(function({content}){
              return `${content}`
            })
            if (messages.length !== 0){
              $('#inner').prepend(messages)
              $('.load-img').css('display','none')
              $('#message-box').scrollTop(50);
            }
            else{
              $('#inner').prepend(`<div class='text-center'>沒東西了啦不要再拉了！！！</div>`)
              $('.history-loader').css('display','none')
            }
          })
      }
    }
  });

  // mention-link click to search
  $('.mention-tag, .mention-user').on('click', function(e){
    e.preventDefault()
    let q = encodeURI($(this).text())
    request = { query: decodeURIComponent(q) }
    search_messages(request , chatroom)
  })

});


function atwho_users(bind_object, chatroom){
  $(bind_object).atwho({ at:"@", 
    searchKey: 'username',
    data: null, 
    insertTpl: "@${username}, " ,
    displayTpl: "<li>${username}-${email}</li>",
    callbacks: {
      remoteFilter: function(query, callback){
        q = $(bind_object).val().split(" ").filter( x => x[0] === '@').slice(-1)[0].slice(1)
        request = { query: decodeURIComponent(q) }
        $.get(`/api/v2/chatrooms/${chatroom}/get_users.json?` + jQuery.param(request), function(data){
          callback(data);
        });
      }
    }
  });
}
function atwho_tags(bind_object, chatroom){
  $(bind_object).atwho({ at:"#", 
    searchKey: 'tagname',
    data: null, 
    limit: 10,
    insertTpl: "${tagname} ",
    displayTpl: "<li>${tagname}</li>",
    callbacks: {
      remoteFilter: function(query, callback){
        q = $(bind_object).val().split(" ").filter( x => x[0] === '#').slice(-1)[0]
        request = { query: decodeURIComponent(q) }
        $.get(`/api/v2/chatrooms/${chatroom}/get_tags.json?` + jQuery.param(request), function(data){
          callback(data);
        });
      }
    }
  });
}
function search_messages(request, chatroom){
  $('#search-result').empty()
  if (!$('#right-panel').hasClass('active')){
    $('#right-panel').addClass('active');
    $('#chatroom').addClass('active');
  }
  $('.result-loader').removeClass("d-none");
  $.get(`/api/v2/chatrooms/${chatroom}/get_messages.json?` + jQuery.param(request))
    .then(function(data){
      let messages = data.map(function({content}){
        return `${content}`
      })
      if (messages.length === 0 ){
        messages = [`<div class='navbar'><h2>搜不到啦,想好再搜可以嗎!!!</h2></div>`]
      }
      $('#search-result').html(messages)
      $('.result-loader').addClass("d-none");
    })
}

