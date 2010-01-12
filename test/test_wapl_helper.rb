
require 'test_helper'
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/wapl_helper'
class WaplTest < ActiveSupport::TestCase
  include WaplHelper
  def test_include_and_require_and_all_that_stuff
    assert tag('chars', 'char')
  end

  def test_tag_start
    assert_equal("<tag>", t_s("tag"))
    assert_equal('<tag test="val">', t_s("tag", 'test="val"'))
  end
  def test_tag_end
    assert_equal("</tag>", t_e("tag"))
  end
  def test_cdatize
    assert_equal("<![CDATA[ test ]]>", cdatize('test'))
    assert_match(/CDATA/, cdatize('ts'))
    
  end
  def test_attr_string
    assert_equal('ole="test"', attr_string({:ole=>"test"}))
  end
  def test_tag
    assert_equal('<t>test</t>', tag('t','test'))
    assert_not_equal('<t>test</t>', tag('t','dest'))
    assert_equal('<t ole="ule">test</t>', tag('t','test',{:ole =>"ule"}))
    assert_not_equal('<t ole="ule" style="display:none;float:left;">test</t>', tag('t','test',{:ole =>"ule"}))
    assert_equal('<t ole="ule" style="display:none;float:left;">test</t>', tag('t','test',{:ole =>"ule", :style => "display:none;float:left;"}))
  end
  def test_row_cell
    assert_equal('<row><cell>test</cell></row>', row_cell('test'))
    assert_equal('<row id="test"><cell class="class">test</cell></row>', row_cell('test', {:class=>"class"}, {:id=>"test"}))
    assert_not_equal('<row class="class"><cell id="test">test</cell></row>', row_cell('test', {:class=>"class"}, {:id=>"test"}))
  end
  def test_children_list
    children= {:url=>"http://google.com", :value=>"test"}
    assert_match("<url>http://google.com</url>", children_list(children))
    assert_match("<value>test</value>", children_list(children))
  end

  def test_chars
    char_str = "<row><cell><chars><value>test</value></chars></cell></row>"
    assert_equal(char_str, chars("test"))

    char_str_2 = '<row><cell><chars make_safe="true"><value>test</value></chars></cell></row>'
    assert_equal(char_str_2, chars('test', { :attributes=>{ :make_safe =>"true"}}))

    char_str_3 = '<row id="test"><cell><chars make_safe="true"><value>test</value></chars></cell></row>'
    assert_equal(char_str_2, chars('test', { :attributes=>{ :make_safe =>"true"}}))
  end
  def test_external_image
    ext_img  ='<row><cell><externalImage><url>http://localhost/1.gif</url></externalImage></cell></row>'
    ext_img_element_only  ='<externalImage><url>http://localhost/1.gif</url></externalImage>'
    assert_equal(ext_img, external_image('http://localhost/1.gif'))
    assert_equal(ext_img_element_only, external_image('http://localhost/1.gif',{}, true))
 
    assert_match( 'scale="150"', external_image('http://localhost/1.gif', { :attributes=>{ :file_type => "png", :scale =>"150"} }) )
    assert_match( 'file_type="png"', external_image('http://localhost/1.gif', { :attributes=>{ :file_type => "png", :scale =>"150"} }) )

 
  end
  def test_external_link
    link = '<row><cell><externalLink><url>http://google.com</url><label>Google</label></externalLink></cell></row>'
    assert_equal(link, external_link('Google', 'http://google.com'))

    link = '<row><cell><externalLink id="wgp"><url>http://google.com</url><label>Google</label><externalImage><url>http://wapl.info/img/header_wapple.png</url></externalImage></externalLink></cell></row>'
    assert_equal(link, external_link("Google", "http://google.com", { :attributes => { :id => "wgp"}, :image => { :url => "http://wapl.info/img/header_wapple.png"}}  ))
    link = '<row><cell id="dupa"><externalLink id="wgp"><url>http://google.com</url><label>Google</label><externalImage><url>http://wapl.info/img/header_wapple.png</url></externalImage></externalLink></cell></row>'
    assert_equal(link, external_link("Google", "http://google.com", { :attributes => { :id => "wgp"}, :image => { :url => "http://wapl.info/img/header_wapple.png"}, :cell => { :id => "dupa"}}  ))
  end
  def test_title
    assert_equal('<title>my title</title>', title('my title'))
  end
  def test_style_sheet
    assert_equal('<css><url>http://my.css.com/1.css</url></css>', style_sheet('http://my.css.com/1.css'))
  end
  def test_meta_tag
    assert_equal('<meta name="keywords" content="a list of stuff" />', meta({:keywords =>"a list of stuff"}))
    assert_equal('<meta name="keywords" content="a list of stuff" /><meta name="encoding" content="utf-8" />', meta({:keywords =>"a list of stuff", :encoding=>"utf-8"}))
  end
end
