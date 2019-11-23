$ ->
  answers = $(".answers")

  App.answers = App.cable.subscriptions.create "AnswersChannel",
    connected: ->
      @perform 'follow', id: gon.question_id
    ,

    received: (data) ->
      answers.append JST['templates/answer'](data)
