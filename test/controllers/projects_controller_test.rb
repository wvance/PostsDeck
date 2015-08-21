require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  setup do
    @project = projects(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project" do
    assert_difference('Project.count') do
      post :create, project: { body: @project.body, created: @project.created, edited: @project.edited, end: @project.end, github_link: @project.github_link, link: @project.link, linkedin_link: @project.linkedin_link, location: @project.location, start: @project.start, title: @project.title }
    end

    assert_redirected_to project_path(assigns(:project))
  end

  test "should show project" do
    get :show, id: @project
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @project
    assert_response :success
  end

  test "should update project" do
    patch :update, id: @project, project: { body: @project.body, created: @project.created, edited: @project.edited, end: @project.end, github_link: @project.github_link, link: @project.link, linkedin_link: @project.linkedin_link, location: @project.location, start: @project.start, title: @project.title }
    assert_redirected_to project_path(assigns(:project))
  end

  test "should destroy project" do
    assert_difference('Project.count', -1) do
      delete :destroy, id: @project
    end

    assert_redirected_to projects_path
  end
end
