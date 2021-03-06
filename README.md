# Wapple Architect plugin/library

This package contains a class which enables web developers to stop worrying about handling non-desktop browsers.

By utilizing [Wapple's](http://wapple.net) API for device detection and the [WAPL markup language](http://wapl.info) the websites can be adjusted, rendered and delivered properly to any device.

The package consists of API communication class and a view helper which makes it dead easy to create mobile friendly sites while retaining your standard, "big" version of your webapp untouched.


## The flow
1. A device hits your site
1. Do an API call to detect whether it's a mobile device or not (it's much more sophisticated than simple UA sniffing)
1. Store the result in the session
1. If it's mobile device (you will get to know the model and the maker!) build your view using wapl-helper
1. Do an API call to get the appropriate markup for the device
1. Profit

Wapple Architect preserves your url structure, your SEO and what-not.

## TODO

- wapl markup helper
- more docs
- sinatra example app

## Examples
### Rails

*application controller*

		require 'wapl'
		class ApplicationController < ActionController::Base
			helper :all # include all helpers, all the time
			def detect_mobile
				# get an instance of Wapl class, use your dev key and pas through your headers
				@wapl = Wapl.new "YOUR DEV KEY HERE", request.env
				# check whether the device is a mobile device
				# it's good to save this result in the session
				@is_mobile = @wapl.is_mobile_device 

				# does pretty much the same thing, but als o gets the info about the device
				@device_data = @wapl.get_mobile_device 
			end
			def render_for_mobile
				# grab the view dedicated for mobile
				wapl_xml = render_to_string(:layout  => 'wapl', :template => controller_name+'/wapl/'+action_name)
				logger.info wapl_xml
				# send the WAPL xml 
				resp = @wapl.get_markup_from_wapl wapl_xml
				# get the final markup from the response
				@markup = resp['markup'].to_s
				# use the apropriate headers as well
				resp['headers'].each { |k,v| response.headers[k] = v }
				# render the stuff
				render :inline => @markup
			end
		end

*controller* (test controller)

    require 'wapl'
    class TestController < ApplicationController
    # set up
      before_filter :detect_mobile, :render_for_mobile
      def index
				# check whether the device is mobile, if so - render appropriate stuff
        if @is_mobile.to_i == 1
          self.render_for_mobile
          return
        end
        # proceed as usual
      end

*view* (app/views/test/wapl/index.erb) (can be anywhere you want, but it's good to keep them in one place)

        <easyChars>
          <value>Your mobile phone is: </value>
        </easyChars>
        <% for info in @device_data %>
          <easyChars make_safe="1">
          <value>[b]<%= info[0] %>[/b]: <%= info[1] %></value>
          </easyChars>
        <% end %>

*layout*


    <?xml version="1.0" encoding="UTF-8" ?>
    <wapl xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://wapl.wapple.net/wapl.xsd">
    <head>
      <title>your mobile title</title>
    </head>
     <layout>
       <%= yield %>
     </layout>
    </wapl>

And... That's it.

## Helper Example

You can use the WaplHelper, it's included now in the plugin.
For more information about WAPL markup refer to the [official docs](http://wapl.info/coding-for-the-mobile-web-with-WAPL/chapter/Developing-with-WAPL/).

It's still in development, but it's pretty usable :-)

		<%= chars('wowza!') %>
		<%= chars('[b]elo[/b]',{ :attributes =>{ 'make_safe'=>'false' }, :cell=>{ "class" => "test"}, :row=>{:id=>'duzy'}}) %>
		<%= chars('[b]elo[/b]',{ :attributes =>{ 'make_safe'=>'false' }}) %>
		<%= external_image('http://wapl.info/img/header_wapple.png') %>
		<%= external_image('http://wapl.info/img/header_wapple.png', { :attributes=>{ :file_type => "png", :scale =>"150"} }) %>
		<%= external_image('http://wapl.info/img/header_wapple.png' , { :children => { :safe_mode => "1"}}) %>
		<%= external_image('http://wapl.info/img/header_wapple.png') %>
		<%= external_link("Google", 'http://google.com') %>
		<%= external_link("Google", "http://google.com", { :attributes => { :id => "wgp"}, :image => { :url => "http://wapl.info/img/header_wapple.png"}}  ) %>
		<%= external_link("Google", "http://google.com", { :attributes => { :id => "woop"} }) %>
		<%= external_link("Google", "http://google.com", { :attributes => { :id => "woop"} }) %>

	
Or you can go one level deeper and use just the helper methods (not recommended):

		<% ch = tag('chars', tag('value', "TEST")) %>
		<%= row_cell(ch) %>
		

More  examples and stuff to come - watch this space!

http://gist.github.com/272164

_Copyright (c) 2009 Łukasz Korecki, released under the MIT license_
