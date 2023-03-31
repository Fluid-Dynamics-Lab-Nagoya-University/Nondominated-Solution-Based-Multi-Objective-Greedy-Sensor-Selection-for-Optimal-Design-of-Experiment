function [time, H, sensors, History]=F_sensor_RGEG(U, p, Lmax,ns)
    % objective function: minimum eigenvalue(CCT), (CTC)
    [n,~]=size(U);
    tic;
    [sensors,History]=F_sensor_RGEG_sub(U, p, Lmax,ns);
    time=toc;
    [H]=F_calc_sensormatrix(p, n, sensors(1,:));
    
end