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
    stringify
  end

  def stringify(content = "")
    options = @opt.empty? ? '' : ' ' + @opt.map { |k, v| "#{k}='#{v}'" }.join(' ')

    if @tag_type == 'double' && @content.is_a?(Array)
      "<#{@tag}#{options}>\n#{@content.flatten.map {|elem| elem.stringify}.join}</#{@tag}>\n"
    elsif @tag_type == 'double' && @content.is_a?(Text)
      "<#{@tag}#{options}>#{@content.to_s}</#{@tag}>\n"
    else
      "<#{@tag}#{options} />\n"
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

class SingleElem < Elem
  def initialize(tag, opt = {})
    super(tag, [], 'single', opt)
  end
end

class DoubleElem < Elem
  def initialize(tag, content = [], opt = {})
    super(tag, content, 'double', opt)
  end
end

class Html < DoubleElem
  def initialize(content = [])
    super('Html', content)
  end
end

class Head < DoubleElem
  def initialize(content = [])
    super('Head', content)
  end
end

class Title < DoubleElem
  def initialize(str)
    super('Title', Text.new(str))
  end
end

class Body < DoubleElem
  def initialize(content = [])
    super('Body', content)
  end
end

class Meta < SingleElem
  def initialize(opt = {})
    super('Meta', opt)
  end
end

class Img < SingleElem
  def initialize(tag, opt = {})
    super('Img', opt)
  end
end

class Table < DoubleElem
  def initialize(content = [], opt = {})
    super('Table', content, opt)
  end
end

class Tr < DoubleElem
  def initialize(content = [], opt = {})
    super('Tr', content, opt)
  end
end

class Th < DoubleElem
  def initialize(content = [], opt = {})
    super('Th', content, opt)
  end
end

class Td < DoubleElem
  def initialize(content = [], opt = {})
    super('Td', content, opt)
  end
end

class Ul < DoubleElem
  def initialize(content = [], opt = {})
    super('Ul', content, opt)
  end
end

class Ol < DoubleElem
  def initialize(content = [], opt = {})
    super('Ol', content, opt)
  end
end

class Li < DoubleElem
  def initialize(content = [], opt = {})
    super('Li', content, opt)
  end
end

class H1 < DoubleElem
  def initialize(str, opt = {})
    super('H1', Text.new(str), opt)
  end
end

class H2 < DoubleElem
  def initialize(str, opt = {})
    super('H2', Text.new(str), opt)
  end
end

class P < DoubleElem
  def initialize(str, opt = {})
    super('P', Text.new(str), opt)
  end
end

class Div < DoubleElem
  def initialize(content = [], opt = {})
    super('Div', content, opt)
  end
end

class Span < DoubleElem
  def initialize(str, opt = {})
    super('Span', Text.new(str), opt)
  end
end

class Hr < SingleElem
  def initialize(opt = {})
    super('Hr', opt)
  end
end

class Br < SingleElem
  def initialize(opt = {})
    super('Br', opt)
  end
end

if $PROGRAM_NAME == __FILE__
  puts Html.new([ \
    Head.new([Title.new("Hello, ground!")]), \
    Body.new([ \
      H1.new("Oh no, not again!"), \
      Img.new([], {src: "http://i.imgur.com/pfp3T.jpg"}) \
      ]) \
    ])
end
