require "test_helper"

class TextsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get texts_index_url
    assert_response :success
  end
end
