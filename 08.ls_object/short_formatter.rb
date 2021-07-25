# frozen_string_literal: true

class ShortFormatter
  PADDING = 24
  COLUMN_LENGTH = 3

  def initialize(file_details)
    @file_details = file_details
  end

  def print_result
    transposed_file_details = transpose_file_details(@file_details)
    transposed_file_details.each do |file_details|
      file_details.each do |file_detail|
        print file_detail.path.ljust(PADDING) if file_detail
      end
      puts
    end
  end

  private

  def transpose_file_details(paths)
    sliced_file_details = paths.each_slice(COLUMNLENGTH).to_a
    flattened_file_details = sliced_file_details.flat_map { |file_details| file_details.values_at(0...COLUMNLENGTH) }
    flattened_file_details.each_slice(flattened_file_details.size / COLUMNLENGTH).to_a.transpose
  end
end
