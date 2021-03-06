require 'test_helper'

class UserTest < ActiveSupport::TestCase
    def setup
      @user = User.new(name: "Example User", email: "user@example.com",password: "password", password_confirmation: "password")
    end

    test "should be valid" do
      assert @user.valid?
    end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email addresses should be unique" do
   duplicate_user = @user.dup
   duplicate_user.email = @user.email.upcase
   @user.save
   assert_not duplicate_user.valid?
 end

 test "email addresses should be saved as lower-case" do
   mixed_case_email = "Foo@ExAMPle.CoM"
   @user.email = mixed_case_email
   @user.save
   assert_equal mixed_case_email.downcase, @user.reload.email
 end

 test "password should be present (nonblank)" do
   @user.password = @user.password_confirmation = " " * 6
   assert_not @user.valid?
 end

 test "password should have a minimum length" do
   @user.password = @user.password_confirmation = "a" * 5
   assert_not @user.valid?
 end

 test "authenticated? should return false for a user with nil digest" do
     assert_not @user.authenticated?(:remember, '')
   end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    ramesh = users(:ramesh)
    abc  = users(:abc)
    assert_not ramesh.following?(abc)
    ramesh.follow(abc)
    assert ramesh.following?(abc)
    assert abc.followers.include?(ramesh)
    ramesh.unfollow(abc)
    assert_not ramesh.following?(abc)
  end

  test "feed should have the right posts" do
    ramesh = users(:ramesh)
    abc  = users(:abc)
    lana    = users(:lana)
    # Posts from followed user
    lana.microposts.each do |post_following|
      assert ramesh.feed.include?(post_following)
    end
    # Posts from self
    ramesh.microposts.each do |post_self|
      assert ramesh.feed.include?(post_self)
    end
    # Posts from unfollowed user
    abc.microposts.each do |post_unfollowed|
      assert_not ramesh.feed.include?(post_unfollowed)
    end
  end

end
