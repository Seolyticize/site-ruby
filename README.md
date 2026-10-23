# Seolyticize for Ruby sites

The analytics tag, the IndexNow key file, deploy notification and server-side events for Rails, Sinatra or any Rack app.

```ruby
# Gemfile
gem "seolyticize-site", git: "https://github.com/Seolyticize/site-ruby"
```

```erb
<%# app/views/layouts/application.html.erb, in <head> %>
<%= Seolyticize::Site.analytics_tag("SITE_KEY", exclude: ["/account/*", "/verify"]) %>
```

```ruby
# config/routes.rb — the IndexNow key at /KEY.txt
get "/KEY.txt", to: Seolyticize::Site.indexnow_key_app("KEY")

Seolyticize::Site.notify_deploy("https://seolyticize.com/api/v1/hooks/deploy/dh_…") # after each deploy
Seolyticize::Site.track_event("SITE_KEY", "https://example.com/pricing", name: "Signup")
```

The site key and IndexNow key come from `onboard_site` ([agent quick start](https://seolyticize.com/AGENTS.md)). License: MIT.
