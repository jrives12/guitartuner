def device_list
	require 'ffi-portaudio'
	include FFI::PortAudio

	API.Pa_Initialize
	count = API.Pa_GetDeviceCount

	count.times do |i|
	  name = API.Pa_GetDeviceInfo(i)[:name]
	  puts "#{i+1}. #{name}"
	end
	API.Pa_Terminate
end
