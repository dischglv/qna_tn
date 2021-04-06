$(document).on('turbolinks:load', function() {
    $('.new_comment').on('ajax:success', function(e) {
        console.log(e);

    })
})