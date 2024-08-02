class UpdateMessagesCountJob < ApplicationJob
  queue_as :update_messages_count

  def perform
    ActiveRecord::Base.transaction do
      Chat.includes(:messages).find_each(batch_size: 100) do |chat|
        chat.lock!
        chat.update(messages_count: chat.messages.count)
      end
    end
  end
end
