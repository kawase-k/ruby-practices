# frozen_string_literal: true

class LongFormatter
  def initialize(file_details)
    @file_details = file_details
  end

  def print_result
    total_file_blocks = @file_details.sum(&:blocks)
    puts "total #{total_file_blocks}"
    @file_details.each do |file_detail|
      print "#{file_detail.type}#{file_detail.permission} "
      print "#{file_detail.nlink.to_s.rjust(2)} "
      print "#{file_detail.uid}  #{file_detail.gid}  "
      print "#{file_detail.size.to_s.rjust(4)} "
      print "#{file_detail.mtime} "
      print file_detail.path
      puts
    end
  end
end
