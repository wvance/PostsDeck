require 'test_helper'

class ContentsControllerTest < ActionController::TestCase
  setup do
    @content = contents(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contents)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create content" do
    assert_difference('Content.count') do
      post :create, content: { address: @content.address, author: @content.author, body: @content.body, city: @content.city, country: @content.country, created: @content.created, external_id: @content.external_id, external_link: @content.external_link, has_comments: @content.has_comments, image: @content.image, ip: @content.ip, is_active: @content.is_active, kind: @content.kind, latitude: @content.latitude, location: @content.location, longitude: @content.longitude, postal: @content.postal, rating: @content.rating, state: @content.state, title: @content.title, updated: @content.updated }
    end

    assert_redirected_to content_path(assigns(:content))
  end

  test "should show content" do
    get :show, id: @content
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @content
    assert_response :success
  end

  test "should update content" do
    patch :update, id: @content, content: { address: @content.address, author: @content.author, body: @content.body, city: @content.city, country: @content.country, created: @content.created, external_id: @content.external_id, external_link: @content.external_link, has_comments: @content.has_comments, image: @content.image, ip: @content.ip, is_active: @content.is_active, kind: @content.kind, latitude: @content.latitude, location: @content.location, longitude: @content.longitude, postal: @content.postal, rating: @content.rating, state: @content.state, title: @content.title, updated: @content.updated }
    assert_redirected_to content_path(assigns(:content))
  end

  test "should destroy content" do
    assert_difference('Content.count', -1) do
      delete :destroy, id: @content
    end

    assert_redirected_to contents_path
  end
end
