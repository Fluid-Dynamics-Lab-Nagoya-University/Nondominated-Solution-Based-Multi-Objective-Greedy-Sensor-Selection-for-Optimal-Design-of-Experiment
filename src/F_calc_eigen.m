<<<<<<< HEAD
function [eig_min]=F_calc_eig(p, H, U)
    
    [~,r]=size(U);
    C = H*U;
    if p <= r
        eig_min = min( eig(C*C') );
    else
        eig_min = min( eig(C'*C) );
    end
=======
function [eig_min]=F_calc_eig(p, H, U)
    
    [~,r]=size(U);
    C = H*U;
    if p <= r
        eig_min = min( eig(C*C') );
    else
        eig_min = min( eig(C'*C) );
    end
>>>>>>> 6150b0a6442ac2200723bae0ca9384e6c5610ed9
end