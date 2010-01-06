module WaplHelper
# private # TODO make it private later!
  def self.tag_start(tag_name, attr="")
    if attr.empty?
      %Q{ <#{tag_name}>}
    else
      %Q{ <#{tag_name} #{ attr} > }
    end
  end

  def self.attr_string(attr)
#     op_str = ""
      attr.each { |k,v|  op_str += %Q{ #{k}="#{v}" } }
      return op_str
  end
  def self.tag_end(tag_name)
    %Q{ </#{tag_name}>}
  end

  def self.sanitize_html(content)
    require 'cgi'
    CGI.escapeHTML(content)
  end
  def self.render_markup(hash)
    w = self # ?????????
    # defaults :-)
    output, child, att, value = ""
    hash.each do |k,v|
      case k
        when :child
         child = w.print(v)
        when :attr
          att = w.attr_string(v)
        when :value
          value = w.sanitize_html(v)
        when :url
          value = w.tag_start('url') << v << w.tag_end('url')
      end
    end
    output = w.tag_start(hash[:tag], att) << child << value << w.tag_end(hash[:tag])
  end
end
