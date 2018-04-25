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
  author_mail = git_log(f).split(/[;\n]/).each_slice(2).to_h.sort

  author_md = author_mail.collect { |a, e| md_mailto(a, e) }

  output = author_md.join ', '
  output = "Authors: #{output}"
  output = md_center output

  File.open(f, 'a') do |file|
    file.write "\n#{output}"
  end
end
