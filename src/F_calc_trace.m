<<<<<<< HEAD
function [tr_inv]=F_calc_trace(p, H, U)
    
    [~,r]=size(U);
    C = H*U;
    if p <= r
        tr_inv = trace( inv(C*C') );
    else
        tr_inv = trace( inv(C'*C) );
    end
    
=======
function [tr_inv]=F_calc_trace(p, H, U)
    
    [~,r]=size(U);
    C = H*U;
    if p <= r
        tr_inv = trace( inv(C*C') );
    else
        tr_inv = trace( inv(C'*C) );
    end
    
>>>>>>> 6150b0a6442ac2200723bae0ca9384e6c5610ed9
end