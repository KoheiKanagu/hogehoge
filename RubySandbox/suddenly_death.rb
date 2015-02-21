s = gets.chomp
l = s.encode('EUC-JP').bytesize / 2
u = '＿人'
d = '￣Y'
l.times do
  u += '人'
  d += '^Y'
end
puts "#{u}人＿\n＞　#{s}　＜\n#{d}￣"
