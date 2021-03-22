$(document).on('turbolinks:load', function() {
    $('.votes a').on('ajax:success', function(e) {
        var votableType = e.currentTarget.dataset['resourceType'].toLowerCase();
        var votableId = e.currentTarget.dataset['id'];
        var votableHTMLId = '#' + votableType + '-' + votableId;

        console.log(e)
        $(' .votes__errors').html('');
        $(votableHTMLId + ' .votes__votes-for-count').html(e.detail[0]['votes_for']);
        $(votableHTMLId + ' .votes__votes-against-count').html(e.detail[0]['votes_against']);
        $(votableHTMLId + ' .votes__rating').html(e.detail[0]['rating']);
    })

    $('.votes a').on('ajax:error', function(e) {
        $(' .votes__errors').html('');
        var votableType = e.currentTarget.dataset['resourceType'].toLowerCase();
        var votableId = e.currentTarget.dataset['id'];
        var votableHTMLId = '#' + votableType + '-' + votableId;

        $(votableHTMLId + ' .votes__errors').html('Author can not vote or you should cancel your previous vote');
    })
})