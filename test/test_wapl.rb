require 'test_helper'
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/wapl'
require 'fakeweb'
class WaplTest < ActiveSupport::TestCase
  # set this if you have one
  attr_accessor :real_key

  def setup
   @real_key = "24958309458"
    FakeWeb.register_uri(:post, 'http://webservices.wapple.net/isMobileDevice.php', { :body => 1.to_s })
    FakeWeb.register_uri(:post, 'http://webservices.wapple.net/getMobileDevice.php', { :body => 
        '<?xml version="1.0" ?>
       <wapple_response>
         <model>iPhone</model>
         <manufacturer>Apple</manufacturer>
         <mobile_device>1</mobile_device>
       </wapple_response>'
       })
  end
  def test_constructor_without_dev_key
    assert Wapl.new
  end
  def test_constructor
    testkey = "testkey"
    wapl = Wapl.new testkey, {}
    assert_equal wapl.dev_key, testkey
    assert_instance_of Wapl, wapl
  end
  def test_setters_and_getters
    wapl = Wapl.new "", {}
    testkey = "testkey"
    wapl.dev_key = testkey
    assert_equal wapl.dev_key, testkey
  end
  def test_headers_constructor_and_parse_headers
    wapl = Wapl.new "testkey", { "elo"=>"test", "HTTP_test" => "test"}
    assert_equal wapl.header_string, "HTTP_test:test|"
    assert_no_match(/elo/, wapl.header_string)
  end
  def test_headers_parser
    wapl = Wapl.new "testkey"
    headers = { "elo"=>"test", "HTTP_test" => "test"}
    wapl.set_headers headers
    assert_equal wapl.header_string, "HTTP_test:test|"
    assert_no_match(/elo/, wapl.header_string)
  end
  def test_communication_success_and_is_mobile_device
      wapl = Wapl.new @real_key, {"HTTP-User-Agent" => "Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1C25 Safari/419.3"}
      resp = wapl.is_mobile_device
      assert_no_match(/Developer key authentication error/i, resp)
      assert_equal resp, '1'
  end
  def test_communication_success_and_get_mobile_device
      wapl = Wapl.new @real_key, {"HTTP-User-Agent" => "Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1C25 Safari/419.3"}
      resp = wapl.get_mobile_device
      assert resp['model']
      assert resp['manufacturer']
      assert resp['mobile_device']
# XXX this might be excessive.... since this might not always yield the same results, but this UA detection/handling is pretty solid ;-)
# lets assume that everything was correctly detcted and 
# we're sure about the results
      assert_match(/iphone/i,resp['model'])
      assert_match(/Apple/i, resp['manufacturer'])
  end
end
