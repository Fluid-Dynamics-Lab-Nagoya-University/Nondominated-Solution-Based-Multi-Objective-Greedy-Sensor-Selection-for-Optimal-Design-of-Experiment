function [time, H, sensors, History]=F_sensor_GAG(U, p, Lmax)
    % objective function: minimum eigenvalue(CCT), (CTC)
    [n,~]=size(U);
    tic;
    [sensors,History]=F_sensor_GAG_sub(U, p, Lmax);
    time=toc;
    [H]=F_calc_sensormatrix(p, n, sensors(1,:));
    
end