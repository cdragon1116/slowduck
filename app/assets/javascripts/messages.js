$(document).on("turbolinks:load", function() {
  // textrea on focus scroll bottom
  $('#message_body').on('focus', function(){
    element = $('[data-behavior=\'messages\']');
    element.animate({
      scrollTop: element.prop('scrollHeight')
    }, 200);
  });

  // parent message hover with group
  $(document).on("mouseover", '.message',function(e){
    let parent_id = this.dataset.parent
    msgs = $(`[data-parent='${parent_id}']`)
    $.each(msgs, function(i, msg){
      $(msg).addClass('msg-hover')
    })
  });
  $(document).on("mouseout", '.message',function(e){
    let parent_id = this.dataset.parent
    msgs = $(`[data-parent='${parent_id}']`)
    $.each(msgs, function(i, msg){
      $(msg).removeClass('msg-hover')
    })
  });

  let uid = document.cookie.split(/(=)/)[2]
  let msgs = $(`[data-user="${uid}"]`)
  $.each(msgs, function(i, msg){
    $(msg).children('.edit_message_btn').removeClass('d-none')
    a = $(msg).find('.dropdown-menu').html()
  })
})

$(document).on('submit', '#new_message',function(){
  setTimeout(function(){
    let uid = document.cookie.split(/(=)/)[2]
    let msgs = $(`[data-user="${uid}"]`)
    let last_msg = $(msgs[msgs.length - 1])
    last_msg.children('.edit_message_btn').removeClass('d-none')
    a = $(last_msg).find('.dropdown-menu form').addClass('d-none')
  }, 600)
})

$(document).on('submit', 'form', function(e){
  let msg_id = $(e.currentTarget).parents('.message').data('message')
  setTimeout(function(){
    let msg = $(`[data-message=${msg_id}]`)
    $(msg).children('.edit_message_btn').removeClass('d-none')
    a = $(msg).find('.dropdown-menu form').addClass('d-none')
  }, 800)
})

// edit message
$(document).on('click', '.edit_message_btn', function(){
  let id = $(this).parent().data('message')
  $(`[data-message="${id}"] .flex-grow-1 .message-body`).empty()
  $(`#edit_message_${id}`).toggleClass('d-none')
  $(this).parent().children('.update_message_btn').removeClass('d-none')
  $(this).addClass('d-none')
})

$(document).on('click', '.update_message_btn', function(){
  let id = $(this).parent().data('message')
  let input_value = $(`#edit_message_${id} #message_body`).val()
  if ( input_value != '' ){
    $(`#edit_message_${id}`).submit()
  }
})

$(document).on('keypress', '#message_body', function(e){
  if (e.keyCode === 13){
    if (!e.shiftKey){
      e.preventDefault()
      $(e.currentTarget).parent().submit()
    }
  }
})

