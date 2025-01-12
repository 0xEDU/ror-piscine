#!/usr/bin/ruby -w

class Dup__file < StandardError
  def initialize(msg = 'File already exists!')
    super(msg)
  end

  def show_state(page_name)
    filename = page_name + '.html'
    path = File.expand_path(filename)
    puts "A file named #{filename} was already there: #{path}"
  end

  def correct(page_name)
    @filename = page_name + '.new'
    correct(page_name + '.new') if File.exist?(@filename + '.html')
    @filename
  end

  def explain
    path = File.expand_path(@filename + '.html')
    puts "Appended .new in order to create requested file: #{path}"
  end
end

class Body__closed < StandardError
  def initialize(msg = 'The body has already been closed!', page_name, str)
    @str = str
    @page_name = page_name
    super(msg)
  end

  def show_state
    puts "In #{@page_name}.html body was closed :"
  end

  def correct
    filename = @page_name + '.html'
    lines = File.readlines(filename)
    lines.each.with_index do |line, line_number|
      if line.include?('</body>')
        @target = line_number
      end
    end
    lines.insert(@target, "<p>#{@str}</p>")

    File.open(filename, 'w') do |file|
      lines.each do |line|
        file.puts line
      end
    end
  end

  def explain
    puts "\t> ln: #{@target + 1} </body> : text has been inserted and tag moved at the end of it."
  end
end

class Html
  def initialize(filename)
    @page_name = filename
    begin
      head
    rescue Dup__file => e
      e.show_state(@page_name)
      new_name = e.correct(@page_name)
      e.explain
      @page_name = new_name
      head
    end
  end

  def head
    filename = @page_name + '.html'
    raise Dup__file.new if File.exist?(filename)

    File.open(filename, 'w') do |file|
      file.puts '<!DOCTYPE html>'
      file.puts '<html>'
      file.puts '<head>'
      file.puts "<title>#{@page_name}</title>"
      file.puts '</head>'
      file.puts '<body>'
    end
  end

  def dump(str)
    filename = @page_name + '.html'
    content = File.read(filename)
    begin
      if !content.include?('<body>')
        raise "There is no body tag in #{filename}"
      elsif content.include?('</body>')
        raise Body__closed.new(@page_name, str)
      end

      File.open(filename, 'a') do |file|
        file.puts "<p>#{str}</p>"
      end
    rescue Body__closed => e
      e.show_state
      e.correct
      e.explain
    end
  end

  def finish
    filename = @page_name + '.html'
    content = File.read(filename)
    raise "#{filename} has already been closed" if content.include?('</body>')

    File.open(@page_name + '.html', 'a') do |file|
      file.puts '</body>'
    end
  end
end

class HtmlTest
  def test_new
    filename = 'test1'

    File.delete(filename + '.html') if File.exist?(filename + '.html')

    _ = Html.new(filename)
    begin
      _ = Html.new(filename) # Should output a file already exists error
    rescue RuntimeError => e
      puts e
    end
  end

  def test_dump_body_already_closed
    filename = 'test3'

    File.delete(filename + '.html') if File.exist?(filename + '.html')

    a = Html.new(filename)
    a.dump('content')
    a.finish
    begin
      a.dump('Hello, World!') # Should output a body already finished error
    rescue StandardError => e
      puts e
    end
  end
end

if $PROGRAM_NAME == __FILE__
  puts "Testing ex02\n\n"

  test = HtmlTest.new
  test.test_new
  test.test_dump_body_already_closed
end
