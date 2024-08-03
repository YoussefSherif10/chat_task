class V1::ChatsController < ApplicationController
  before_action :set_application
  before_action :set_chat, only: %i[show destroy search_messages]

  # GET /applications/:token/chats
  def index
    chats = @application.chats.includes(:messages).page(params[:page]).per(params[:per_page])
    render json: ChatSerializer.new(chats, meta: pagination_meta(chats)).serialized_json
  end

  # GET /applications/:token/chats/:number
  def show
    render json: ChatSerializer.new(@chat).serialized_json
  end

  # POST /applications/:token/chats
  def create
    @chat = @application.chats.new
    if @chat.save
      render json: ChatSerializer.new(@chat).serialized_json, status: :created, location: v1_application_chat_url(@application.token, @chat.number)
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  # DELETE /applications/:token/chats/:number
  def destroy
    @chat.destroy!
    head :no_content
  end

  # GET /applications/:token/chats/:number/search_messages
  def search_messages
    messages = Message.search(params[:message_query], fields: [:content], where: { chat_id: @chat.id })
    render json: MessageSerializer.new(messages).serialized_json
  end

  private

  def set_application
    @application = Application.find_by(token: params[:application_token])
    unless @application
      render json: { error: 'Application not found' }, status: :not_found
    end
  end

  def set_chat
    @chat = @application.chats.includes(:messages).find_by(number: params[:number])
    unless @chat
      render json: { error: 'Chat not found' }, status: :not_found
    end
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
