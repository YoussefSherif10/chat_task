class MessageSerializer < BaseSerializer
  attributes :number, :content

  belongs_to :chat
end
