class ApplicationSerializer < BaseSerializer
  attributes :name, :token, :chats_count

  attributes :chats do |application|
    application.chats.map do |chat|
      {
        number: chat.number,
        messages_count: chat.messages_count
      }
    end
  end
end
