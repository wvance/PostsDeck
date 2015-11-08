class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_filter :verify_is_admin, only: [:index]
  before_action :verify_is_owner, only: [:index, :show, :edit, :update, :destory]

  def sort
    params[:project].each_with_index do |id, index|
       Project.where(id: id).update_all({position: index+1})
    end
    render nothing: true
  end

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.author = current_user.id

    respond_to do |format|
      if @project.save
        format.html { redirect_to request.referrer, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy

    respond_to do |format|
      format.html { redirect_to request.referrer, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  private
    def verify_is_admin
      (current_user.nil?) ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.admin?)
    end

    def verify_is_owner
      if (current_user == User.where(:id => @project.author).first)
        return
      else
        redirect_to(root_path)
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:title, :author, :image, :technologies, :body, :github_link, :project_link, :start, :end, :location, :created, :edited)
    end
end
