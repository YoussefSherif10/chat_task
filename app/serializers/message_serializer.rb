class MessageSerializer < BaseSerializer
  attributes :number, :content

  attributes :chat do |message|
    {
      number: message.chat.number,
      messages_count: message.chat.messages_count
    }
  end
end
