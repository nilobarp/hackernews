require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'should have index method' do
    get :index
    assert_response :success
  end
end
