require 'wavefile'
include WaveFile

reader = Reader.new("square.wav", Format.new(:stereo, :float, 44100))

reader.each_buffer do |buffer|
	puts "Buffer number of channels:   #{buffer.channels}"
  	puts "Buffer bits per sample:      #{buffer.bits_per_sample}"
  	puts "Number of samples in buffer: #{buffer.samples.length}"
	puts "First 10 samples in buffer:  #{buffer.samples[0...10].inspect}"
	puts "--------------------------------------------------------------"
end
