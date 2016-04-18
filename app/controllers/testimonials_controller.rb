class TestimonialsController < ApplicationController

  before_action :set_testimonial, only: [:show, :edit, :update, :destroy]
  before_action :verify_is_owner, only: [:new, :edit, :update, :destory]

  # GET /testimonials/1
  # GET /testimonials/1.json
  def show
  end

  # GET /testimonials/new
  def new
    @testimonial = Testimonial.new
  end

  # POST /testimonials
  # POST /testimonials.json
  def create
    @testimonial = Testimonial.new(testimonial_params)
    @testimonial.user_id = current_user.id

    respond_to do |format|
      if @testimonial.save
        format.html { redirect_to request.referrer, notice: 'Testimonial was successfully created.' }
        format.json { render :show, status: :created, location: @testimonial }
      else
        format.html { render :new }
        format.json { render json: @testimonial.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /testimonials/1
  # DELETE /testimonials/1.json
  def destroy
    @testimonial.destroy

    respond_to do |format|
      format.html { redirect_to request.referrer, notice: 'Testimonial was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  private
    def verify_is_admin
      (current_user.nil?) ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.admin?)
    end

    def verify_is_owner
      if (current_user == User.where(:id => @testimonial.user_id).first)
        return
      else
        redirect_to(root_path)
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_testimonial
      @testimonial = Testimonial.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def testimonial_params
      params.require(:testimonial).permit(:user_id, :summary, :body, :author, :author_company, :author_title, :link, :image, :created, :created_at, :updated_at)
    end
end
