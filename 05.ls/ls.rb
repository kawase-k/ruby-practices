# frozen_string_literal: true

require 'optparse'
require 'etc'

params = ARGV.getopts('a', 'l', 'r')
lists = Dir.glob('*')

# ls -aの処理
lists = Dir.glob('*', File::FNM_DOTMATCH) if params['a'] == true

# ls -rの処理
lists = lists.reverse if params['r'] == true

# ls -lの処理
if params['l'] == true
  # ファイルタイプの変換
  def file_type(type)
    {
      'file' => '-',
      'directory' => 'd'
    }[type]
  end

  # パーミッションの変換
  def file_mode(mode)
    e = []
    mode.each do |m|
      case m
      when '0'
        e << '---'
      when '1'
        e << '--x'
      when '2'
        e << '-w-'
      when '3'
        e << '-wx'
      when '4'
        e << 'r--'
      when '5'
        e << 'r-x'
      when '6'
        e << 'rw-'
      when '7'
        e << 'rwx'
      end
    end
    e.join
  end

  total = 0
  lists.each do |list|
    file = File.stat(list) # File::Statオブジェクトの生成
    total += file.blocks # total
  end
  puts "total #{total}"

  lists.each do |list|
    file      = File.stat(list) # File::Statオブジェクトの生成
    file_type = file_type(file.ftype) # ファイルタイプ
    file_mode = file_mode(file.mode.to_s(8)[-3, 3].chars) # パーミッション
    file_link = file.nlink # ハードドリンクの数
    file_uid  = Etc.getpwuid(file.uid).name # オーナー名
    file_gid  = Etc.getgrgid(file.gid).name # グループ名
    file_size = file.size # バイトサイズ
    file_time = file.mtime.strftime('%m %d %R') # タイムスタンプ
    file_name = list # ファイル名
    print "#{file_type}#{file_mode} #{file_link.to_s.rjust(2)} #{file_uid}  #{file_gid}  #{file_size.to_s.rjust(4)} #{file_time} #{file_name}\n"
  end
  return
end

# 各要素のサイズを3で割り切れるように揃える。不揃いであればnilを追加する。
case lists.size % 3
when 2
  lists.push(nil)
when 1
  lists.push << nil << nil
end

# transposeを用いて行と列の入れ替えをする。
transpose_lists = []
lists.each_slice(lists.size / 3) do |list|
  transpose_lists << list
end
transpose_lists = transpose_lists.transpose.flatten

# 横に最大3列の表示を維持させて、それぞれのファイル間に空白を入れる。
transpose_lists.each_with_index do |list, i|
  i += 1
  if (i % 3).zero?
    print list
    print "\n"
  else
    print list.to_s.ljust(24)
  end
end
