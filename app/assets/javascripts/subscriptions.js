$(document).on('turbolinks:load', function() {
  $('.question').on('ajax:success', 'a.subscription-button', function (event) {
    var response = event.detail[0];

    if (typeof response['errors'] === 'undefined') {
      var current_element = $(this);

      var subscribe_button = $('a.subscription-button.subscribe');
      var unsubscribe_button = $('a.subscription-button.unsubscribe');

      if (response.result === 'unsubscribe') {
        unsubscribe_button.addClass('hidden');
        subscribe_button.removeClass('hidden');

        $('.notice').html('You are unsubscribed for answer questions');
      } else if (response.result === 'subscribe') {
        subscribe_button.addClass('hidden');
        unsubscribe_button.removeClass('hidden');

        $('.notice').html('You are subscribed for answer questions');
      };

      unsubscribe_button.attr("href", ('/subscriptions/' + response.id));
    };
  });
});
