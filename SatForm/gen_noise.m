function noise = gen_noise(amp,size)

    noise = -amp + 2*amp*rand(size);

end