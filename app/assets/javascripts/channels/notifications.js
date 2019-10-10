App.notifications = App.cable.subscriptions.create("NotificationsChannel", {
  connected: function() {

  },
  disconnected: function() {

  },
  received: function(data) {
    $('.notification-list').prepend(data.html);
    let unread_count =  Number($('[data-behavior="unread-count"]').html()) + 1
    $('[data-behavior="unread-count"]').html(`${unread_count}`)
  },


});


