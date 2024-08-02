class ApplicationSerializer < BaseSerializer
  attributes :name, :token, :chats_count

  has_many :chats
end
