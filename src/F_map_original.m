<<<<<<< HEAD
function F_map_original(num_video, Xorg, meansst, mask, time, videodir)

    p=0;
    filename = ('enso_original');
    output = [videodir, '/', filename, '.avi'];
    F_map_videowriter(num_video, Xorg, meansst, [], [], mask, time, p, output);

=======
function F_map_original(num_video, Xorg, meansst, mask, time, videodir)

    p=0;
    filename = ('enso_original');
    output = [videodir, '/', filename, '.avi'];
    F_map_videowriter(num_video, Xorg, meansst, [], [], mask, time, p, output);

>>>>>>> 6150b0a6442ac2200723bae0ca9384e6c5610ed9
end