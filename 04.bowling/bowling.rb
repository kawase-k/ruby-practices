# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end

# Max12ゲームはする前提で値を作成。nilになる場合もあるのでその時は0を代入する。
af = frames[10]
bf = frames[11]
if af.nil? && bf.nil?
  af = 0
  bf = 0
elsif af.nil?
  af = 0
elsif bf.nil?
  bf = 0
end

# 10フレーム目をまとめた。
if frames[9].push(af, bf)
  frames[9] = frames[9].flatten
  frames.slice!(10, 11)
end

point = 0
frames.each_with_index do |frame, i|
  # 1から8フレームまででダブルストライクだったときの処理
  point += if i < 8 && frame[0] == 10 && frames[i + 1][0] == 10
             20 + frames[i + 2][0]
           # 9フレーム目がダブルストライクだっだときの処理
           elsif i == 8 && frame[0] == 10 && frames[i + 1][0] == 10
             10 + frames[i + 1][0..3].sum
           # ストライクの処理
           elsif i < 9 && frame[0] == 10
             10 + frames[i + 1][0..1].sum
           # スペアの処理
           elsif i < 9 && frame.sum == 10
             10 + frames[i + 1][0]
           else
             frame.sum
           end
end
puts point
