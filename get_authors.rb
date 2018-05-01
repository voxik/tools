#!/usr/bin/ruby
# This script gets last 5 authors of a file and writes them at the end of the file.

# Get last 5 authors of a file and their email
class Git
	def self.log(file)
		`git log -5 --pretty=format:"%an;%ae" #{file}`
	end

	def self.author_email(file)
		author_email = Hash.new
		self.log(file).each_line do |line|
			author, mail = line.strip.split(';')

			author_email[author] = mail unless author_email.key?(author)
		end
		author_email
	end
end

def md_mailto(a, e)
  "[#{a}](mailto:#{e})"
end

def md_center(text)
  '{:center: style="text-align: center"}' + "\n#{text}\n{:center}"
end

def main
  files = Dir.glob File.join('*', '**', '*.md')

  files.each do |f|
    author_md = Git.author_email(f).map { |a, e| md_mailto(a, e) }

    output = author_md.join ', '
    output = "Authors: #{output}"
    output = md_center output

    File.open(f, 'a') do |file|
      file.write "\n#{output}"
    end
  end
end

if File.identical?(__FILE__, $0)
  main
end
