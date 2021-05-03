require 'optparse'
require 'etc'

params = ARGV.getopts("a", "l", "r")
lists = Dir.glob("*")

# ls -aの処理
if params["a"] == true
  lists = Dir.glob("*", File::FNM_DOTMATCH)
end

# ls -rの処理
if params["r"] == true
  lists = lists.reverse 
end

# ls -lの処理
if params["l"] == true
  # ファイルタイプの変換
  def file_type(type)
    {
      "file" => "-",
      "directory" => "d"
    }[type]
  end

  # パーミッションの変換
  def file_mode(mode) 
    e = []
    mode.each do |m|
      if m == "0"
        e << "---"
      elsif m == "1"
        e << "--x"
      elsif m == "2"
        e << "-w-"
      elsif m == "3"
        e << "-wx"
      elsif m == "4"
        e << "r--"
      elsif m == "5"
        e << "r-x"
      elsif m == "6"
        e << "rw-"
      elsif m == "7"
        e << "rwx"
      end
    end
    mode = e.join
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
    file_time = file.mtime.strftime("%m %d %R") # タイムスタンプ
    file_name = list # ファイル名
    print "#{file_type}#{file_mode} #{file_link.to_s.rjust(2)} #{file_uid}  #{file_gid}  #{file_size.to_s.rjust(4)} #{file_time} #{file_name}\n"
  end
  return
end

# 各要素のサイズを3で割り切れるように揃える。不揃いであればnilを追加する。
if lists.size % 3 == 2
  lists.push(nil)
elsif lists.size % 3 == 1
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
  if i % 3 == 0
    print list
    print "\n"
  else
    print list.to_s.ljust(24)
  end
end
