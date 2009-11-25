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
		raise ArgumentError, "Missing dev key" if new_key.nil?
		@dev_key= new_key
	end
# make a post request with all _SERVER details
	def send_request(path,data)
		raise ArgumentError, "Missing Path" if path.nil? or path ==""
		raise ArgumentError, "Missing data" if data.nil? or data =={}
		url= URI.parse(@@api_root + @@resources[path].to_s)
		post_data = {'devKey'=>@dev_key }.merge! data
		res = HTTP.post_form url, post_data

	end
	def process_res_xml(xml_data)
		raise ArgumentError, "Empty XML data" if xml_data.nil? or xml_data ==""
		xml = REXML::Document.new xml_data
		res = {}
		xml.root.elements.each do |el|
			res.merge! Hash[el.name.to_s,el.text.to_s]
		end
		return res
	end

	def parse_headers(env)
		header_string = ""
		env.each do |header|
			header_string += header[0]+":"+header[1]+"|"#if header[0] =~ /^HTTP/i
		end
		return header_string
	end
# gets the info about mobile device
	def get_mobile_device(headers)
		raise ArgumentError, "Empty headers" if headers.nil? or headers ==""
		header_string = self.parse_headers headers
		res =  self.send_request 'get_mobile_device', {'headers'=>header_string}
		h = self.process_res_xml res.body
        return header_string

	end
# checks whether the device is mobile
	def is_mobile_device(headers)
		raise ArgumentError, "Empty headers" if headers.nil? or headers ==""
		header_string = self.parse_headers headers
		res = self.send_request 'is_mobile_device', {'headers'=>header_string}
		return res.body
	end
	def get_markup_from_url(makrup_url)
		raise ArgumentError, "Wrong or empty url" if markup_url.nil? or markup_url =="" # validate url
		res = self.send_request 'get_markup_from_url', markup_url
		markup_data = self.process_res_xml res.body
	end
	def get_markup_from_wapl(headers, wapl_xml)
		raise ArgumentError, "Empty string" if wapl_xml.nil?
		REXML::Document.new wapl_xml
		res = self.send_request 'get_markup_from_wapl', markup_url
		markup_data = self.process_res_xml res.body
	end
end

