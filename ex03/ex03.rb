#!/usr/bin/ruby -w

class Elem
  attr_reader :tag, :content, :opt, :tag_type

  def initialize(tag, content = [], tag_type = 'double', opt = {})
    @tag = tag
    @tag_type = tag_type
    @content = content
    @opt = opt
  end

  def add_content(*args)
    args.each do |arg|
      @content << arg
    end
  end

  def to_s
    "\"" + stringify[0...-2] + "\""
  end

  def stringify(content = "")
    options = @opt.empty? ? '' : ' ' + @opt.map { |k, v| "#{k}='#{v}'" }.join(' ')

    if @tag_type == 'double' && @content.is_a?(Array)
      "<#{@tag}#{options}>\\n#{@content.flatten.map {|elem| elem.stringify}.join}</#{@tag}>\\n"
    elsif @tag_type == 'double' && @content.is_a?(Text)
      "<#{@tag}#{options}>#{@content.to_s}</#{@tag}>\\n"
    else
      "<#{@tag}#{options} />\\n"
    end
  end
end

class Text
  def initialize(str)
    @str = str
  end

  def to_s
    @str
  end
end

if $PROGRAM_NAME == __FILE__
  html = Elem.new('html')
  head = Elem.new('head')
  body = Elem.new('body')
  title = Elem.new('title', Text.new('blah blah'))
  head.add_content(title)
  html.add_content([head, title, body])
  puts html
end
