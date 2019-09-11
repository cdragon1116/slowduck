# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "turbolinks:load", ->
    $('#new_message').on "keypress", (e) ->
        console.log('aaa')
        if e && e.keyCode == 13
            e.preventDefault()
            $(this).submit()
         
