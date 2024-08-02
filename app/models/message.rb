class Message < ApplicationRecord
  searchkick
  belongs_to :chat, counter_cache: true
  validates :number, uniqueness: { scope: :chat_id }

  before_create :set_message_number
  after_commit :reindex, on: :create

  private

  def set_message_number
    self.number = Utils.GenerateNumbers.generate_number(entity: Message)
  end

  def reindex
    self.reindex
  end
end
