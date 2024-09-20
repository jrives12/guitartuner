## Converts m4a to wav
require 'streamio-ffmpeg'

file = FFMPEG::Movie.new('A110Hz.m4a')
file.transcode('a110.wav')

puts 'Conversion complete'
