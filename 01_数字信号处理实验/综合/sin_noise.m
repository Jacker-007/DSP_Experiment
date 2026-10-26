function y_noisy = sin_noise(y, fs, tone_freq, power)

t = (0:length(y)-1)' / fs;          
tone = sin(2 * pi * tone_freq * t); 

y_noisy = power*tone;

end