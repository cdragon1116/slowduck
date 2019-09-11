require "application_system_test_case"

class ChatroomsTest < ApplicationSystemTestCase
  setup do
    @chatroom = chatrooms(:one)
  end

  test "visiting the index" do
    visit chatrooms_url
    assert_selector "h1", text: "Chatrooms"
  end

  test "creating a Chatroom" do
    visit chatrooms_url
    click_on "New Chatroom"

    fill_in "Name", with: @chatroom.name
    click_on "Create Chatroom"

    assert_text "Chatroom was successfully created"
    click_on "Back"
  end

  test "updating a Chatroom" do
    visit chatrooms_url
    click_on "Edit", match: :first

    fill_in "Name", with: @chatroom.name
    click_on "Update Chatroom"

    assert_text "Chatroom was successfully updated"
    click_on "Back"
  end

  test "destroying a Chatroom" do
    visit chatrooms_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Chatroom was successfully destroyed"
  end
end
