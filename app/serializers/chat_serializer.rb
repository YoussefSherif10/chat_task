class ChatSerializer < BaseSerializer
  attributes :number, :messages_count

  belongs_to :application
  has_many :messages
end
