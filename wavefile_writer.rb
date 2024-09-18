require 'wavefile'
include WaveFile

amplitude = 0.25
one_square_cycle =([amplitude]*50) + ([-amplitude]*50)

buffer = Buffer.new(one_square_cycle, Format.new(:mono, :float, 44100))

cycle_count = 441

Writer.new('square.wav', Format.new(:mono, :pcm_16, 44100)) do |writer|
	cycle_count.times {writer.write(buffer)}
end
