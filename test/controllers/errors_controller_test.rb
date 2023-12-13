require "test_helper"

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  test "should get bad_request" do
    get errors_bad_request_url
    assert_response :success
  end

  test "should get unknown_error" do
    get errors_unknown_error_url
    assert_response :success
  end

  test "should get route_not_found" do
    get errors_route_not_found_url
    assert_response :success
  end

  test "should get resource_not_found" do
    get errors_resource_not_found_url
    assert_response :success
  end

  test "should get not_acceptable" do
    get errors_not_acceptable_url
    assert_response :success
  end

  test "should get not_authorized" do
    get errors_not_authorized_url
    assert_response :success
  end

  test "should get internal_server_error" do
    get errors_internal_server_error_url
    assert_response :success
  end

  test "should get service_unavailable" do
    get errors_service_unavailable_url
    assert_response :success
  end
end
