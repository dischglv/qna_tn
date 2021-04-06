import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected() {

  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    $('.questions').append(data.question)
  }
});
