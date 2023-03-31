<<<<<<< HEAD
function [time_QR, H, sensors]=F_sensor_QR(U, p)

    [n,~]=size(U);
    tic;
    [sensors]=F_sensor_QR_pivot(p, U);
    time_QR=toc;
    [H]=F_calc_sensormatrix(p, n, sensors);
    
=======
function [time_QR, H, sensors]=F_sensor_QR(U, p)

    [n,~]=size(U);
    tic;
    [sensors]=F_sensor_QR_pivot(p, U);
    time_QR=toc;
    [H]=F_calc_sensormatrix(p, n, sensors);
    
>>>>>>> 6150b0a6442ac2200723bae0ca9384e6c5610ed9
end