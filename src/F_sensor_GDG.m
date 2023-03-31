function [time_GDG, H, sensors, History]=F_sensor_GDG(U, p, Lmax)
    [n,~]=size(U);
    tic;
    [sensors,History]=F_sensor_GDG_sub(U, p, Lmax);
    time_GDG=toc;
    
    [H]=F_calc_sensormatrix(p, n, sensors(1,:));
    
end
