require 'wavefile'
require 'fftw3'
include WaveFile

# Reads wave file into reader class
reader = Reader.new("a440.wav")

# Reads duration of file and total samples and calculates sample rate from those values
duration = reader.total_duration()
seconds = duration.seconds
milliseconds = (duration.milliseconds.to_f)/1000
formatted_duration = seconds + milliseconds
samplesize = reader.total_sample_frames()
samplerate = samplesize/formatted_duration

# decides a size for the buffer, and then reads that into an array
buffersize = samplesize/2
buffer = reader.read(buffersize)
sample_array = buffer.samples

# Calculates the frequency resolution
freq_res = samplerate/buffersize

# Performs the fast fourier transform and converts to normal ruby array
fft = FFTW3.fft(sample_array)
fft_array = fft.to_a

# Creates Magnitude and frequency arrays for FFT to feed into
magnitude_array = []
freq_array = []

# Reads complex FFT results and calculates frequency and magnitude for each
fft_array.each_with_index do |complex_value, i|
  real_part = complex_value.real
  imag_part = complex_value.imag
  magnitude = Math.sqrt(real_part**2 + imag_part**2)
  magnitude_array << magnitude
  freq_array << i*freq_res
  #puts "Frequency bin #{i*freq_res}: Magnitude=#{magnitude}"

end

# Creates a matrix of magnitude and frequency values from FFT, filters out unneeded frequencies and determines maximum frequencies
mag_freq_matrix = magnitude_array.zip(freq_array)

min_freq = 40
max_freq = 5000
filtered_matrix = mag_freq_matrix.select do |row|
  frequency = row[1]
  frequency >= min_freq && frequency <= max_freq
end

sorted_matrix = filtered_matrix.sort_by {|row| -row[0]}
sorted_mag_array, sorted_freq_array = sorted_matrix.transpose

# Prints relevant values
puts "Max Frequency is #{sorted_freq_array[0]}"
puts "Second Frequency is #{sorted_freq_array[1]}, which is an interval of #{sorted_freq_array[1]/sorted_freq_array[0]}"
puts "Third Frequency is #{sorted_freq_array[2]}, which is an interval of #{sorted_freq_array[2]/sorted_freq_array[1]}"
puts "Sample Rate is #{samplerate}"
puts "Sample Size is #{samplesize}"
