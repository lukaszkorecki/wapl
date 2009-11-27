require 'net/http'
require 'uri'
require 'rexml/document'
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
# tha constructor
 def initialize(new_key, headers)
    raise ArgumentError, "Missing dev key" if new_key.nil?
    @dev_key= new_key
    @header_string = self.parse_headers(headers)
   @api_root="http://webservices.wapple.net"
  end
  def parse_headers(env)
    header_string = ""
     for header in env.select { |k,v| k.match("^HTTP.*") } do
          header_string += header[0]+":"+header[1]+"|"
         end
    return header_string
  end
# make a post request with all _SERVER details
  def send_request(path,arg = {})
    url= URI.parse(@@api_root + @@resources[path].to_s)
    post_arg = {'devKey'=>@dev_key , 'headers'=>@header_string }
    post_arg.merge!(arg)#unless arg.nil?
    res = HTTP.post_form(url, post_arg)
  end

# gets the info about mobile device
  def get_mobile_device()
    res =  self.send_request 'get_mobile_device'
    device_info_xml = REXML::Document.new(res.body).root
    device_info_xml.elements.each do |el|
      res.merge! Hash[el.name.to_s,el.text.to_s]
    end
    return res
    

  end
# checks whether the device is mobile
  def is_mobile_device()
    res = self.send_request 'is_mobile_device'
    return res.body
  end
# submits the wapl markup along with the headers
# brings back proper markup for the current device and required headers
  def get_markup_from_wapl(wapl_xml="")
    raise ArgumentError, "Empty string" if wapl_xml == ""
    res = self.send_request 'get_markup_from_wapl', {'wapl'=>wapl_xml} 
    markup_res_xml = REXML::Document.new(res.body).root
    res = []
    markup_res_xml.elements.each('header/item') { |el| res.push(el.text) }
    headers = {'headers'=>res }
    headers.merge! {'markup ' => elo.elements.collect('markup') { |el| el.cdatas} }
  end
# submits the wapl markup url along with the headers
# brings back proper markup for the current device and required headers
  def get_markup_from_url(makrup_url="")
    raise ArgumentError, "Wrong or empty url" if markup_url == ""
    res = self.send_request 'get_markup_from_url', { 'waplUrl'=>markup_url }
    markup_data = self.process_res_xml res.body
    return {'res'=>res, 'data'=> markup_data}
  end
end

