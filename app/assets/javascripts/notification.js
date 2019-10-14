jQuery(function() {
  if (Notification.permission === "default") {
    return Notification.requestPermission();
  }
});

$(document).on('click', '[data-behavior="notification"]', function(e){
    let id = $(this).data('notification')
    $.ajax({
      url: `/notifications/${id}/mark_as_read`,
      dataType: 'JSON',
      method: 'POST', })
})
