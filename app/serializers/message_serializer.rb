class MessageSerializer
  include FastJsonapi::ObjectSerializer
  attributes :number, :content

  belongs_to :chat

  attribute :id, if: ->(_record, _params) { false }
end
