require 'wavefile'
require 'fftw3'
include WaveFile

reader = Reader.new("a440.wav")

duration = reader.total_duration()
seconds = duration.seconds
milliseconds = (duration.milliseconds.to_f)/1000
formatted_duration = seconds + milliseconds
samplesize = reader.total_sample_frames()
samplerate = samplesize/formatted_duration

buffersize = samplesize/2
freq_res = samplerate/buffersize

buffer = reader.read(buffersize)
sample_array = buffer.samples

fft = FFTW3.fft(sample_array)
fft_array = fft.to_a

max_magnitude = 0
max_frequency = 0
magnitude_array = []
freq_array = []

fft_array.each_with_index do |complex_value, i|
  real_part = complex_value.real
  imag_part = complex_value.imag
  magnitude = Math.sqrt(real_part**2 + imag_part**2)
  magnitude_array << magnitude
  freq_array << i*freq_res
  #puts "Frequency bin #{i*freq_res}: Magnitude=#{magnitude}"

end

mag_freq_matrix = magnitude_array.zip(freq_array)

min_freq = 40
max_freq = 600
filtered_matrix = mag_freq_matrix.select do |row|
  frequency = row[1]
  frequency >= min_freq && frequency <= max_freq
end

sorted_matrix = filtered_matrix.sort_by {|row| -row[0]}
sorted_mag_array, sorted_freq_array = sorted_matrix.transpose

puts "Max Frequency is #{sorted_freq_array[0]}"
puts "Sample Rate is #{samplerate}"
puts "Sample Size is #{samplesize}"
