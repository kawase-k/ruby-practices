# frozen_string_literal: true

require 'optparse'
@params = ARGV.getopts('l')

def main
  @files = ARGV
  if @files == []
    argument_no
  else
    @total_lines    = 0
    @total_words    = 0
    @total_bytesize = 0
    argument_has
  end
end

# wcコマンドに引数がなかったときの処理
def argument_no
  @input = $stdin.read
  output_items
  puts
end

# wcコマンドに引数があったときの処理
def argument_has
  @files.each do |file|
    @input = File.read(file)
    output_items
    print " #{file}"
    puts

    add
  end
  output_total_items if @files[1]
end

# 引数の有無に応じてそれぞれの出力を表示する
def output_items
  line = @input.count("\n").to_s.rjust(8)
  word = @input.split(/\s+/).size.to_s.rjust(8)
  byte = @input.bytesize.to_s.rjust(8)

  print line
  return if @params['l']

  print word
  print byte
end

# 引数が複数個あったときの処理
def add
  @total_lines    += @input.count("\n")
  @total_words    += @input.split(/\s+/).size
  @total_bytesize += @input.bytesize
end

# total値を表示するための処理
def output_total_items
  print @total_lines.to_s.rjust(8)
  if @params['l'] == false
    print @total_words.to_s.rjust(8)
    print @total_bytesize.to_s.rjust(8)
  end
  print ' total'
  puts
end

main
