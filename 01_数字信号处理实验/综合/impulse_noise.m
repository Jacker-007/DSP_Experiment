function y_noisy = impulse_noise(y, density, amplitude)

    y_noisy = zeros(1,length(y))';
    num_samples = length(y);

    % 生成随机噪声位置
    noise_mask = rand(num_samples, 1) < density;
    num_noise = sum(noise_mask);

    % 随机生成正脉冲或负脉冲
    noise_type = 2 * (rand(num_noise, 1) > 0.5) - 1; % -1 或 1
    y_noisy(noise_mask) = amplitude * noise_type;
end