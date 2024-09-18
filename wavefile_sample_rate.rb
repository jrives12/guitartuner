require 'wavefile'
include WaveFile

reader = Reader.new("output.wav")
duration = reader.total_duration()
seconds = duration.seconds
milliseconds = (duration.milliseconds.to_f)/1000
formatted_duration = seconds + milliseconds
samplesize = reader.total_sample_frames()
samplerate = samplesize/formatted_duration

puts "Playback time = #{formatted_duration}"
puts "Sample Size = #{samplesize}"
puts "Sample Rate = #{samplerate}"

buffer = reader.read(4096)
sample_array = buffer.samples
print sample_array[0,50]
