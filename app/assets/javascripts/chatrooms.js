$(document).on("turbolinks:load", function() {

  // submit textarea when enter
  $('#new_message').on("keypress", function(e) {
    if (e && e.keyCode === 13 && !e.shiftKey)  {
        e.preventDefault();
        return $(this).submit();
    }
  });

  // when new-message-send scroll bottom
  let element, scrolled;
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
  
  // Right Panel Toggle Button
  $('#rightPanelCollapse').on('click', function () {
    $('#right-panel').toggleClass('active');
    $('#chatroom').toggleClass('active');
    $('.form').toggleClass('active');
  });

  let chatroom = $("[data-behavior='messages']").data('chatroom-id') 

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

  // emoji
  $(function () {
    $('#message_input').emoji({place: 'before'});
  })


});

// edit chatroom
$(document).on('click', '#editChatroomName', function(e){
  e.preventDefault()
  let editForm = $('[data-behavior="editChatroom"]')
  let originName = $('[data-behavior="editChatroom"] h3').html()
  editForm.html(`
    <input class="form-control col-12 col-md-4 mx-2" type="text" value="${originName}" name="chatroom[name]" id="chatroom_name" />
    <input type="submit" name="commit" value="更新" class="btn btn-dark btn-sm small" id="updateChatroom" data-disable-with="更新" />`)
})

