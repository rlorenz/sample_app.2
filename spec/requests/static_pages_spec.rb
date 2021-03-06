require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }
      
     describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end
         
        describe "follower/following counts" do
            let(:other_user) { FactoryGirl.create(:user) }
            before do
                other_user.follow!(user)
                visit root_path
            end

            it { should have_link("0 following", href: following_user_path(user)) }
            it { should have_link("1 followers", href: followers_user_path(user)) }
         end
         
        describe "micropost count" do
           before do
               user.feed.delete_all
               fill_in "micropost_content", with: "This is my micropost"
               click_button "Post"
               visit root_path
            end
            
            it { should have_content("micropost") }
            before do
               fill_in "micropost_content", with: "This is my micropost2"
               click_button "Post"
            end
            it { should have_content("2 microposts") }
            
            
        end
         
      describe "pagination" do
        let(:user) { FactoryGirl.create(:user) }
          before do
            30.times { FactoryGirl.create(:micropost, user: user, content: "this is a nice micropost") }
            sign_in user
            visit root_path
          end          
          
            it { should have_selector('div.pagination') }
            
            it "should list each micropost" do
                user.feed.paginate(page: 1).each do |micropost|
                    expect(page).to have_selector('li', text: micropost.content)
                end
            end
        end
    end
  end

  describe "Help page" do
    before { visit help_path }

    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading) { 'About' }
    let(:page_title) { 'About' }
      
    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading) { 'Contact' }
    let(:page_title) { 'Contact' }
      
    it_should_behave_like "all static pages"
  end
    
    it "should have the right links on the layout" do
        visit root_path
        click_link "About"
        expect(page).to have_title(full_title('About Us'))
        click_link "Help"
        expect(page).to have_title(full_title('Help'))
        click_link "Home"
        click_link "Sign up now!"
        expect(page).to have_content('Sign up')
        click_link "sample app"
        expect(page).to have_title(full_title(''))
    end
end