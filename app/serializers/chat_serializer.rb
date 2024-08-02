class ChatSerializer < BaseSerializer
  attributes :number, :messages_count

  belongs_to :application

  attributes :messages do |chat|
    chat.messages.map do |message|
      {
        number: message.number,
        content: message.content
      }
    end
  end
end
