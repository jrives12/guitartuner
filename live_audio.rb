def record(duration,sample_rate)
	require 'ffi-portaudio'
	include FFI::PortAudio
	require_relative 'device_list'
	
	puts "Which Device?"
	
	API.Pa_Initialize

	stream_pointer = FFI::MemoryPointer.new(:pointer)
	buffer_size = 4096
	iterations = (duration*sample_rate)/buffer_size
	iterations = iterations.round()
	
	input_device = API.Pa_GetDefaultInputDevice
	raise "No Default Input Device Available" if input_device < 0

	input_parameters = API::PaStreamParameters.new
	input_parameters[:device] = input_device
	input_parameters[:channelCount] = 1
	input_parameters[:hostApiSpecificStreamInfo] = nil
	input_parameters[:sampleFormat] = API::Float32
	input_parameters[:suggestedLatency] = API.Pa_GetDeviceInfo(input_parameters[:device])[:defaultLowInputLatency]

	output_parameters = nil
	API.Pa_OpenStream(stream_pointer,input_parameters,output_parameters,sample_rate,buffer_size,API::NoFlag,nil,nil)
	stream = stream_pointer.read_pointer

	API.Pa_StartStream(stream)
	err = API.Pa_IsStreamActive(stream)
	raise "Stream is not active" if err == 0
	puts 'Recording...'
	all_samples =[]
	iterations.times do
	  buffer = FFI::MemoryPointer.new(:float,buffer_size)
	  API.Pa_ReadStream(stream,buffer,buffer_size)
  
	  samples = buffer.read_array_of_float(buffer_size)
	  all_samples.concat(samples)
	end
	API.Pa_StopStream(stream)
	API.Pa_CloseStream(stream)
	API.Pa_Terminate
	raise "No Samples Collected" if all_samples == []
	return all_samples
end
