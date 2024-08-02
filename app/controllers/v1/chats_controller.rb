class V1::ChatsController < ApplicationController
  before_action :set_application
  before_action :set_chat, only: %i[show update destroy search_messages]

  # GET /applications/:token/chats
  def index
    chats = @application.chats.page(params[:page]).per(params[:per_page])
    render json: ChatSerializer.new(chats, meta: pagination_meta(chats)).serialized_json
  end

  # GET /applications/:token/chats/:number
  def show
    render json: ChatSerializer.new(@chat).serialized_json
  end

  # POST /applications/:token/chats
  def create
    @chat = @application.chats.new(chat_params.merge(number: next_chat_number))
    if @chat.save
      render json: ChatSerializer.new(@chat).serialized_json, status: :created, location: v1_application_chat_path(@application.token, @chat.number)
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /applications/:token/chats/:number
  def update
    if @chat.update(chat_params)
      render json: ChatSerializer.new(@chat).serialized_json
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
    messages = Message.search(params[:message_query], fields: [:content], match: :word_middle, where: { chat_id: @chat.id }, page: params[:page], per_page: params[:per_page])
    render json: MessageSerializer.new(messages, meta: pagination_meta(messages)).serialized_json
  end

  private

  def set_application
    @application = Application.find_by!(token: params[:token])
  end

  def set_chat
    @chat = @application.chats.find_by!(number: params[:number])
  end

  def chat_params
    params.require(:chat).permit(:messages_count)
  end

  def next_chat_number
    @application.chats.maximum(:number).to_i + 1
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
