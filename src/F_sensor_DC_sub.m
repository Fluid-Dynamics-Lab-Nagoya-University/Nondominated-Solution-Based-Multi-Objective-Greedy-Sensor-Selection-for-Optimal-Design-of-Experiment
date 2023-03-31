<<<<<<< HEAD
function [isensors, zhat, NT_TOL_cal, iter]=F_sensor_DC_sub(U, p, maxiteration)

    [n,r]=size(U);
    UU=[];
    UU(:,:,1)=U(1:n,1:r); 
    [zhat, ~, ~, ~, NT_TOL_cal, iter] = F_sensor_DC_approxnt_vec(UU, p, maxiteration);
    isensors = find(zhat);

=======
function [isensors, zhat, NT_TOL_cal, iter]=F_sensor_DC_sub(U, p, maxiteration)

    [n,r]=size(U);
    UU=[];
    UU(:,:,1)=U(1:n,1:r); 
    [zhat, ~, ~, ~, NT_TOL_cal, iter] = F_sensor_DC_approxnt_vec(UU, p, maxiteration);
    isensors = find(zhat);

>>>>>>> 6150b0a6442ac2200723bae0ca9384e6c5610ed9
end