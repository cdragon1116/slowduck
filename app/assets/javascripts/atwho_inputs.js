$(document).on("turbolinks:load", function() {
  // textarea mention-tag trigger
  let chatroom = $("[data-behavior='messages']").data('chatroom-id') 
  let edit_chatroom = $("[data-behavior='editChatroom']").data('chatroom-id')
  atwho_users('#message_input', chatroom)
  atwho_users('.search-input', chatroom)
  atwho_users('.edit_input', chatroom)
  atwho_tags('#message_input', chatroom)
  atwho_tags('.search-input', chatroom)
  atwho_tags('.edit_input', chatroom)
  atwho_relative_users('#chatroom_user_user_email', edit_chatroom)
});

function atwho_users(bind_object, chatroom){
  $(bind_object).atwho({ at:"@", 
    searchKey: 'username',
    data: null, 
    insertTpl: "@${username}, " ,
    displayTpl: "<li>${username} <small>${email}</small></li>",
    callbacks: {
      remoteFilter: function(query, callback){
        $.get(`/api/v2/chatrooms/${chatroom}/get_users.json?`, function(data){
          callback(data);
        });
      }
    }
  });
}
function atwho_relative_users(bind_object, chatroom){
  $(bind_object).atwho({ at:"@", 
    searchKey: 'email',
    data: null, 
    insertTpl: "${email}" ,
    displayTpl: "<li class='d-flex align-items-center'><div class='img-profile px-2'>${image}</div><span>${username}-<small>${email}</small></span></li>",
    callbacks: {
      remoteFilter: function(query, callback){
        $.get(`/api/v2/chatrooms/${chatroom}/get_relative_users.json?`, function(data){
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
        $.get(`/api/v2/chatrooms/${chatroom}/get_tags.json?`, function(data){
          callback(data);
        });
      }
    }
  });
}
