$(document).on('turbolinks:load', function() {
  $('.question').on('ajax:success', 'a.subscription-button', function (e) {
    var result = e.detail[0];

    if (result['errors'] === undefined) {
      var current_element = $(this);

      var subscribe_button = $('a.subscription-button.subscribe');
      var unsubscribe_button = $('a.subscription-button.unsubscribe');

      if (current_element.html() === 'Unsubscribe') {
        unsubscribe_button.addClass('hidden');
        subscribe_button.removeClass('hidden');

        $('.notice').html('You are unsubscribed for answer questions');
      } else if (current_element.html() === 'Subscribe') {
        subscribe_button.addClass('hidden');
        unsubscribe_button.removeClass('hidden');

        $('.notice').html('You are subscribed for answer questions');
      };

      unsubscribe_button.attr("href", ('/subscriptions/' + result.id));
    };
  });
});
