class Application < ApplicationRecord
    has_many :chats, dependent: :destroy
    validates_presence_of :name
    validates_uniqueness_of :token

    before_create :generate_token

    private

    def generate_token
      highest_token = Application.where.not(token: nil).order(token: :desc).first.try(:token)
      highest_number = highest_token ? highest_token.split("-").last.to_i : 1
      new_token = "AppToken-#{highest_number + 1}"
      self.token = new_token
    end
end
