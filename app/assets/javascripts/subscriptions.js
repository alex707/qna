$(document).on('turbolinks:load', function() {
  $('.question').on('ajax:success', 'a.subscription-button', function (e) {
    var res = e.detail[0];

    if (res === 'ok') {
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
    };
  }).on('ajax:notmodified', 'a.subscription-button', function (e) {
    var res = e.detail[0];

    if (res === 'ok') {
      $('.notice').html("You are don't have any subscriptions on this question");
    }
  });
});
