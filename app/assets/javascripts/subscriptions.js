$(document).on('turbolinks:load', function() {
  $('.question').on('ajax:success', 'a.subscription-btn', function (e) {
    var res = e.detail[0];

    if (res === 'ok') {
      console.log('111')
      var current_element = $(this);

      var subscribe_button = $('a.subscription-btn.subscribe');
      var unsubscribe_button = $('a.subscription-btn.unsubscribe');

      console.log(unsubscribe_button);
      console.log(subscribe_button);

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
  }).
    on('ajax:error', function (e) {
    });
});
