<<<<<<< HEAD
function [time, H, sensors, History]=F_sensor_ERGDG(U, p, Lmax, ns, pov)
    [n,~]=size(U);
    tic;
    [sensors,History]=F_sensor_ERGDG_sub(U, p, Lmax, ns, pov);
    time=toc;
    
    [H]=F_calc_sensormatrix(p, n, sensors(1,:));
    
end
=======
function [time, H, sensors, History]=F_sensor_ERGDG(U, p, Lmax, ns, pov)
    [n,~]=size(U);
    tic;
    [sensors,History]=F_sensor_ERGDG_sub(U, p, Lmax, ns, pov);
    time=toc;
    
    [H]=F_calc_sensormatrix(p, n, sensors(1,:));
    
end
>>>>>>> 6150b0a6442ac2200723bae0ca9384e6c5610ed9
