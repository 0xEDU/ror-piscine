#!/usr/bin/ruby -w

class Html
  def initialize(filename)
    @page_name = filename
    self.head
  end

  def head
    filename = @page_name + ".html"
    if File.exist?(filename)
      raise "#{filename} already exists!"
    end
    File.open(filename, "w") do |file|
      file.puts "<!DOCTYPE html>"
      file.puts "<html>"
      file.puts "<head>"
      file.puts "<title>#{@page_name}</title>"
      file.puts "</head>"
      file.puts "<body>"
    end
  end

  def dump(str)
    filename = @page_name + ".html"
    content = File.read(filename)
    if !content.include?("<body>")
      raise "There is no body tag in #{filename}"
    elsif content.include?("</body>")
      raise "The body has already been closed in #{filename}"
    end

    File.open(filename, "a") do |file|
      file.puts "<p>#{str}</p>"
    end
  end

  def finish
    filename = @page_name + ".html"
    content = File.read(filename)
    if content.include?("</body>")
      raise "#{filename} has already been closed"
    end
    File.open(@page_name + ".html", "a") do |file|
      file.puts "</body>"
    end
  end
end

class HtmlTest
  def test_new
    filename = "test1"

    if (File.exist?(filename + ".html"))
      File.delete(filename + ".html")
    end

    _ = Html.new(filename)
    begin
      _ = Html.new(filename) # Should output a file already exists error
    rescue RuntimeError => e
      puts e
    end
  end

  def test_dump_body_not_open
    filename = "test2"

    if (File.exist?(filename + ".html"))
      File.delete(filename + ".html")
    end

    a = Html.new(filename)
    File.open(filename + ".html", "w") {|file| file.truncate(0) }
    begin
      a.dump("Hello, World!") # Should output a no body tag error
    rescue StandardError => e
      puts e
    end
  end

  def test_dump_body_already_closed
    filename = "test3"

    if (File.exist?(filename + ".html"))
      File.delete(filename + ".html")
    end

    a = Html.new(filename)
    a.dump("content")
    a.finish
    begin
      a.dump("Hello, World!") # Should output a body already finished error
    rescue StandardError => e
      puts e
    end
  end

  def test_finish_after_finish
    filename = "test4"

    if (File.exist?(filename + ".html"))
      File.delete(filename + ".html")
    end

    a = Html.new(filename)
    a.finish
    begin
      a.finish # Should output a body already finished error
    rescue StandardError => e
      puts e
    end
  end
end

if $PROGRAM_NAME == __FILE__
  puts "Testing ex01\n\n"

  test = HtmlTest.new
  test.test_new
  test.test_dump_body_not_open
  test.test_dump_body_already_closed
  test.test_finish_after_finish
end
