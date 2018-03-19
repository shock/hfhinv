require 'test_helper'

class DonorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @donor = donors(:one)
  end

  test "should get index" do
    get donors_url
    assert_response :success
  end

  test "should get new" do
    get new_donor_url
    assert_response :success
  end

  test "should create donor" do
    assert_difference('Donor.count') do
      post donors_url, params: { donor: { address2: @donor.address2, address: @donor.address, city: @donor.city, email: @donor.email, first_name: @donor.first_name, last_name: @donor.last_name, phone2: @donor.phone2, phone: @donor.phone, state: @donor.state, zip: @donor.zip } }
    end

    assert_redirected_to donor_url(Donor.last)
  end

  test "should show donor" do
    get donor_url(@donor)
    assert_response :success
  end

  test "should get edit" do
    get edit_donor_url(@donor)
    assert_response :success
  end

  test "should update donor" do
    patch donor_url(@donor), params: { donor: { address2: @donor.address2, address: @donor.address, city: @donor.city, email: @donor.email, first_name: @donor.first_name, last_name: @donor.last_name, phone2: @donor.phone2, phone: @donor.phone, state: @donor.state, zip: @donor.zip } }
    assert_redirected_to donor_url(@donor)
  end

  test "should destroy donor" do
    assert_difference('Donor.count', -1) do
      delete donor_url(@donor)
    end

    assert_redirected_to donors_url
  end
end
