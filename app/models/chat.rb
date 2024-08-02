class Chat < ApplicationRecord
  belongs_to :application, counter_cache: true
  has_many :messages, dependent: :destroy
  validates :number, uniqueness: { scope: :application_id }

  before_create :set_chat_number

  private

  def set_chat_number
    self.number = Utils::GenerateNumbers.generate_number(entity: Chat)
  end
end
