$(document).on("turbolinks:load", function() {
  // parent message hover with group
  $(document).on("mouseover", '.message',function(e){
    let parent_id = this.dataset.parent
    msgs = $(`[data-parent='${parent_id}']`)
    $.each(msgs, function(i, msg){
    $(msg).addClass('msg-hover')
    })
  })
  $(document).on("mouseout", '.message',function(e){
    let parent_id = this.dataset.parent
    msgs = $(`[data-parent='${parent_id}']`)
    $.each(msgs, function(i, msg){
    $(msg).removeClass('msg-hover')
    })
  })
})



