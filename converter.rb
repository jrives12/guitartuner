## Converts m4a to wav
require 'streamio-ffmpeg'

file = FFMPEG::Movie.new('hello.m4a')
file.transcode('output.wav')

puts 'Conversion complete'
