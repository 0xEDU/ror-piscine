#!/usr/bin/ruby -w

class Elem
  attr_reader :tag, :content, :opt, :tag_type

  def initialize(*args)
    @tag = args[0]
    @tag_type = ''
    @content = []
    @opt = {}
  end

  def add_content(*args)
    args.each do |arg|
      @content << arg
    end
  end
end

class Text
  def initialize(args)
  end
end
