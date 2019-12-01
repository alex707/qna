class CommentsChannel < ApplicationCable::Channel
  def follow(params)
    stream_from("questions/#{params['id']}/created_comments")
  end
end
