$ ->
  App.comments = App.cable.subscriptions.create "CommentsChannel",
    connected: ->
      @perform 'follow', id: gon.question_id

    received: (data) ->
      if gon.user_id isnt data['comment'].user_id
        entity = $('ul.' + data['commentable'] + '-' + data['commentable_id'] \
          + '-comments')
        entity.append JST['templates/comment'](data)
