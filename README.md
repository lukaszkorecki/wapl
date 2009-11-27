# Wapl

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

*controller* (test controller)

    require 'wapl'
    class TestController < ApplicationController
    # set up
      before_filter :detect_mobile, :render_for_mobile
      def index
        @data
        if @data['mobile_device'].to_i == 1
          self.render_for_mobile
          return
        end
        # proceed as usual
      end
    protected
      def detect_mobile
        # get an instance of Wapl class, use your dev key and pas through your headers
        @wapl = Wapl.new "YOUR_WAPL_ARCHITECT_KEY", request.env
        # check whether the device is a mobile device
        # it's good to save this result in the session
        @is_mobile = @wapl.is_mobile_device 
        # does pretty much the same thing, but als o gets the info about the device
        @data = @wapl.get_mobile_device 
      end
      def render_for_mobile
        # grab the view dedicated for mobile
        wapl_xml = render_to_string(:layout  => 'wapl', :template => 'connector/wapl/index')
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

*view* (app/views/test/wapl/index.erb) (can be anywhere you want, but it's good to keep them in one place)

        <easyChars>
          <value>Your mobile phone is: </value>
        </easyChars>
        <% for info in @data %>
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

More  examples and stuff to come - watch this space!

_Copyright (c) 2009 Łukasz Korecki, released under the MIT license_
