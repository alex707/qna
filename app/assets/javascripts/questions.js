$(document).on('turbolinks:load', function(){
  $('.question').on('click', '.edit-question-link', function(e){
    e.preventDefault();
    $(this).hide();
    var questionId = $(this).data('questionId');
    $('form#edit-question-' + questionId).removeClass('hidden');
  });


  $('a.vote-question').on('ajax:success', function (e) {
    var res = e.detail[0];

    if (res == 'ok') {
      var current_element = $(this);
      var parent_id = current_element.data('parentId');

      var liked_button = $('a.vote-question.liked[data-parent-id=' + parent_id + ']')
      var like_button = $('a.vote-question.like[data-parent-id=' + parent_id + ']')

      var disliked_button = $('a.vote-question.disliked[data-parent-id=' + parent_id + ']')
      var dislike_button = $('a.vote-question.dislike[data-parent-id=' + parent_id + ']')

      if (current_element.html() == 'Liked') {
        var count = $('.likes').html();
        count = parseInt(count);
        $('.likes').html(count - 1);

        liked_button.addClass('hidden');
        like_button.removeClass('hidden');
      } else if (current_element.html() == 'Disliked') {
        var count = $('.dislikes').html();
        count = parseInt(count);
        $('.dislikes').html(count - 1);

        disliked_button.addClass('hidden');
        dislike_button.removeClass('hidden');
      } else if (current_element.html() == 'Like') {
        var count = $('.likes').html();
        count = parseInt(count);
        $('.likes').html(count + 1);

        if (dislike_button.hasClass('hidden')) {
          var count = $('.dislikes').html();
          count = parseInt(count);
          $('.dislikes').html(count - 1);

          disliked_button.addClass('hidden');
          dislike_button.removeClass('hidden');
        };

        like_button.addClass('hidden');
        liked_button.removeClass('hidden');
      } else if (current_element.html() == 'Dislike') {
        var count = $('.dislikes').html();
        count = parseInt(count);
        $('.dislikes').html(count + 1);

        if (like_button.hasClass('hidden')) {
          var count = $('.likes').html();
          count = parseInt(count);
          $('.likes').html(count - 1);

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
      console.log(e.detail[0])

      $.each(errors, function (index, value) {
        $('.question-errors').append('<p>' + value + '</p>')
      });
    });
});
