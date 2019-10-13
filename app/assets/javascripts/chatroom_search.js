$(document).on("turbolinks:load", function() {
  let chatroom = $("[data-behavior='messages']").data('chatroom-id') 
  // append search box result 
  $('.search-input').on('keypress', function(e){
    let input = $(this).parents('.input-group').children('input.search-input')
    let q = encodeURI(input.val().trim())
    if (e.keyCode === 13 && q !== "" ) {
      if ( q !== "@" | q !== "#" ){
        $(input).val('')
        request = { query: decodeURIComponent(q) }
        search_messages(request , chatroom)
        $('.dropdown-menu').collapse('hide')
      }
    }
  })
  $('.search-btn').on('click', function(e){
    let input = $(this).parents('.input-group').children('input.search-input')
    let q = encodeURI(input.val().trim())
    $(input).val('')
    request = { query: decodeURIComponent(q) }
    search_messages(request , chatroom)
    $('.dropdown-menu').collapse('hide')
  })
});
// mention-link click to search
$(document).on('click','.mention-tag, .mention-user' ,function(e){
    let chatroom = $("[data-behavior='messages']").data('chatroom-id') 
    let q = encodeURI($(this).text())
    request = { query: decodeURIComponent(q) }
    search_messages(request , chatroom)
    e.preventDefault()
})

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
