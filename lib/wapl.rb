require 'net/http'
require 'uri'
require 'rexml/document'
# This Class is responsible for communicating with Wapple Mobile Api
# It enables the programmer to completelty mobilize an existing web app
# Without breaking it :-)
# for more info about Wapple Architect please go to http://wapl.info
class Wapl
  include ::Net
  attr_accessor :dev_key, :header_string
# api root
     @@api_root = "http://webservices.wapple.net"
   def self.api_root
     @@api_root
   end
# RESTy resources
   @@resources = {
     "is_mobile_device"	=>"/isMobileDevice.php",
     "get_mobile_device"	=>"/getMobileDevice.php",
     "get_markup_from_wapl"	=>"/getMarkupFromWapl.php",
     "get_markup_from_url"	=>"/getMarkupFromUrl.php"
   }
  def self.resources
    @@resources
  end
  # the constructor
  # Required parameters
  # arch_dev_key:: Your Architect dev key
  # headers:: headers for the request - for rails that would be request.env
  # Returns a new instance of Wapl
  def initialize(arch_dev_key = "", headers = {})
    @dev_key= arch_dev_key
    @header_string = self.parse_headers(headers)
    @api_root="http://webservices.wapple.net"
  end
  def set_headers(headers)
    @header_string = self.parse_headers(headers)
  end
  # Parses the request headers and gets only HTTP_* headers
  # returns properly formatted string of keys and values
  def parse_headers(headers_hash)
    header_string = ""
     for header in headers_hash.select { |k,v| k.match("^HTTP.*") } do
          header_string += header[0]+":"+header[1]+"|"
         end
    return header_string
  end
  # Communicates with the API
  # Does a simple POST call with required arguments
  # Always sends the dev_key and the headers
  # path:: path to the API resource
  # arg:: hash containing additional arguments (see wapl.info docs)
  # Returns HTTP::result object
  def send_request(path,arg = {})
    url= URI.parse(@@api_root + @@resources[path].to_s)
    post_arg = {'devKey'=>@dev_key , 'headers'=>@header_string }
    post_arg.merge!(arg)
    res = HTTP.post_form(url, post_arg)
  end

  # gets the info about mobile device
  # Returns a Hash containing information model and the maker
  def get_mobile_device()
    res =  self.send_request 'get_mobile_device'
    device_info_xml = REXML::Document.new(res.body).root
    rez ={}
    device_info_xml.elements.each do |el|
      rez.merge! Hash[el.name.to_s,el.text.to_s]
    end
    return rez
  end
  # checks whether the device is mobile
  # Returns 1 for true and 0 for a desktop browser
  def is_mobile_device()
    res = self.send_request 'is_mobile_device'
    return res.body
  end
# Submits the wapl markup along with the headers
# wapl_xml:: Properly formatted WAPL XML (see docs at htp://wapl.info) or use the WaplHelper module
# Returns hash containing
# * proper markup for the current device
# * required headers which need to be sent back to the device
  def get_markup_from_wapl(wapl_xml="")
    raise ArgumentError, "Empty string" if wapl_xml == ""
    res = self.send_request 'get_markup_from_wapl', {'wapl'=>wapl_xml} 
    unless res.body.scan('WAPL ERROR').empty?
      markup = wapl_xml + "<!-- WAPL XML ERROR #{ res.body } -->"
      headers = ''
    else
      markup_res_xml = REXML::Document.new(res.body).root
      res = {}
      markup_res_xml.elements.each('header/item') do |el|
        splits = el.text.split(': ');
        h = Hash[splits[0], splits[1]]
        res.merge! h
      end
      markup = markup_res_xml.elements.collect('markup') { |el| el.cdatas}
    end
      return {'markup' => markup, 'headers'=>res }
  end
# submits the wapl markup url along with the headers
# brings back proper markup for the current device and required headers
# TODO / FIXME check whether supplied string is a url
  def get_markup_from_url(makrup_url="")
    raise ArgumentError, "Wrong or empty url" if markup_url == ""
    res = self.send_request 'get_markup_from_url', { 'waplUrl'=>markup_url }
    markup_data = self.process_res_xml res.body
    return {'res'=>res, 'data'=> markup_data}
  end
end

