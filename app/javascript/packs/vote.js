$(document).on('turbolinks:load', function() {
    $('.votes__votes-for a').on('ajax:success', function(e) {
        var vote = e.detail[0][0];
        var votableType = vote['votable_type'].toLowerCase();
        var votableId = vote['votable_id'];
        var votableHTMLId = '#' + votableType + '-' + votableId;

        $(' .votes__errors').html('');
        $(votableHTMLId + ' .votes__votes-for-count').html(+ $(votableHTMLId + ' .votes__votes-for-count').text() + 1);
        $(votableHTMLId + ' .votes__rating').html(+ $(votableHTMLId + ' .votes__rating').text() + 1);
    })

    $('.votes__votes-against a').on('ajax:success', function(e) {
        var vote = e.detail[0][0];
        var votableType = vote['votable_type'].toLowerCase();
        var votableId = vote['votable_id'];
        var votableHTMLId = '#' + votableType + '-' + votableId;

        $(' .votes__errors').html('');
        $(votableHTMLId + ' .votes__votes-against-count').html(+ $(votableHTMLId + ' .votes__votes-against-count').text() + 1);
        $(votableHTMLId + ' .votes__rating').html(+ $(votableHTMLId + ' .votes__rating').text() - 1);
    })

    $('.votes__votes-for a').on('ajax:error', function(e) {
        $(' .votes__errors').html('');
        var votableType = e.currentTarget.dataset['resourceType'].toLowerCase();
        var votableId = e.currentTarget.dataset['id'];
        var votableHTMLId = '#' + votableType + '-' + votableId;

        $(votableHTMLId + ' .votes__errors').html('Author can not vote or you should cancel your previous vote');
    })

    $('.votes__votes-against a').on('ajax:error', function(e) {
        $(' .votes__errors').html('');
        var votableType = e.currentTarget.dataset['resourceType'].toLowerCase();
        var votableId = e.currentTarget.dataset['id'];
        var votableHTMLId = '#' + votableType + '-' + votableId;

        $(votableHTMLId + ' .votes__errors').html('Author can not vote or you should cancel your previous vote');
    })

    $('.votes__cancel a').on('ajax:success', function(e) {
        var vote = e.detail[0];
        var votableType = vote['votable_type'].toLowerCase();
        var votableId = vote['votable_id'];
        var voteValue = vote['value'];
        var votableHTMLId = '#' + votableType + '-' + votableId;

        $(' .votes__errors').html('');
        if (voteValue) {
            $(votableHTMLId + ' .votes__votes-for-count').html(+$(votableHTMLId + ' .votes__votes-for-count').text() - 1);
            $(votableHTMLId + ' .votes__rating').html(+$(votableHTMLId + ' .votes__rating').text() - 1);
        } else {
            $(votableHTMLId + ' .votes__votes-against-count').html(+$(votableHTMLId + ' .votes__votes-against-count').text() - 1);
            $(votableHTMLId + ' .votes__rating').html(+$(votableHTMLId + ' .votes__rating').text() + 1);
        }
    })

    $('.votes__cancel a').on('ajax:error', function(e){
        $(' .votes__errors').html('');
        var votableType = e.currentTarget.dataset['resourceType'].toLowerCase();
        var votableId = e.currentTarget.dataset['id'];
        var votableHTMLId = '#' + votableType + '-' + votableId;

        $(votableHTMLId + ' .votes__errors').html('Author can not cancel or you should vote before cancel');
    })
})