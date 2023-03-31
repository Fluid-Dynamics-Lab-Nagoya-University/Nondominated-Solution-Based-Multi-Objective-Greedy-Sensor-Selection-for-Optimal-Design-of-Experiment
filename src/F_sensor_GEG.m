<<<<<<< HEAD
function [time, H, sensors, History]=F_sensor_GEG(U, p, Lmax)
    % objective function: minimum eigenvalue(CCT), (CTC)
    [n,~]=size(U);
    tic;
    [sensors,History]=F_sensor_GEG_sub(U, p, Lmax);
    time=toc;
    [H]=F_calc_sensormatrix(p, n, sensors(1,:));
    
=======
function [time, H, sensors, History]=F_sensor_GEG(U, p, Lmax)
    % objective function: minimum eigenvalue(CCT), (CTC)
    [n,~]=size(U);
    tic;
    [sensors,History]=F_sensor_GEG_sub(U, p, Lmax);
    time=toc;
    [H]=F_calc_sensormatrix(p, n, sensors(1,:));
    
>>>>>>> 6150b0a6442ac2200723bae0ca9384e6c5610ed9
end