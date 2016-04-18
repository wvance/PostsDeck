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
