# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.setBrowserClasses = () ->
        $("#file-list").children.addClass("span12")

$(document).ready ->
        $('#new-file-dialog').dialog
                autoOpen: false,
                modal: true,
                height: 165,
                buttons: {
                        "Create": () ->
                                $('#new-file-form').submit()
                        "Cancel": () ->
                                $(this).dialog("close")
                                }
                close: () ->
                        $('#dir').val("")
