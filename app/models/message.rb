class Message < ApplicationRecord
  searchkick text_middle: [:content]
  belongs_to :chat, counter_cache: true
  validates :number, uniqueness: { scope: :chat_id }

  before_create :set_message_number
  after_commit :reindex_async, on: :create

  private

  def set_message_number
    self.number = Utils::GenerateNumbers.generate_number(entity: self.class)
  end

  def reindex_async
    ReindexJob.perform_later(self)
  end
end
