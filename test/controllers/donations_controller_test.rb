require 'test_helper'

class DonationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @donation = pickups(:one)
  end

  test "should get index" do
    get pickups_url
    assert_response :success
  end

  test "should get new" do
    get new_pickup_url
    assert_response :success
  end

  test "should create donation" do
    assert_difference('Donation.count') do
      post pickups_url, params: { donation: { call_first: @donation.call_first, date_of_contact: @donation.date_of_contact, donor_id: @donation.donor_id, email_receipt: @donation.email_receipt, info_collected_by: @donation.info_collected_by, pickup_date: @donation.pickup_date, special_instructions: @donation.special_instructions } }
    end

    assert_redirected_to pickup_url(Donation.last)
  end

  test "should show donation" do
    get pickup_url(@donation)
    assert_response :success
  end

  test "should get edit" do
    get edit_pickup_url(@donation)
    assert_response :success
  end

  test "should update donation" do
    patch pickup_url(@donation), params: { donation: { call_first: @donation.call_first, date_of_contact: @donation.date_of_contact, donor_id: @donation.donor_id, email_receipt: @donation.email_receipt, info_collected_by: @donation.info_collected_by, pickup_date: @donation.pickup_date, special_instructions: @donation.special_instructions } }
    assert_redirected_to pickup_url(@donation)
  end

  test "should destroy donation" do
    assert_difference('Donation.count', -1) do
      delete pickup_url(@donation)
    end

    assert_redirected_to pickups_url
  end
end
