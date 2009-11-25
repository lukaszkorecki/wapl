# Wapl

This package contains a class which enables web developers to stop worrying about handling non-desktop browsers.

By utilizing [Wapple's](http://wapple.net) API for device detection and the [WAPL markup language](http://wapl.info) the websites can be adjusted, rendered and delivered properly to any device.

The package consists of API communication class and a view helper which makes it dead easy to create mobile friendly sites while retaining your standard, "big" version of your webapp untouched.


## The flow
1. A device hits your site
1. Do an API call to detect whether it's a mobile device or not (it's much more sophisticated than simple UA sniffing)
1. Store the result in the session
1. If it's mobile device (you will get to know the model and the maker!) build your view using wapl-helper
1. Do an API call to get the apropriate markup for the device
1. Profit

Wapple Architect preserves your url structure, your SEO and what-not.

## Example

Soon :-)


Copyright (c) 2009 Łukasz Korecki, released under the MIT license
