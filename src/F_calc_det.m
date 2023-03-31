<<<<<<< HEAD
function [logdet]=F_calc_det(p, H, U)

    [~,r]=size(U);
    C = H*U;
    if p <= r
        logdet = det(C*C');
    else
        logdet = (det(C'*C));
    end
end
=======
function [logdet]=F_calc_det(p, H, U)

    [~,r]=size(U);
    C = H*U;
    if p <= r
        logdet = det(C*C');
    else
        logdet = (det(C'*C));
    end
end
>>>>>>> 6150b0a6442ac2200723bae0ca9384e6c5610ed9
