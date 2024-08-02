class V1::MessagesController < ApplicationController
  before_action :set_application
  before_action :set_chat
  before_action :set_message, only: %i[show update destroy]

  # GET /applications/:token/chats/:number/messages
  def index
    messages = @chat.messages.page(params[:page]).per(params[:per_page])
    render json: MessageSerializer.new(messages, meta: pagination_meta(messages)).serialized_json
  end

  # GET /applications/:token/chats/:number/messages/:message_number
  def show
    render json: MessageSerializer.new(@message).serialized_json
  end

  # POST /applications/:token/chats/:number/messages
  def create
    @message = @chat.messages.new(message_params.merge(number: next_message_number))
    if @message.save
      render json: MessageSerializer.new(@message).serialized_json, status: :created, location: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /applications/:token/chats/:number/messages/:message_number
  def update
    if @message.update(message_params)
      render json: MessageSerializer.new(@message).serialized_json
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /applications/:token/chats/:number/messages/:message_number
  def destroy
    @message.destroy!
    head :no_content
  end

  private

  def set_application
    @application = Application.find_by!(token: params[:token])
  end

  def set_chat
    @chat = @application.chats.find_by!(number: params[:number])
  end

  def set_message
    @message = @chat.messages.find_by!(number: params[:message_number])
  end

  def message_params
    params.require(:message).permit(:content)
  end

  def next_message_number
    @chat.messages.maximum(:number).to_i + 1
  end

  def pagination_meta(collection)
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count
    }
  end
end
