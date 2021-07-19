# frozen_string_literal: true

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

  PERMISSION = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

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

  private

  def convert_permimmison(mode)
    mode.map { |m| PERMISSION[m] }.join
  end
end

class ShortFormatFile
  attr_reader :transpose_files

  COLUMN_NUMBER = 3

  def initialize(file_paths)
    @transpose_files = transpose_file_paths(file_paths)
  end

  private

  def transpose_file_paths(paths)
    files = []
    paths.each_slice(COLUMN_NUMBER) { |path| files << path }
    flatten_file_paths = files.map { |file| file.values_at(0...COLUMN_NUMBER) }.flatten
    files.clear
    flatten_file_paths.each_slice(flatten_file_paths.size / COLUMN_NUMBER) do |path|
      files << path
    end
    files.transpose
  end
end

class LongFormat
  def initialize(files)
    @files              = files
    @total_files_blocks = files.sum(&:blocks)
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
    @files.transpose_files.each do |file|
      file.each do |n|
        print n.to_s.ljust(24)
      end
      puts
    end
  end
end

options = ARGV.getopts('a', 'l', 'r')
command = Command.new(a_option: options['a'], l_option: options['l'], r_option: options['r'])
command.output
