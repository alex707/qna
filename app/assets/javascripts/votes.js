$(document).on('turbolinks:load', function(){
  $('a.vote-btn').on('ajax:success', function (e) {
    var res = e.detail[0];

    if (res === 'ok') {
      var current_element = $(this);
      var parent_id = current_element.data('parentId');
      var parent_klass = current_element.data('parentClass');

      var liked_button = $('a.vote-btn.liked[data-parent-id=' + parent_id + '][data-parent-class=' + parent_klass + ']');
      var like_button = $('a.vote-btn.like[data-parent-id=' + parent_id + '][data-parent-class=' + parent_klass + ']');

      var disliked_button = $('a.vote-btn.disliked[data-parent-id=' + parent_id + '][data-parent-class=' + parent_klass + ']');
      var dislike_button = $('a.vote-btn.dislike[data-parent-id=' + parent_id + '][data-parent-class=' + parent_klass + ']');

      var likes_counter = $('div.' + parent_klass + '-' + parent_id + '-likes');
      var dislikes_counter = $('div.' + parent_klass + '-' + parent_id + '-dislikes');

      if (current_element.html() === 'Liked') {
        var count = likes_counter.html();
        count = parseInt(count);
        likes_counter.html(count - 1);

        liked_button.addClass('hidden');
        like_button.removeClass('hidden');
      } else if (current_element.html() === 'Disliked') {
        var count = dislikes_counter.html();
        count = parseInt(count);
        dislikes_counter.html(count - 1);

        disliked_button.addClass('hidden');
        dislike_button.removeClass('hidden');
      } else if (current_element.html() === 'Like') {
        var count = likes_counter.html();
        count = parseInt(count);
        likes_counter.html(count + 1);

        if (dislike_button.hasClass('hidden')) {
          var count = dislikes_counter.html();
          count = parseInt(count);
          dislikes_counter.html(count - 1);

          disliked_button.addClass('hidden');
          dislike_button.removeClass('hidden');
        };

        like_button.addClass('hidden');
        liked_button.removeClass('hidden');
      } else if (current_element.html() === 'Dislike') {
        var count = dislikes_counter.html();
        count = parseInt(count);
        dislikes_counter.html(count + 1);

        if (like_button.hasClass('hidden')) {
          var count = likes_counter.html();
          count = parseInt(count);
          likes_counter.html(count - 1);

          liked_button.addClass('hidden');
          like_button.removeClass('hidden');
        };

        dislike_button.addClass('hidden');
        disliked_button.removeClass('hidden');
      };

    }
  }).
    on('ajax:error', function (e) {
      var errors = e.detail[0];

      $.each(errors, function (index, value) {
        var current_element = $(this);
        var parent_klass = current_element.data('parentClass');
        $('.' + parent_klass + '-errors').append('<p>' + value + '</p>')
      });
    });
});
