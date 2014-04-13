require 'spec_helper'

describe "services/edit" do
  before(:each) do
    @service = assign(:service, stub_model(Service,
      :name => "MyString",
      :description => "MyText",
      :price => "9.99",
      :minutes_duration => 1,
      :company_id => 1,
      :all_staff => false
    ))
  end

  it "renders the edit service form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", service_path(@service), "post" do
      assert_select "input#service_name[name=?]", "service[name]"
      assert_select "textarea#service_description[name=?]", "service[description]"
      assert_select "input#service_price[name=?]", "service[price]"
      assert_select "input#service_minutes_duration[name=?]", "service[minutes_duration]"
      assert_select "input#service_company_id[name=?]", "service[company_id]"
      assert_select "input#service_all_staff[name=?]", "service[all_staff]"
    end
  end
end
