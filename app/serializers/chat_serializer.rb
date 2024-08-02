class ChatSerializer
  include FastJsonapi::ObjectSerializer
  attributes :number, :messages_count

  belongs_to :application
  has_many :messages

  attribute :id, if: ->(_record, _params) { false }
end
