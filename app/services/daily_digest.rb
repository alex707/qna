module Services
  # dayly digest to email of new questions
  class DailyDigest
    def send_digest
      User.find_each do |user|
        DailyDigestMailer.digest(user).deliver_later
      end
    end
  end
end
