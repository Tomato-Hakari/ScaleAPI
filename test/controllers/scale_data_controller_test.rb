require "test_helper"

class ScaleDataControllerTest < ActionDispatch::IntegrationTest
  setup do
    @scale_datum = scale_data(:one)
  end

  test "should get index" do
    get scale_data_url, as: :json
    assert_response :success
  end

  test "should create scale_datum" do
    assert_difference('ScaleDatum.count') do
      post scale_data_url, params: { scale_datum: { date: @scale_datum.date, keydata: @scale_datum.keydata, model: @scale_datum.model, tag: @scale_datum.tag } }, as: :json
    end

    assert_response 201
  end

  test "should show scale_datum" do
    get scale_datum_url(@scale_datum), as: :json
    assert_response :success
  end

  test "should update scale_datum" do
    patch scale_datum_url(@scale_datum), params: { scale_datum: { date: @scale_datum.date, keydata: @scale_datum.keydata, model: @scale_datum.model, tag: @scale_datum.tag } }, as: :json
    assert_response 200
  end

  test "should destroy scale_datum" do
    assert_difference('ScaleDatum.count', -1) do
      delete scale_datum_url(@scale_datum), as: :json
    end

    assert_response 204
  end
end
