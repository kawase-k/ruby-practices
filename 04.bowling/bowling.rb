# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

shots = scores.map do |s|
  if s == 'X'
    shots = []
    shots << 10 << 0
  else
    s.to_i
  end
end
shots = shots.flatten

frames = shots.each_slice(2).to_a

point = 0
frames.each_with_index do |frame, i|
  # 10フレーム以降の処理
  point += if i >= 9
             frame.sum
           # ダブルストライクの処理
           elsif frame[0] == 10 && frames[i + 1][0] == 10
             20 + frames[i + 2][0]
           # ストライクの処理
           elsif frame[0] == 10
             10 + frames[i + 1].sum
           # スペアの処理
           elsif frame.sum == 10
             10 + frames[i + 1][0]
           # ストライクでもスペアでもないときの処理
           else
             frame.sum
           end
end

puts point
