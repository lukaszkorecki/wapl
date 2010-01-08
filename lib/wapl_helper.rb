module WaplHelper
  # Open a tag
  # Parameters
  # Tag_name:: string - name of the tag <em></em>
  # Attribute:: string - like name="test" woop="woop"
  def t_s(tag_name, attr="")
    if attr.empty?
      %Q{<#{tag_name}>}
    else
      %Q{<#{tag_name} #{attr}>}
    end
  end

  # Converts a hash to attribute string
  # Parameters
  # Attr:: hash - { :name => "test"}
  def attr_string(attr)
    op_str = ""
    attr.each { |k,v|  op_str += %Q{#{k}="#{v}" } }
    return op_str.strip
  end
  # Close the tag
  # Parameters
  # Tag_name:: - string
  def t_e(tag_name)
    %Q{</#{tag_name}>}
  end

  # Sanitze content
  # Parameters
  # Content:: string
  def sanitize_html(content)
    require 'cgi'
    CGI.escapeHTML(content)
  end
  # Wrap string in to cdata marker
  # parameters
  # content:: - string to be wrapped
  def cdatize(content)

      content = '<![CDATA[ ' << content << ' ]]>'
  end

  # Returns a tag with optional attributes and content
  # Parameters
  # Tag_name:: string - the tag you wan to create e.g. "value"
  # Content:: string = inner text of the tag
  # Attributes:: hash - hash of attributes (key - val) for the element (optional)
  def tag(tag_name, content,  attributes = {})
    t = self.t_s(tag_name)
    unless attributes.empty?
      t = self.t_s(tag_name, self.attr_string(attributes))
    end

    t << content << self.t_e(tag_name)
  end

# Inserts a row and a cell with a specified content
# tag_string:: string - the content that goes into the row/cell
# cell:: hash - attribute hash for the <cell /> element
# row:: hash - attribute hash for the <row /> element
  def row_cell(tag_string, cell={}, row={})
    cell = self.tag('cell',  tag_string, cell)
    self.tag('row', cell, row)
  end

# Creates a list of child elements with their values
# Children:: hash with tags and their contents e.g. { :span => "cool content"}
  def children_list(children={})
    children_str =""
    children.each { |tag, val| children_str +=  self.tag(tag, val)}
    return children_str
  end
# WAPL specific element
# Creates chars element (see http://wapl.info docs)
# content:: string - conent of the chars element
# options:: hash -  custom options for the element, can contain:
# - :attributes - for the chars elements (like id and other chars-specific settings)
# - :row - row attribute hash
# - :cell - cell attribute hash
  def chars(content, options={})
    # defaults
    attributes = options[:attributes] || {}

    value = self.tag('value', content)
    chars = self.tag("chars", value, attributes )

    cell = options[:cell] || {}
    row = options[:row] || {}
    self.row_cell(chars, cell, row)
  end
# WAPL specific element
# Creates external image element (see http://wapl.info docs)
# url:: string - url to your image, WAPL engine will download it an process it
# options:: hash -  custom options for the element, can contain:
# - :attributes - for the chars elements (like id and other chars-specific settings)
# - :row - row attribute hash
# - :cell - cell attribute hash
# just_element:: bool - create just the element, without the wrapping <row /><cell />
  def external_image(url, options={}, just_element=false)
    attributes = options[:attributes] || {}
    children = options[:children] || {}

    children[:url] = url
    child_elements = self.children_list(children)

    img = self.tag('externalImage', child_elements, attributes)

    unless just_element
      cell = options[:cell] || {}
      row = options[:row] || {}
      self.row_cell(img, cell, row)
    else
      return img
    end
  end
# WAPL specific element
# Creates external link element (see http://wapl.info docs)
# link_label:: string - label for your link (usually content of <a /> element)
# url:: string - url for your link
# options:: hash - (optional) custom options for the element, can contain:
# - :attributes - for the chars elements (like id and other chars-specific settings)
# - :row - row attribute hash
# - :cell - cell attribute hash
  def external_link(link_label, url, options={})
    attributes = options[:attributes] || {}
    children = options[:children] || {}
    image = options[:image] || {}

   img =""
   unless image.empty?
      img = self.external_image(image[:url], image, true) 
    end

    child_elements = self.children_list(children) << img
    link_label = self.tag('label', link_label)
    url = self.tag('url', url)
    link = self.tag('externalLink', url << link_label << child_elements, attributes)

    cell = options[:cell] || {}
    row = options[:row] || {}
    self.row_cell(link, cell, row)
  end
# head section tags
# XML / root element declaration for use in the layout

  def start_wapl
    return '<wapl xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://wapl.wapple.net/wapl.xsd">'
  end
# closes the root element
  def end_wapl
    return self.t_e('wapl')
  end 
# Layout method
# Returns list of meta tags
# Options:: hash - a hash of meta properites with value e.g. { :author => "Lukasz Korecki"}
  def meta(options={})
    metaz = ""
    options.each { |k,v|  metaz += "<meta " + self.attr_string({ :name=>k, :content => v} )+ " />" }
    return metaz
  end
# Renders external css declaration in the <head /> element
# url:: - url for the external stylesheet
  def style_sheet(url="")
    self.tag('css', self.tag('url', url))
  end
# Renders external css declaration in the <head /> element
# alias for style_sheet()
# url:: - url for the external stylesheet
  def css(url="")
    self.style_sheet(url)
  end
# Title tag
# title:: string -  title for your page
  def title(title="")
    self.tag('title', title)
  end
end
