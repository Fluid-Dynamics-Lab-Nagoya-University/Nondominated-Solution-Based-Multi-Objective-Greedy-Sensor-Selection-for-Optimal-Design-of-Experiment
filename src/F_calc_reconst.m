<<<<<<< HEAD
function [Zestimate] = F_calc_reconst(Xorg, H, U)

    Y = H*Xorg;
    C = H*U;
    Zestimate = pinv(C)*Y; %B = pinv(A) returns the Moore-Penrose Pseudoinverse of matrix A.

end
=======
function [Zestimate] = F_calc_reconst(Xorg, H, U)

    Y = H*Xorg;
    C = H*U;
    Zestimate = pinv(C)*Y; %B = pinv(A) returns the Moore-Penrose Pseudoinverse of matrix A.

end
>>>>>>> 6150b0a6442ac2200723bae0ca9384e6c5610ed9
