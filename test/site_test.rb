# frozen_string_literal: true

require "minitest/autorun"
require_relative "../lib/seolyticize/site"

class SiteTest < Minitest::Test
  def test_analytics_tag
    tag = Seolyticize::Site.analytics_tag("abc123", exclude: ["/app/*", "/verify"], track: ["outbound"])
    assert_includes tag, 'data-site="abc123"'
    assert_includes tag, 'data-exclude="/app/*,/verify"'
    assert_includes tag, 'data-track="outbound"'
    assert_includes tag, 'src="https://seolyticize.com/a.js"'
    refute_includes Seolyticize::Site.analytics_tag('"><x'), '"><x'
  end

  def test_indexnow_key_app
    status, headers, body = Seolyticize::Site.indexnow_key_app("k123").call({})
    assert_equal 200, status
    assert headers["content-type"].start_with?("text/plain")
    assert_equal ["k123"], body
  end
end
