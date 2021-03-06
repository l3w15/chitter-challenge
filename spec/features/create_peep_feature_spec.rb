require 'web_helpers'

feature "Create peep" do
  scenario "User adds a peep" do
    visit '/peeps'
    sign_up_as_fred
    click_on "Create a peep"
    fill_in("text", with: "I love blooody dolphins. They are bloomin' marvellous")
    click_on "Create this peep"
    expect(page).to have_content "bloomin' marvellous"
  end
end
