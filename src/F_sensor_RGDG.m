<<<<<<< HEAD
function [time_GDG, H, sensors, History]=F_sensor_RGDG(U, p, Lmax, ns)
    [n,~]=size(U);
    tic;
    [sensors,History]=F_sensor_RGDG_sub(U, p, Lmax, ns);
    time_GDG=toc;
    
    [H]=F_calc_sensormatrix(p, n, sensors(1,:));
    
end
=======
function [time_GDG, H, sensors, History]=F_sensor_RGDG(U, p, Lmax, ns)
    [n,~]=size(U);
    tic;
    [sensors,History]=F_sensor_RGDG_sub(U, p, Lmax, ns);
    time_GDG=toc;
    
    [H]=F_calc_sensormatrix(p, n, sensors(1,:));
    
end
>>>>>>> 6150b0a6442ac2200723bae0ca9384e6c5610ed9
