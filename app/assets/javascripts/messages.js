$(document).on("turbolinks:load", function() {
  // textrea on focus scroll bottom
  $('#message_body').on('focus', function(){
    element = $('[data-behavior=\'messages\']');
    element.animate({
      scrollTop: element.prop('scrollHeight')
    }, 1000);
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
    $(msg).find('.dropdown-menu').html()
  })
})

$(document).on('submit', '#new_message',function(){
  setTimeout(function(){
    let uid = document.cookie.split(/(=)/)[2]
    let msgs = $(`[data-user="${uid}"]`)
    let last_msg = $(msgs[msgs.length - 1])
    last_msg.children('.edit_message_btn').removeClass('d-none')
    $(last_msg).find('.dropdown-menu form').addClass('d-none')
  }, 600)
})


$(document).on('submit', 'form', function(e){
  let msg_id = $(e.currentTarget).parents('.message').data('message')
  setTimeout(function(){
    let msg = $(`[data-message=${msg_id}]`)
    $(msg).children('.edit_message_btn').removeClass('d-none')
    $(msg).find('.dropdown-menu form').addClass('d-none')
  }, 800)
})


// edit message
$(document).on('click', '.edit_message_btn', function(e){
  e.preventDefault()
  let uid = document.cookie.split(/(=)/)[2]
  let msgs = $(`[data-user="${uid}"]`)
  $.each(msgs, function(i, msg){
    reset_edit_message(msg)
  })
  
  let message = $(this).parent()
  let body = message.find('.message-body')
  let form = message.find('.edit-message-form')
  let update_btn = message.children('.update_message_btn')

  body.hide()
  form.removeClass('d-none')
  update_btn.removeClass('d-none')
  $(this).addClass('d-none')

  // resize input
  let input = $(this).parent().find('.edit_input')
  input.height(0).height(input.scrollHeight).change()
  return false
})

$(document).on('click', '.update_message_btn', function(e){
  let message = $(this).parent()
  let input_value = message.find('#message_body').val()
  let form = message.find('.edit-message-form')

  if ( input_value != '' ){
    form.submit()
    return false
  }
})

$(document).on('click', '#message_body', function(){
  return false
})

$(document).on('click', function(){
  let uid = document.cookie.split(/(=)/)[2]
  let msgs = $(`[data-user="${uid}"]`)
  $.each(msgs, function(i, msg){
    reset_edit_message(msg)
  })
})

$(document).on('keypress', '#message_body', function(e){
  if (e.keyCode === 13){
    if (!e.shiftKey){
      e.preventDefault()
      $(e.currentTarget).parent().submit()
    }
  }
})

function reset_edit_message(msg){
  $(msg).find('.flex-grow-1 .message-body').show()
  $(msg).find('.edit-message-form').addClass('d-none')
  $(msg).find('.update_message_btn').addClass('d-none')
  $(msg).find('.edit_message_btn').removeClass('d-none')
}


// input resize
$(document).on( 'change keyup keydown paste cut', '.edit_input', function (){
    $(this).height(0).height(this.scrollHeight);
}).find( 'textarea' ).change();
