(function() {
  $(document).on("turbolinks:load", function() {
    var element, scrolled;
    $('#new_message').on("keypress", function(e) {
      if (e && e.keyCode === 13) {
        if (!e.shiftKey) {
          e.preventDefault();
          return $(this).submit();
        }
      }
    });
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
    return $('textarea').on('keydown', function() {
      var e, s, v;
      if (event.keyCode === 9) {
        v = $(this).val();
        s = $(this).selectionStart;
        e = $(this).selectionEnd;
        console.log($(this).val());
        $(this).val(v.substring(0, s) + '\u0009' + v.substring(e));
        $(this).selectionStart = $(this).selectionEnd = s + 1;
        return false;
      }
    });
  });

}).call(this);
