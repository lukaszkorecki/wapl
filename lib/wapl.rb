# Wapl
require 'net/http'
require 'uri'
require 'rexml/document'
class Wapl
	include ::Net
	attr_accessor :dev_key
# api root
   @@api_root="http://webservices.wapple.net"
   def self.api_root
	   @@api_root
   end
# RESTy resources
   @@resources = {
	   "is_mobile_device"=>"/isMobileDevice.php",
	   "get_mobile_device"=>"/getMobileDevice.php",
	   "get_markup_from_wapl"=>"/getMarkupFromWapl.php",
	   "get_markup_from_url"=>"/getMarkupFromUrl.php"
   }
	def self.resources
		@@resources
	end
# tha constructor
	def initialize(new_key)
		@dev_key= new_key
	end
# make a post request with all _SERVER details
	def send_request(path,data)
		url= URI.parse(@@api_root + @@resources[path].to_s)
		post_data = {'devKey'=>@dev_key }.merge! data
		res = HTTP.post_form url, post_data

	end
	def process_res_xml(x)
		xml = REXML::Document.new x
		res = {}
		xml.root.elements.each do |el|
			res.merge! Hash[el.name.to_s,el.text.to_s]
		end
		return res
	end
# gets the info about mobile device
	def get_mobile_device(headers)
		res =  self.send_request 'get_mobile_device', {'headers'=>headers}
		h = self.process_res_xml res.body

	end
# checks whether the device is mobile
	def is_mobile_device(headers)
		res = self.send_request 'is_mobile_device', {'headers'=>headers}
		return res.body
	end
end

