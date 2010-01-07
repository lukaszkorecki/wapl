module WaplHelper
# private # TODO make it private later!
  def t_s(tag_name, attr="")
    if attr.empty?
      %Q{ <#{tag_name}>}
    else
      %Q{ <#{tag_name} #{ attr} > }
    end
  end

  def attr_string(attr)
    op_str = ""
  # if(attr.lenth > 0)
      attr.each { |k,v|  op_str += %Q{ #{k}="#{v}" } }
  # end
    return op_str
  end
  def t_e(tag_name)
    %Q{ </#{tag_name}>}
  end

  def sanitize_html(content)
    require 'cgi'
    CGI.escapeHTML(content)
  end

  def tag(tag_name, content,  attributes = {})
    
    t = self.t_s(tag_name)
    unless attributes.empty?
      t = self.t_s(tag_name, self.attr_string(attributes))
    end
    t << content << self.t_e(tag_name)
  end

  def row_cell(tag_string, cell={}, row={})
    cell = self.tag('cell',  tag_string, cell)
    self.tag('row', cell, row)
  end

  def children_list(children={})
    children_str =""
    children.each { |tag, val| children_str +=  self.tag(tag, val)}
    return children_str
  end
  def chars(content, options={})
    # defaults
    attributes = options[:attributes] || {}

    value = self.tag('value', content)
    chars = self.tag("chars", value, attributes )

    cell = options[:cell] || {}
    row = options[:row] || {}
    self.row_cell(chars, cell, row)
  end
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
    link = self.tag('externalLink', url + link_label + child_elements)

    cell = options[:cell] || {}
    row = options[:row] || {}
    self.row_cell(link, cell, row)
  end
end
