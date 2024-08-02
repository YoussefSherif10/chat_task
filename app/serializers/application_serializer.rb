class ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :token, :chats_count

  has_many :chats

  attribute :id, if: ->(_record, _params) { false }
end
