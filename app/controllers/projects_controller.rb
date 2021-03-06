class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  authorize_resource

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
    flash[:notice] = "Thank you for your feedback" if params[:from_404] == "want"
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    session[:current_project] = @project.id
  end

  # GET /projects/new
  def new
    @project = Project.new
    @project.workers.build
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.created_by = current_user.id

    project_cycle = ProjectCycle.new(@project)

    respond_to do |format|
      if project_cycle.create
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render action: 'show', status: :created, location: @project }
      else
        format.html { render action: 'new' }
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
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    session[:current_project] = nil if session[:current_project] == @project.id
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :slug, :date, :preprod_start, :preprod_end, :prod_start,:prod_end, :postprod_start, :postprod_end, :document, :from_404, :workers_attributes => [:id, :role, :department, :user_id])
    end
end
