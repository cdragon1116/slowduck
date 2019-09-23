jQuery(function() {
  if (Notification.permission === "default") {
    return Notification.requestPermission();
  }
});
