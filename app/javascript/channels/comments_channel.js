import consumer from "./consumer"

$(document).on('turbolinks:load', function() {

  let id = $('.question').attr('data-id');
  consumer.subscriptions.create({channel: "CommentsChannel", id: id}, {
    connected() {

    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      $('.comments#' + data.comment.commentable_type.toLowerCase() + '-' + data.comment.commentable_id).append(data.comment.body)
    }
  });

})
