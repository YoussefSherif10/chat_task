class UpdateChatsCountJob < ApplicationJob
  queue_as :update_chats_count

  def perform
    ActiveRecord::Base.transaction do
      Application.find_each(batch_size: 100) do |application|
        application.lock!
        application.update(chats_count: application.chats.count)
      end
    end
  end
end
