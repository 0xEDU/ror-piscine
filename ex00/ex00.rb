#!/usr/bin/ruby -w

class Html
  def initialize(filename)
    @page_name = filename
    self.head
  end

  def head
    File.open(@page_name + ".html", "w") do |file|
      file.puts "<!DOCTYPE html>"
      file.puts "<html>"
      file.puts "<head>"
      file.puts "<title>#{@page_name}</title>"
      file.puts "</head>"
      file.puts "<body>"
    end
  end

  def dump(str)
    File.open(@page_name + ".html", "a") do |file|
      file.puts "<p>#{str}</p>"
    end
  end
  
  def finish
    File.open(@page_name + ".html", "a") do |file|
      file.puts "</body>"
    end
  end
end
