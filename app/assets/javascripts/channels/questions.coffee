$ ->
  questionsList = $(".questions-list")

  App.cable.subscriptions.create "QuestionsChannel", {
    connected: ->
      @perform 'follow'
    ,

    received: (data) ->
      questionsList.append data
  }
