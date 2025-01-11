#!/usr/bin/ruby -w

class Dup__file < StandardError
  def initialize(msg = "File already exists!")
    super(msg)
  end

  def show_state(page_name)
    filename = page_name + ".html"
    path = File.expand_path(filename)
    puts "A file named #{filename} was already there: #{path}"
  end

  def correct(page_name)
    @filename = page_name + ".new"
    if File.exist?(@filename + ".html")
      correct(page_name + ".new")
    end
    return @filename
  end

  def explain
    path = File.expand_path(@filename + ".html")
    puts "Appended .new in order to create requested file: #{path}"
  end
end

class Body__closed < StandardError
  def initialize(msg = "The body has already been closed!", str)
    @str = str
    super(msg)
  end

  def show_state(page_name)
    puts "In #{page_name}.html body was closed :"
  end

  def correct(page_name)
    filename = page_name + ".html"
    line_number = 0
    File.open(filename, "w+") do |file|
      file.each do |line|
        line_number += 1
        if line.include?("</body>")
          print "\t> ln: #{line_number} </body>:"
        end
      end
    end

  end
end

class Html
  def initialize(filename)
    @page_name = filename
    begin
      self.head
    rescue Dup__file => e
      e.show_state(@page_name)
      new_name = e.correct(@page_name)
      e.explain
      @page_name = new_name
      self.head
    end
  end

  def head
    filename = @page_name + ".html"
    if File.exist?(filename)
      raise Dup__file.new
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
    begin
      if !content.include?("<body>")
        raise "There is no body tag in #{filename}"
      elsif content.include?("</body>")
        raise Body__closed.new(str)
      end

      File.open(filename, "a") do |file|
        file.puts "<p>#{str}</p>"
      end
    rescue Body__closed => b
      b.show_state(@page_name)
      b.correct(@page_name)
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
  test.test_dump_body_already_closed
end
