# expose so that we can call each time new message received
window.scrollToEndOfMessages = () ->
  $('#messages').scrollTop(10000)

# messages container needs an explicit height set for us to manipulate scrollTop
setMessagesContainerHeight = () ->
  $('#messages').height () ->
    return $(window).height() - 200

document.addEventListener "turbolinks:load", () ->
  if window.HTMLOUT?
    window.HTMLOUT.jsCallback("XXX FOO BAR CALLED FROM JS")

  if $('#rooms-show').length
    setMessagesContainerHeight()
    scrollToEndOfMessages()
