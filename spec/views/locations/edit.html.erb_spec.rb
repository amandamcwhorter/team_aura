require 'spec_helper'

describe "locations/edit" do
  before(:each) do
    @location = assign(:location, stub_model(Location,
      :company_id => 1,
      :name => "MyString",
      :address1 => "MyString",
      :address2 => "MyString",
      :city => "MyString",
      :state => "MyString",
      :zip => "MyString",
      :phone => "MyString",
      :email => "MyString",
      :primary => false
    ))
  end

  it "renders the edit location form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", location_path(@location), "post" do
      assert_select "input#location_company_id[name=?]", "location[company_id]"
      assert_select "input#location_name[name=?]", "location[name]"
      assert_select "input#location_address1[name=?]", "location[address1]"
      assert_select "input#location_address2[name=?]", "location[address2]"
      assert_select "input#location_city[name=?]", "location[city]"
      assert_select "input#location_state[name=?]", "location[state]"
      assert_select "input#location_zip[name=?]", "location[zip]"
      assert_select "input#location_phone[name=?]", "location[phone]"
      assert_select "input#location_email[name=?]", "location[email]"
      assert_select "input#location_primary[name=?]", "location[primary]"
    end
  end
end
