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
  common_variable

  result
  puts
end

# 引数があったときの処理
def argument_has
  @files.each do |file|
    @input = File.read(file)
    common_variable

    result
    print " #{file}"
    puts

    arguments
  end
  total_value if @files[1]
end

# 出力をまとめる
def result
  print @line
  return false if @params['l']

  print @word
  print @byte
end

# 引数が複数個あったときの処理
def arguments
  @total_lines    += @input.count("\n")
  @total_words    += @input.split(/\s+/).size
  @total_bytesize += @input.bytesize
end

# total値を表示するための処理
def total_value
  print @total_lines.to_s.rjust(8)
  if @params['l'] == false
    print @total_words.to_s.rjust(8)
    print @total_bytesize.to_s.rjust(8)
  end
  print ' total'
  puts
end

# 共通する変数をメソッドでまとめる
def common_variable
  @line = @input.count("\n").to_s.rjust(8)
  @word = @input.split(/\s+/).size.to_s.rjust(8)
  @byte = @input.bytesize.to_s.rjust(8)
end

main
