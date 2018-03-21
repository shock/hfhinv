#!/usr/bin/env ruby
#
# This script finds all references to a code snippet in ruby code within RAILS_ROOT and creates
# an HTML table with Textmate links.  If the -f option is passed the argument is treated as a filename
# and all references to the methods in that file name are reported.
# Regular expressions are supported as well.
#
# Usage:
#   script/find_refs.rb residential_delivery_days
#   script/find_refs.rb '\bdelivery_schedule\b'
# or
#   script/find_refs.rb -f 'delivery_schedule.rb
#
# Any options passed after the initial arguments are passed directly to the ack-grep utility
#
require 'rubygems'
require 'bundler'
require 'systemu'
require 'stringio'
require 'pp'
require 'cgi'
require 'json'


RAILS_ROOT= File.expand_path( "..", File.dirname(__FILE__) )
Dir.chdir(RAILS_ROOT)

begin
  sublime_project = JSON.parse(File.read("#{RAILS_ROOT}/kandidly.sublime-project"))
  $excluded_folders = sublime_project["folders"].first["folder_exclude_patterns"]
rescue
  $excluded_folders = []
end

def run_cmd cmd
  status, stdout, stderr = systemu cmd
  raise SystemExit.new unless status == 0
  puts stderr
  stdout
end

def get_method_defs(filename)
  method_sig = /^\s*(self\.)?def\s+/
  lines = File.read(filename)
  method_lines = []
  lines.each_with_index do |line, i|
    rel_filename = filename.gsub(RAILS_ROOT+"/",'')
    src_line_num = create_textmate_link("#{rel_filename}:#{i+1}")
    if line =~ method_sig
      method_lines << [src_line_num,line.gsub(method_sig, '').split(/[ (]/).first.strip]
    end
  end
  method_lines
end

def escape_tags(string)
  string.gsub("<", "&lt;").gsub(">", "&gt;")
end

def create_textmate_link(src_line_num)
  rel_filename, line_num, column = src_line_num.split(":")
  full_filename = RAILS_ROOT + "/" + rel_filename
  "<a href='txmt://open?url=file://#{full_filename}&amp;line=#{line_num}&amp;column=#{column}'>#{escape_tags(src_line_num)}</a>"
end

def get_references(method_name)
  esc_method_name = `printf %q '#{method_name}'`
  ignores = $excluded_folders.map {|f| "--ignore-dir=#{f}"}.join(" ")
  cmd = "ack #{ARGV.join(" ")} --column --ruby --js --scss --css --slim #{ignores} #{esc_method_name}"
  puts cmd
  refs = run_cmd(cmd)
  valid_refs = []
  refs.each_line do |ref|
    chunks = ref.split(":")
    ref_parts = []
    ref_parts << chunks.slice(0,3).join(":")
    chunks.shift
    chunks.shift
    chunks.shift
    ref_parts << escape_tags(chunks.join(":")).gsub(/(#{method_name})/, '<strong>\1</strong>')
    ref_parts[0] = create_textmate_link(ref_parts.first)
    valid_refs << ref_parts
  end
  valid_refs
end

def build_output_rows(method)
  get_references(method)
end

def strike_button
  js = '$(this).parents("tr").toggleClass("strike");return false;'
  "<a href='#' onclick='#{js}'>O</a>"
end

def write_html_row(row, header = false)
  $outfile.puts "<tr>"
  $outfile.puts "<td>#{strike_button}</td>"
  $outfile.puts row.map {|col|
    col = "<h2 style='margin-top:10px'>#{col}<h2>" if header
    "<td><code><pre>#{col}</pre></code></td>"
  }.join
  $outfile.puts "</tr>"
end

arg = ARGV.shift
if arg == '-f'
  $filename = ARGV.shift
  $outfilename = File.expand_path("../tmp/#{$filename}.html", File.dirname(__FILE__))
else
  $method = arg
  $outfilename = File.expand_path("../tmp/#{$method}.html", File.dirname(__FILE__))
end

puts "You must supply at least one argument" and exit 1 unless $filename || $method

$outfile = File.open( $outfilename, 'w')
$outfile.puts <<HTML
<html>
<head>
  <style>
    td {
      border: 1px solid black;
      padding: 8px;
    }
    .strike code {
      color: red;
    }
    .strike code a {
      color: red;
    }
  </style>
  <script type="text/javascript" src="#{RAILS_ROOT}/vendor/assets/javascripts/jquery-2.1.0.min.js"></script>
</head>
<body>
<table>
HTML


if $filename

  cmd = "find #{RAILS_ROOT} -name #{$filename}"

  files = run_cmd(cmd).split("\n").select{|line| line != ""}

  if files.length > 1
    puts "More than one file named #{$filename} found."
    puts files
    exit 1
  end

  $infilename = files.first

  method_defs = get_method_defs($infilename)

  method_defs.each do |method_def|
    write_html_row method_def, true
    rows = build_output_rows(method_def.last)
    rows.each {|row| write_html_row(row)}
  end
else
  row = ["METHOD SEARCH", $method]
  write_html_row(row, true)
  rows = build_output_rows($method)
  rows.each {|row| write_html_row(row)}
end
$outfile.puts("</table>")
$outfile.puts <<HTML
</table>
</body>
HTML
`open -a "Google Chrome" '#{$outfilename}'`
