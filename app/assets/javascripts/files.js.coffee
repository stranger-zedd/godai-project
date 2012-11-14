# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.setBrowserClasses = () ->
        $('#file-list').children.addClass('span12')

$(document).ready ->
        $('#create-new-folder').click ->
                $('#new-folder-form').submit()

        $('#cancel-new-folder').click ->
                $('#new-folder-dialog').modal('hide')