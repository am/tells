require 'test_helper'

class TellsControllerTest < ActionController::TestCase
  setup do
    @tell = tells(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tells)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tell" do
    assert_difference('Tell.count') do
      post :create, tell: { message: @tell.message, name: @tell.name, published: @tell.published }
    end

    assert_redirected_to tell_path(assigns(:tell))
  end

  test "should show tell" do
    get :show, id: @tell
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tell
    assert_response :success
  end

  test "should update tell" do
    put :update, id: @tell, tell: { message: @tell.message, name: @tell.name, published: @tell.published }
    assert_redirected_to tell_path(assigns(:tell))
  end

  test "should destroy tell" do
    assert_difference('Tell.count', -1) do
      delete :destroy, id: @tell
    end

    assert_redirected_to tells_path
  end
end
