require "test_helper"

class ArticleMailerTest < ActionMailer::TestCase
  test "create" do
    mail = ArticleMailer.create
    assert_equal "Create", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
