<<<<<<< HEAD
function [time, H, sensors]=F_sensor_EG(U, p)
    % objective function: minimum eigenvalue(CCT), (CTC)
    
    [n,~]=size(U);
    tic;
    [sensors]=F_sensor_EG_calc_eigen(U, p);
    time=toc;
    [H]=F_calc_sensormatrix(p, n, sensors);
    sensors=sensors';%add 2021/3/12
    
=======
function [time, H, sensors]=F_sensor_EG(U, p)
    % objective function: minimum eigenvalue(CCT), (CTC)
    
    [n,~]=size(U);
    tic;
    [sensors]=F_sensor_EG_calc_eigen(U, p);
    time=toc;
    [H]=F_calc_sensormatrix(p, n, sensors);
    sensors=sensors';%add 2021/3/12
    
>>>>>>> 6150b0a6442ac2200723bae0ca9384e6c5610ed9
end