# frozen_string_literal: true

require 'optparse'
require 'etc'

class Command
  def initialize(a_option: false, l_option: false, r_option: false)
    @a_option = a_option
    @l_option = l_option
    @r_option = r_option
  end

  def self.call_output
    options = ARGV.getopts('a', 'l', 'r')
    command = Command.new(a_option: options['a'], l_option: options['l'], r_option: options['r'])
    command.output
  end

  def output
    file_paths = @a_option ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    sorted_file_paths = @r_option ? file_paths.reverse : file_paths.sort
    file_details = sorted_file_paths.map do |file_path|
      FileDetail.new(file_path, File::Stat.new(file_path))
    end
    formatter = @l_option ? LongFormatter.new(file_details) : ShortFormatter.new(file_details)
    formatter.print_result
  end
end
