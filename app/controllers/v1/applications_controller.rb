class V1::ApplicationsController < ApplicationController
  before_action :set_application, only: %i[ show update destroy ]

  # GET /applications
  def index
    applications = Application.page(params[:page]).per(params[:per_page])

    render json: ApplicationSerializer.new(applications, meta: pagination_meta(applications)).serialized_json
  end

  # GET /applications/AppToken-1
  def show
    render json: ApplicationSerializer.new(@application).serialized_json
  end

  # POST /applications
  def create
    @application = Application.new(application_params)

    if @application.save
      render json: ApplicationSerializer.new(@application).serialized_json, status: :created, location: v1_application_url(@application)
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /applications/AppToken-1
  def update
    if @application.update(application_params)
      render json: ApplicationSerializer.new(@application).serialized_json
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  # DELETE /applications/AppToken-1
  def destroy
    @application.destroy!
    head :no_content
  end

  private

  def set_application
    @application = Application.find_by(token: params[:token])
  end

  def application_params
    params.require(:application).permit(:name)
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
