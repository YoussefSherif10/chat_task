class ReindexJob < ApplicationJob
  queue_as :reindex_messages

  def perform(record)
    record.reindex
  end
end
