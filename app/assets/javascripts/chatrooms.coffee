# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on "turbolinks:load", ->
    $('#new_message').on "keypress", (e) ->
        if e && e.keyCode == 13
            if (!e.shiftKey)
                e.preventDefault()
                $(this).submit()


    scrolled = false
    if !scrolled
        element = $('[data-behavior=\'messages\']')
        element.animate { scrollTop: element.prop('scrollHeight') }, 200

    $('[data-behavior=\'messages\']').on 'scroll', ->
      scrolled = true

    $('textarea').on 'keydown', ->
      if event.keyCode == 9
        v = $(this).val()
        s = $(this).selectionStart
        e = $(this).selectionEnd
        console.log($(this).val())
        $(this).val(v.substring(0, s) + '\u0009' + v.substring(e))
        $(this).selectionStart = $(this).selectionEnd = s + 1
        return false
      return

