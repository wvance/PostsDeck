class ServicesController < ApplicationController

  before_action :set_service, only: [:show, :edit, :update, :destroy]
  before_action :verify_is_owner, only: [:new, :edit, :update, :destory]

  # GET /services/1
  # GET /services/1.json
  def show
  end

  # GET /services/new
  def new
    @service = Service.new
  end

  # POST /services
  # POST /services.json
  def create
    @service = Service.new(service_params)
    @service.user_id = current_user.id

    respond_to do |format|
      if @service.save
        format.html { redirect_to request.referrer, notice: 'Service was successfully created.' }
        format.json { render :show, status: :created, location: @service }
      else
        format.html { redirect_to request.referrer}
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /service/1
  # DELETE /service/1.json
  def destroy
    @service.destroy

    respond_to do |format|
      format.html { redirect_to request.referrer, notice: 'Service was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  private
    def verify_is_admin
      (current_user.nil?) ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.admin?)
    end

    def verify_is_owner
      if (current_user == User.where(:id => @service.user_id).first)
        return
      else
        redirect_to(root_path)
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_params
      params.require(:service).permit(:user_id, :title, :description, :image, :position, :price, :link)
    end
end
