// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .




$(function() {
    $('.enable-radio-buttons').click(function(){
        var radio_buttons_value = $(this).attr('id');
        $(':radio[value=' + radio_buttons_value + ']').attr('checked', true);
    });

    $('.update-radio-button').focusin(function(){
        var caller_button_id = $(this).attr('id');
        var caller_button_id_array = caller_button_id.split('_');
        var storage = caller_button_id_array[2];
        var radio_button_id = caller_button_id_array[0] + '_' + caller_button_id_array[1] + '_action_' + storage;
        $('#' + radio_button_id).attr('checked', true);
    });

    $('#sync-gists-button').click(function(){
        textareas = $('textarea.update-radio-button');
        var failed = false;

        for(var i = 0; i < textareas.length; i++) {
            var textarea = $(textareas[i])
            if(textarea.val() == '') {
                textarea.addClass('textarea-error');
                failed = true;
            }
            else {
                textarea.removeClass('textarea-error');
            }
        }

        if (failed) {
            alert("You can't set gist file contents empty.");
            return false;
        }
    });
});