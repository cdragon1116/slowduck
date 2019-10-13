jQuery(function() {
  if (Notification.permission === "default") {
    return Notification.requestPermission();
  }
});
$(document).on("turbolinks:load", function() {
  $('[data-behavior="notification"]').on('click', function(e){
    let id = $(this).data('notification')
    $.ajax({
      url: `/notifications/${id}/mark_as_read`,
      dataType: 'JSON',
      method: 'POST', })
  })
});

$(document).on("turbolinks:load", function() {
  $('[data-behavior="notification"]').on('click', function(e){
    let id = $(this).data('notification')

    $.ajax({
      url: `/notifications/${id}/mark_as_read`,
      dataType: 'JSON',
      method: 'POST', })
  })
});
