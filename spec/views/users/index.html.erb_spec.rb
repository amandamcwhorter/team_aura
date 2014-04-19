require 'spec_helper'

describe "users/index" do
  before(:each) do
    assign(:users, [
      stub_model(User,
        :f_name => "F Name",
        :l_name => "L Name",
        :business_name => "Business Name",
        :email => "Email",
        :password => "Password"
      ),
      stub_model(User,
        :f_name => "F Name",
        :l_name => "L Name",
        :business_name => "Business Name",
        :email => "Email",
        :password => "Password"
      )
    ])
  end

  it "renders a list of users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "F Name".to_s, :count => 2
    assert_select "tr>td", :text => "L Name".to_s, :count => 2
    assert_select "tr>td", :text => "Business Name".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Password".to_s, :count => 2
  end
end