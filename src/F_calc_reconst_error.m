<<<<<<< HEAD
function[Error_ave, Error_std]=F_calc_reconst_error(m, Xorg, U, Zestimate)

    for ii=1:m
        Xestimate = U*Zestimate(:,ii);
        Error(ii) = norm(Xestimate-Xorg(:,ii)) / norm(Xorg(:,ii));
    end
    Error_ave = mean(Error);
    Error_std = std(Error);
    
=======
function[Error_ave, Error_std]=F_calc_reconst_error(m, Xorg, U, Zestimate)

    for ii=1:m
        Xestimate = U*Zestimate(:,ii);
        Error(ii) = norm(Xestimate-Xorg(:,ii)) / norm(Xorg(:,ii));
    end
    Error_ave = mean(Error);
    Error_std = std(Error);
    
>>>>>>> 6150b0a6442ac2200723bae0ca9384e6c5610ed9
end