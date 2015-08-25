# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('#newProjectButton').click ->
  	$('#newProjectButton').hide 'drop', 500, ->
  		$('#newProject').show 'drop', 1000
  		return
  	return
  $('#newPostButton').click ->
  	$('#newPostButton').hide 'drop', 500, ->
  		$('#newPost').show 'drop', 1000
  		return
  	return