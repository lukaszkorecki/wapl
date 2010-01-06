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
    
    tag = self.t_s(tag_name)
    unless attributes.empty?
      tag = self.t_s(tag_name, self.attr_string(attributes))
    end
    tag << content << self.t_e(tag_name)
  end

  def row_cell(tag_string, cell={}, row={})
    cell = self.tag('cell',  tag_string, cell)
    self.tag('row', cell, row)
  end

  def children_list(children={})
    children_str =""
    children.each { |tag, val| children_str += %Q{ < #{tag} > #{val} </ #{tag} > }}
    return children_str
  end
  def chars(content, options={})
    # defaults
    attributes = options[:attributes] || {}
    cell = options[:cell] || {}
    row = options[:row] || {}

    value = self.tag('value', content)
    chars = self.tag("chars", value, attributes )
    self.row_cell(chars, cell, row)
  end
  def external_link(label, url, options={})
    attributes = options[:attributes] || {}
    cell = options[:cell] || {}
    row = options[:row] || {}
    children = options[:children] || {}
    image = options[:image] || {}

    img = self.external_image(image[:url], image) || ""

    child_elements = self.children_list(children + img  )
    label = self.tag('label', label)
    url = self.tag('url', url)
    tag = self.tag('externalLink', url + label + child_elements)

    self.row_cell(tag, options[:cell], options[:row])
  end
  def external_image(url, options)
    attributes = options[:attributes] || {}
    cell = options[:cell] || {}
    row = options[:row] || {}
    children = options[:children] || {}

    options[:url] = url
    child_elements = self.children_list(children)

    tag = self.tag('externalImage', child_elements, attributes)
    self.row_cell(tag, options[:cell], options[:row])
  end
end
