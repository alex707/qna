module Services
  # dayly digest to email of new questions
  class DailyDigest
    def send_digest
      User.find_each(batch_size: 500) do |user|
        DailyDigestMailer.digest(user).deliver_later
      end
    end
  end
end
