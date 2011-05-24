require 'spec_helper'
require 'faker'

describe "Microposts" do
  before(:each) do
    user = Factory(:user)
    visit signin_path
    fill_in :email, :with => user.email
    fill_in :password, :with => user.password
    click_button
  end
  
  describe "creation" do
    describe "failure" do
      it "should not make a new micropost" do
        lambda do
          visit root_path
          fill_in :micropost_content, :with => ""
          click_button
          response.should render_template('pages/home')
          response.should have_selector("div#error_explanation")
        end.should_not change(Micropost, :count)
      end
    end
    
    describe "success" do
      it "should make a new micropost" do
        content = "Lorem ipsum dolor sit amet"
        lambda do
          visit root_path
          fill_in :micropost_content, :with => content
          click_button
          response.should have_selector("span.content", :content => content)
        end.should change(Micropost, :count).by(1)
      end
    end
  end
  
  describe "show" do
    before(:each) do
      31.times do
        visit root_path
        fill_in :micropost_content, :with => Faker::Lorem.sentence(5)
        click_button
      end
    end
    
    it "should paginate microposts" do
      visit root_path
      response.should have_selector("div.pagination")
      response.should have_selector("span.disabled", :content => "Previous")
      response.should have_selector("a", :href => "/?page=2",
                                         :content => "2")
      response.should have_selector("a", :href => "/?page=2",
                                         :content => "Next")
    end
    
    it "should not show other users microposts" do
      wrong_user = Factory(:user, :email => Factory.next(:email))
      wrong_micropost = Factory(:micropost, :user => wrong_user)
      response.should_not have_selector("a", :href => "microposts/#{wrong_micropost.id}")
    end
  end
end
