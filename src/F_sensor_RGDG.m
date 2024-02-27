function [time_GDG, H, sensors, History]=F_sensor_RGDG(U, p, Lmax, ns)
    [n,~]=size(U);
    tic;
    [sensors,History]=F_sensor_RGDG_sub(U, p, Lmax, ns);
    time_GDG=toc;
    
    [H]=F_calc_sensormatrix(p, n, sensors(1,:));
    
end
