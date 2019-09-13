# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on "turbolinks:load", ->
    $('#new_message').on "keypress", (e) ->
        if e && e.keyCode == 13
            e.preventDefault()
            $(this).submit()


    scrolled = false
    if !scrolled
        element = $('[data-behavior=\'messages\']')
        element.animate { scrollTop: element.prop('scrollHeight') }, 200

    $('[data-behavior=\'messages\']').on 'scroll', ->
      scrolled = true



