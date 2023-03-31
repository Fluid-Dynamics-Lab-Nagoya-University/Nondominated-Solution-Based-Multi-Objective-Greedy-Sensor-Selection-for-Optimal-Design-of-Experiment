<<<<<<< HEAD
function [time_rand, H, sensors]=F_sensor_random(n,p)

    tic;
    sensors = randperm(n,p);
    time_rand=toc;
    [H]=F_calc_sensormatrix(p, n, sensors);
    
=======
function [time_rand, H, sensors]=F_sensor_random(n,p)

    tic;
    sensors = randperm(n,p);
    time_rand=toc;
    [H]=F_calc_sensormatrix(p, n, sensors);
    
>>>>>>> 6150b0a6442ac2200723bae0ca9384e6c5610ed9
end