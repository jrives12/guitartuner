## Converts m4a to wav
require 'streamio-ffmpeg'

file = FFMPEG::Movie.new('A440long.m4a')
file.transcode('a440.wav')

puts 'Conversion complete'
