class ContentsController < ApplicationController
  before_action :set_content, only: [:show, :edit, :update, :destroy]
  before_action :set_author, only: [:show]
  before_action :verify_is_owner, only: [:index, :edit, :update, :destory]

  include TwitterHelper

  # GET /contents
  # GET /contents.json
  def index
    @contents = Content.where(:author => current_user)
  end

  # GET /contents/1
  # GET /contents/1.json
  def show
    impressionist(@content, "Content View")

    @author = User.where(:id => @content.author).first
    @comments = @content.comments.all
    @comment = @content.comments.build

    @view_count = @content.impressionist_count(:filter=>:all)

    # THIS IS FOR THE DISPLAY MAP
    @geojson = Array.new

    # PUT CONTENTS ON MAP
    # puts @content.kind
    if (@content.kind == "twitter")
      marker_color = '#4099FF'
    else
      marker_color = '#FFCC00'
    end

    unless (@content.longitude.nil? || @content.latitude.nil?) || (@content.longitude == '0' || @content.latitude == '0')
      @geojson << {
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: [
            @content.longitude,
            @content.latitude
          ]
        },
        properties: {
          name: @content.title,
          body: @content.body,
          link: "/contents/" + @content.id.to_s,
          id: @content.id,
          address:
            if (@content.city.present? && @content.state.present?)
              @content.city + ", " + @content.state
            elsif @content.location.present?
              @content.location
            end,
          :'marker-color' => marker_color,
          :'marker-size' => 'small'
        }
      }
    end
    # puts "START MAP OBJECT: "
    # puts @geojson
    # puts "END MAP OBJECT: "

    respond_to do |format|
      format.html
      format.json { render json: @geojson }  # respond with the created JSON object
      # format.js
    end
  end

  # GET /contents/new
  def new
    @content = Content.new
    @author = User.where(:id => @content.author).first
  end

  # GET /contents/1/edit
  def edit
    @author = User.where(:id => @content.author).first

    # THIS IS FOR THE DISPLAY MAP
    @geojson = Array.new

    # PUT CONTENTS ON MAP
    # puts @content.kind
    if (@content.kind == "twitter")
      marker_color = '#4099FF'
    else
      marker_color = '#FFCC00'
    end

    unless (@content.longitude.nil? || @content.latitude.nil?) || (@content.longitude == '0' || @content.latitude == '0')
      @geojson << {
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: [
            @content.longitude,
            @content.latitude
          ]
        },
        properties: {
          name: @content.title,
          body: @content.body,
          link: "/contents/" + @content.id.to_s,
          id: @content.id,
          address:
            if (@content.city.present? && @content.state.present?)
              @content.city + ", " + @content.state
            elsif @content.location.present?
              @content.location
            end,
          :'marker-color' => marker_color,
          :'marker-size' => 'small',
        }
      }
    end
    # puts @geojson

    respond_to do |format|
      format.html
      format.json { render json: @geojson }  # respond with the created JSON object
      # format.js
    end
  end

  # POST /contents
  # POST /contents.json
  def create
    @content = Content.new(content_params)

    if @content.kind == "twitter"
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
    @content.has_comments = "t";

    respond_to do |format|
      if @content.save
        format.html { redirect_to content_path(@content), notice: 'Content was successfully created.' }
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
        format.html { redirect_to content_path(@content), notice: 'Content was successfully updated.' }
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
    # def verify_is_admin
    #   (current_user.nil?) ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.admin?)
    # end

    def verify_is_owner
      if (request.subdomain.present?)
        user = User.where(:username => request.subdomain).first
      else
        user = User.where(:username => "wesadvance").first
      end

      if (current_user == user)
        return
      else
        redirect_to(root_path)
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_content
      @content = Content.friendly.find(params[:id])
    end

    # def set_author
    #   unless request.subdomain.present?
    #     redirect_to root_url
    #   end

    #   @contentAuthor = User.where(:username => request.subdomain).first
    # end
    def set_author
      @contentAuthor = User.where(:id => @content.author).first
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def content_params
      params.require(:content).permit(:title, :author, :body, :image, :external_id, :external_link, :kind, :rating, :location, :address, :city, :state, :country, :postal, :ip, :latitude, :longitude, :is_active, :is_sticky, :has_comments, :created, :updated, :tag_list)
    end
end
