# frozen_string_literal: true

require "cgi"
require "json"
require "net/http"
require "uri"

module Seolyticize
  # What a website itself needs from Seolyticize, for Rails, Sinatra or any Rack app.
  #
  #   <%= Seolyticize::Site.analytics_tag("SITE_KEY", exclude: ["/account/*"]) %>
  module Site
    DEFAULT_BASE_URL = "https://seolyticize.com"

    module_function

    # The cookieless analytics <script> for every page's <head>, escaped.
    # Marked html_safe when Rails is loaded.
    def analytics_tag(site_key, exclude: nil, include: nil, track: nil, base_url: DEFAULT_BASE_URL)
      attributes = ["defer", %(data-site="#{CGI.escapeHTML(site_key)}")]
      attributes << %(data-exclude="#{CGI.escapeHTML(exclude.join(","))}") if exclude&.any?
      attributes << %(data-include="#{CGI.escapeHTML(include.join(","))}") if include&.any?
      attributes << %(data-track="#{CGI.escapeHTML(track.join(" "))}") if track&.any?
      attributes << %(src="#{CGI.escapeHTML(base_url.chomp("/"))}/a.js")
      tag = "<script #{attributes.join(" ")}></script>"
      tag.respond_to?(:html_safe) ? tag.html_safe : tag
    end

    # A Rack app serving the IndexNow key file. In Rails' routes.rb:
    #   get "/#{KEY}.txt", to: Seolyticize::Site.indexnow_key_app(KEY)
    def indexnow_key_app(key)
      lambda do |_env|
        [200, { "content-type" => "text/plain; charset=utf-8", "cache-control" => "public, max-age=3600" }, [key]]
      end
    end

    # Tells Seolyticize a deploy finished (hook_url from create_deploy_hook).
    # Without urls the sitemap is compared with the last deploy's; with them,
    # exactly those go to IndexNow.
    def notify_deploy(hook_url, urls: nil)
      post(hook_url, urls.nil? ? {} : { urls: urls }, timeout: 120)
    end

    # Sends one analytics event from the server. Every event from one server
    # address counts as one visitor; send from the browser where you can.
    def track_event(site_key, url, name: "pageview", referrer: nil, props: nil, base_url: DEFAULT_BASE_URL)
      body = { k: site_key, n: name, u: url }
      body[:r] = referrer if referrer
      body[:p] = props if props && !props.empty?
      post("#{base_url.chomp("/")}/api/collect", body, timeout: 10)
      nil
    end

    def post(url, body, timeout:)
      uri = URI(url)
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https", open_timeout: timeout, read_timeout: timeout) do |http|
        request = Net::HTTP::Post.new(uri, "content-type" => "application/json", "user-agent" => "seolyticize-ruby-site/0.1.0")
        request.body = JSON.generate(body)
        http.request(request)
      end
      response.body.to_s.empty? ? {} : JSON.parse(response.body)
    end
    private_class_method :post
  end
end
