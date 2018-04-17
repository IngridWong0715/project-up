class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = current_user.projects
  end

  def new
    @project = Project.new
  end

  def create
    project = current_user.projects.create(project_params)
    if project.save
      flash[:notice] = "project created successfully"
      redirect_to project_path(project)
    else
      flash[:warning] = "project not created"
      redirect_to root_path
    end
  end

  def show
  end

  def edit
  end

  def update
      if @project.update(project_params)
        flash[:notice] = "project edited successfully"
        redirect_to project_path(@project.id)
      else
        flash[:notice] = "project not edited"
        redirect_to edit_project_path(@project.id)
      end
  end

  def destroy
    @project.destroy
    redirect_to projects_path
  end

  def search
    if !params[:project][:name].empty?
      @projects = Project.find_by_name(current_user, params[:project][:name])
    elsif params[:project][:data][:due]
      @projects = Project.due_in(current_user, params[:project][:data][:due])
    end
    render 'search'
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, :team_id, :user_id, :due_date, data: params[:project][:data].try(:keys))
  end

  def set_project
    @project = Project.find(params[:id])
    if @project.user == current_user || current_user.teams.include?(@project.team)
      @project
    else
      flash[:warning] = "You can only access projects that belong to you and your teams"
      redirect_to root_path
    end
  end
end
