$ ->
  answers = $(".answers")

  App.cable.subscriptions.create 'AnswersChannel', {
    connected: ->
      console.log 'connected'
      @perform 'follow', id: gon.question_id
    ,

    received: (data) ->
      console.log JST['templates/answer'](data)
      answers.append JST['templates/answer'](data)
  }
