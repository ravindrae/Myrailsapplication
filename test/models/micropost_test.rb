require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup

    @micropost = Micropost.new(content: "First text", user_id:2)
  end


  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content=""
    assert_not @micropost.valid?
  end

  test "content should be at most 100 characters" do
    @micropost.content = "a" * 101
    assert_not @micropost.valid?
  end

end
