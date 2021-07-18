require 'optparse'
require 'etc'

class Command
  def initialize(a_option: false, l_option: false, r_option: false)
    file_paths        = a_option ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    sorted_file_paths = r_option ? file_paths.reverse : file_paths.sort
    files             = if l_option
                          sorted_file_paths.map do |file_path|
                            LongFormatFile.new(file_path, File::Stat.new(file_path))
                          end
                        else
                          ShortFormatFile.new(sorted_file_paths)
                        end
    @format = l_option ? LongFormat.new(files) : ShortFormat.new(files)
  end

  def output
    @format.print_result
  end
end

class LongFormatFile
  attr_reader :type, :permission, :nlink, :uid, :gid, :size, :mtime, :path, :blocks

  def initialize(file_path, file_stat)
    @type       = file_stat.directory? ? 'd' : '-'
    @permission = convert_permimmison(file_stat.mode.to_s(8)[-3, 3].chars)
    @nlink      = file_stat.nlink
    @uid        = Etc.getpwuid(file_stat.uid).name
    @gid        = Etc.getgrgid(file_stat.gid).name
    @size       = file_stat.size
    @mtime      = file_stat.mtime.strftime('%_m %_d %H:%M')
    @path       = file_path
    @blocks     = file_stat.blocks
  end

  def convert_permimmison(mode)
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
    mode.map { |m| replaces[m] }.join
  end
end

class ShortFormatFile
  NUM_OF_HORIZONTAL_DISP = 3
  attr_reader :files

  def initialize(files)
    @files = transpose_lists(files)
  end

  def slice_divided(files)
    files_to_divide = []

    files.each_slice(NUM_OF_HORIZONTAL_DISP) do |file|
      files_to_divide << file
    end
    files_to_divide
  end

  def flatten_lists(files)
    slice_divided(files).map {|d| d.values_at(0...NUM_OF_HORIZONTAL_DISP)}.flatten
  end

  def transpose_lists(files)
    t = []
    flatten_lists(files).each_slice(flatten_lists(files).size / NUM_OF_HORIZONTAL_DISP) do |l|
      t << l
    end
    transpose_lists = t.transpose
  end
end

class LongFormat
  def initialize(files)
    @files = files
    @total_files_blocks = files.sum {|file| file.blocks}
  end

  def print_result
    puts "total #{@total_files_blocks}"
    @files.each do |file|
      print "#{file.type}#{file.permission} "
      print "#{file.nlink.to_s.rjust(2)} "
      print "#{file.uid}  #{file.gid}  "
      print "#{file.size.to_s.rjust(4)} "
      print "#{file.mtime} "
      print file.path
      puts
    end
  end
end

class ShortFormat
  def initialize(files)
    @files = files
  end

  def print_result
    @files.files.each do |file|
      file.each do |f|
        print f.to_s.ljust(24)
      end
      puts
    end
  end
end

options = ARGV.getopts('a', 'l', 'r')
command = Command.new(a_option: options['a'], l_option: options['l'], r_option: options['r'])
command.output