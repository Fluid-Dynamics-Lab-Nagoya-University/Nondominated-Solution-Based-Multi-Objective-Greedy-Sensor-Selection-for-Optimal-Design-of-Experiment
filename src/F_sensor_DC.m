<<<<<<< HEAD
function [time_DC, H, sensors, NT_TOL_cal, iter]=F_sensor_DC(U, p, maxiteration)

    [n,~]=size(U);
    tic;
    [sensors, ~, NT_TOL_cal, iter]=F_sensor_DC_sub(U, p, maxiteration);
    time_DC=toc;
    [H]=F_calc_sensormatrix(p, n, sensors);
    
end
=======
function [time_DC, H, sensors, NT_TOL_cal, iter]=F_sensor_DC(U, p, maxiteration)

    [n,~]=size(U);
    tic;
    [sensors, ~, NT_TOL_cal, iter]=F_sensor_DC_sub(U, p, maxiteration);
    time_DC=toc;
    [H]=F_calc_sensormatrix(p, n, sensors);
    
end
>>>>>>> 6150b0a6442ac2200723bae0ca9384e6c5610ed9
