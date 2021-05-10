# frozen_string_literal: true

require 'optparse'
require 'etc'

params = ARGV.getopts('a', 'l', 'r')
lists = Dir.glob('*')

# ls -aの処理
lists = Dir.glob('*', File::FNM_DOTMATCH) if params['a']

# ls -rの処理
lists = lists.reverse if params['r']

# ls -lの処理
if params['l']
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
      replaces = {
        '0' => '---',
        '1' => '--x',
        '2' => '-w-',
        '3' => '-wx',
        '4' => 'r--',
        '5' => 'r-x',
        '6' => 'rw-',
        '7' => 'rwx'
      }
      e << replaces[m]
    end
    e.join
  end

  total = lists.sum { |list| File.stat(list).blocks }
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

# 3列の値を変数に代入。
lists_to_divide = []
divided = 3

# 各要素のサイズを揃えるための下準備。
lists.each_slice(divided) do |list|
  lists_to_divide << list
end

# 各要素のサイズを揃えて平坦化させる。
flatten_lists = lists_to_divide.map { |d| d.values_at(0...divided) }.flatten

# transposeを用いて行と列の入れ替えをする。
t = []
flatten_lists.each_slice(flatten_lists.size / divided) do |l|
  t << l
end
transpose_lists = t.transpose

# 横に最大3列の表示を維持させて、それぞれのファイル間に空白を入れる。
transpose_lists.each do |t_lists|
  t_lists.each do |t_list|
    print t_list.to_s.ljust(24)
  end
  print "\n"
end
