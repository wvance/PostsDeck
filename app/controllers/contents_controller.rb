class ContentsController < ApplicationController
  before_action :set_content, only: [:show, :edit, :update, :destroy]
  before_action :verify_is_admin, only: [:index]
  
  # Need to fix for later
  # before_filter :load_user

  include TwitterHelper

  # GET /contents
  # GET /contents.json
  def index
    @contents = Content.all
  end

  # GET /contents/1
  # GET /contents/1.json
  def show
    @author = User.where(:id => @content.author).first
  end

  # GET /contents/new
  def new
    @content = Content.new
  end

  # GET /contents/1/edit
  def edit
  end

  # POST /contents
  # POST /contents.json
  def create
    @content = Content.new(content_params)

    if @content.kind == "singleTweet" 
      timeline = user_timeline(@@twitter_client, 1)[0]

      @content.title = "Tweet"
      @content.external_id = timeline.id
      @content.body = timeline.text
      @content.author = current_user.id

      if timeline.media[0].present?
        @content.image = timeline.media[0]["media_url"]
      end

      @content.external_link = timeline.url
      if timeline.place.full_name.present?
        @content.location = timeline.place.full_name + ", " + timeline.place.country_code
      end

    elsif @content.kind == "twitter"
      post_multiple_tweets(@@twitter_client, current_user.number_statuses)
    elsif @content.kind == "post"
      @content.author = current_user.id

      # GEO LOCATION: USE PRECISE LAT LONG IF POSSIBLE, OTHERWISE USE IP CONVERSION
      if cookies[:lat_lng] != nil
        @lat_lng = cookies[:lat_lng].split("|")
        @content.latitude = @lat_lng[0]
        @content.longitude = @lat_lng[1]
      else 
        @content.ip = request.remote_ip
      end
      # send_tweet(@content.title, request.fullpath)
    else 
      if cookies[:lat_lng] != nil
        @lat_lng = cookies[:lat_lng].split("|")
        @content.latitude = @lat_lng[0]
        @content.longitude = @lat_lng[1]
      else 
        @content.ip = request.remote_ip
      end
    end

    # SET DATE TIME TO NOW
    @content.created = DateTime.now;
    @content.updated = DateTime.now;

    # FOR NOW ALWAYS SET TO TRUE
    @content.has_comments = true;
    @content.is_active = true;

    respond_to do |format|
      if @content.save
        format.html { redirect_to root_url(subdomain: current_user.subdomain), notice: 'Content was successfully created.' }
        format.json { render :show, status: :created, location: @content }
      else
        format.html { redirect_to root_url(subdomain: current_user.subdomain) }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contents/1
  # PATCH/PUT /contents/1.json
  def update
    respond_to do |format|
      if @content.update(content_params)
        format.html { redirect_to root_url(subdomain: current_user.subdomain), notice: 'Content was successfully updated.' }
        format.json { render :show, status: :ok, location: @content }
      else
        format.html { render :edit }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contents/1
  # DELETE /contents/1.json
  def destroy
    @content.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Content was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def verify_is_admin
      (current_user.nil?) ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.admin?)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_content
      @content = Content.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def content_params
      params.require(:content).permit(:title, :author, :body, :image, :external_id, :external_link, :kind, :rating, :location, :address, :city, :state, :country, :postal, :ip, :latitude, :longitude, :is_active, :has_comments, :created, :updated)
    end
end
