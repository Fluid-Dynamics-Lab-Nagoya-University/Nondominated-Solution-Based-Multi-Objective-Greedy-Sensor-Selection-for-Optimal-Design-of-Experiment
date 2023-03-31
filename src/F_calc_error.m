<<<<<<< HEAD
function [Zestimate, Error, Error_std] = F_calc_error(m, Xorg, U, H)

    [Zestimate] = F_calc_reconst(Xorg, H, U);
    [Error, Error_std] = F_calc_reconst_error(m, Xorg, U, Zestimate);

end
=======
function [Zestimate, Error, Error_std] = F_calc_error(m, Xorg, U, H)

    [Zestimate] = F_calc_reconst(Xorg, H, U);
    [Error, Error_std] = F_calc_reconst_error(m, Xorg, U, Zestimate);

end
>>>>>>> 6150b0a6442ac2200723bae0ca9384e6c5610ed9
