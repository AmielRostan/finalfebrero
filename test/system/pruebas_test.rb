require "application_system_test_case"

class PruebasTest < ApplicationSystemTestCase
  setup do
    @prueba = pruebas(:one)
  end

  test "visiting the index" do
    visit pruebas_url
    assert_selector "h1", text: "Pruebas"
  end

  test "creating a Prueba" do
    visit pruebas_url
    click_on "New Prueba"

    fill_in "Name", with: @prueba.name
    click_on "Create Prueba"

    assert_text "Prueba was successfully created"
    click_on "Back"
  end

  test "updating a Prueba" do
    visit pruebas_url
    click_on "Edit", match: :first

    fill_in "Name", with: @prueba.name
    click_on "Update Prueba"

    assert_text "Prueba was successfully updated"
    click_on "Back"
  end

  test "destroying a Prueba" do
    visit pruebas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Prueba was successfully destroyed"
  end
end
