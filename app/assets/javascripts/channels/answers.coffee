$ ->
  answers = $(".answers")

  App.answers = App.cable.subscriptions.create "AnswersChannel",
    connected: ->
      @perform 'follow', id: gon.question_id
    ,

    received: (data) ->
      if gon.user_id isnt data['answer'].user_id
        answers.append JST['templates/answer'](data)
