# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "turbolinks:load", ->
  # SHOW ABOUT SECTION ON DOCUMENT READY
  # $(document).on "turbolinks:load", ->
  #   $('#about').show 'fade', 1250
  #   return

  # HIDE BUTTON AND SHOW PROJECT ON BUTTON CLICK
  $('#newProjectButton').click ->
  	$('#newProjectButton').hide 'drop', 500, ->
  		$('#newProject').show 'drop', 1000
  		return
  	return

  # HIDE BUTTON AND SHOW POST ON BUTTON CLICK
  $('#newPostButton').click ->
  	$('#newPostButton').hide 'drop', 500, ->
  		$('#newPost').show 'drop', 1000
  		return
  	return

  # HIDE BUTTON AND SHOW POST ON BUTTON CLICK
  $('#newTestimonialButton').click ->
    $('#newTestimonialButton').hide 'drop', 500, ->
      $('#newTestimonial').show 'drop', 1000
      return
    return

  # HIDE BUTTON AND SHOW POST ON BUTTON CLICK
  $('#newServiceButton').click ->
    $('#newServiceButton').hide 'drop', 500, ->
      $('#newService').show 'drop', 1000
      return
    return

  InfiniteRotator = init: ->
    console.log("Successful Rotation")
    #initial fade-in time (in milliseconds)
    initialFadeIn = 1000
    #interval between items (in milliseconds)
    itemInterval = 8000
    #cross-fade time (in milliseconds)
    fadeTime = 2500
    #count number of items
    numberOfItems = $('.rotating-item').length
    #set current item
    currentItem = 0
    #show first item
    $('.rotating-item').eq(currentItem).fadeIn initialFadeIn
    #loop through the items
    if numberOfItems > 1
      infiniteLoop = setInterval((->
        $('.rotating-item').eq(currentItem).fadeOut fadeTime
        if currentItem == numberOfItems - 1
          currentItem = 0
        else
          currentItem++
        $('.rotating-item').eq(currentItem).fadeIn fadeTime
        return
      ), itemInterval)
      return
  InfiniteRotator.init()
  return


