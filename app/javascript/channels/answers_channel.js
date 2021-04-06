import consumer from "./consumer"

$(document).on('turbolinks:load', function() {

  let id = $('.question').attr('data-id');
  consumer.subscriptions.create({channel: "AnswersChannel", id: id}, {
    connected() {

    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      $('.answers').append(data.answer)
    }
  });

})
