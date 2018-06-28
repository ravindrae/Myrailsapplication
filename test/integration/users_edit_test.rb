require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    if is_logged_in?
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    assert_template 'users/edit'
  end
  end

  test "successful edit" do

  get edit_user_path(@user)
  log_in_as(@user)
  if is_logged_in?
    assert_redirected_to edit_user_path(@user)
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                            email: email,
                                            password:              "",
                                            password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to root_url
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end
end
