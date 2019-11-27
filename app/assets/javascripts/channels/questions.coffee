$ ->
  questionsList = $(".questions-list")

  App.cable.subscriptions.create "QuestionsChannel", {
    connected: ->
      console.log 'Connected!'
      @perform 'follow'
    ,

    received: (data) ->
      questionsList.append data
  }
