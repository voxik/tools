#!/usr/bin/ruby
# This script gets last 5 authors of a file and writes them at the end of the file.

# Get several entries from git log for specified file.
def git_log(file)
  `git log -5 --pretty=format:"%an;%ae" #{file}`
end

def md_mailto(a, e)
  "[#{a}](mailto:#{e})"
end

def md_center(text)
  '{:center: style="text-align: center"}' + "\n#{text}\n{:center}"
end

files = Dir.glob File.join('*', '**', '*.md')

files.each do |f|
  author_md = Hash.new

  git_log(f).each_line do |line|
    author, mail = line.split(';')

    author_md[author] = mail unless author_md.key?(author)
  end
  author_md = author_md.map { |a, e| md_mailto(a, e) }

  output = author_md.join ', '
  output = "Authors: #{output}"
  output = md_center output

  File.open(f, 'a') do |file|
    file.write "\n#{output}"
  end
end
