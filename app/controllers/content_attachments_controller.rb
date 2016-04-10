class ContentAttachmentsController < ApplicationController
  before_action :set_content_attachment, only: [:show, :edit, :update, :destroy]

  # GET /content_attachments
  # GET /content_attachments.json
  def index
    @content_attachments = ContentAttachment.all
  end

  # GET /content_attachments/1
  # GET /content_attachments/1.json
  def show
  end

  # GET /content_attachments/new
  def new
    @content = Content.where(:id => params[:id]).first
    @content_attachment = ContentAttachment.new
    @content_attachment.content_id = @content.id
  end

  # GET /content_attachments/1/edit
  def edit
  end

  # POST /content_attachments
  # POST /content_attachments.json
  def create
    @content_attachment = ContentAttachment.new(content_attachment_params)
    @content_attachment.user_id = current_user.id


    respond_to do |format|
      if @content_attachment.save
        format.html { redirect_to edit_content_path(@content_attachment.content_id), notice: 'Content attachment was successfully created.' }
        format.json { render :show, status: :created, location: @content_attachment }
      else
        format.html { render :new }
        format.json { render json: @content_attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /content_attachments/1
  # PATCH/PUT /content_attachments/1.json
  def update
    respond_to do |format|
      if @content_attachment.update(content_attachment_params)
        format.html { redirect_to @content_attachment, notice: 'Content attachment was successfully updated.' }
        format.json { render :show, status: :ok, location: @content_attachment }
      else
        format.html { render :edit }
        format.json { render json: @content_attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /content_attachments/1
  # DELETE /content_attachments/1.json
  def destroy
    @content_attachment.destroy
    respond_to do |format|
      format.html { redirect_to edit_content_path(@content_attachment.content_id), notice: 'Content attachment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_content_attachment
      @content_attachment = ContentAttachment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def content_attachment_params
      params.require(:content_attachment).permit(:content_id, :image, :created, :user_id, :description)
    end
end
