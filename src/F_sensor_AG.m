<<<<<<< HEAD
function [time, H, sensors]=F_sensor_AG(U, p)
    % objective function: trace[inv(CCT)], trace[inv(CTC)]

    [n,~]=size(U);
    tic;
    [sensors]=F_sensor_AG_calc_trace(U, p);
    time=toc;
    [H]=F_calc_sensormatrix(p, n, sensors);
    
=======
function [time, H, sensors]=F_sensor_AG(U, p)
    % objective function: trace[inv(CCT)], trace[inv(CTC)]

    [n,~]=size(U);
    tic;
    [sensors]=F_sensor_AG_calc_trace(U, p);
    time=toc;
    [H]=F_calc_sensormatrix(p, n, sensors);
    
>>>>>>> 6150b0a6442ac2200723bae0ca9384e6c5610ed9
end