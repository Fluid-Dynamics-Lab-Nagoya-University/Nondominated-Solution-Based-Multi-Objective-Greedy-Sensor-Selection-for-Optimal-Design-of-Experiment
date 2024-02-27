function [Normalized]=F_data_normalize(ps, CNT, A1, A2, A3, A4, A5, A6,...
                                       A7, A8, A9, A10, A11, A12, A13, Adenom)

    for z=1:CNT
        Normalized(z,1)  = ps(z);
        Normalized(z,2)  = A1(z,1) /Adenom(z,1); %rand
        Normalized(z,3)  = A2(z,1) /Adenom(z,1); %QD
        Normalized(z,4)  = A3(z,1) /Adenom(z,1); %AD
        Normalized(z,5)  = A4(z,1) /Adenom(z,1); %EG
        Normalized(z,6)  = A5(z,1) /Adenom(z,1); %NMG
        Normalized(z,7)  = A6(z,1) /Adenom(z,1); %NMG2
        Normalized(z,8)  = A7(z,1) /Adenom(z,1); %GDG
        Normalized(z,9)  = A8(z,1) /Adenom(z,1); %RGDG
        Normalized(z,10) = A9(z,1) /Adenom(z,1); %ERGDG
        Normalized(z,11) = A10(z,1)/Adenom(z,1); %GEG
        Normalized(z,12) = A11(z,1)/Adenom(z,1); %RGEG
        Normalized(z,13) = A12(z,1)/Adenom(z,1); %ERGEG
        Normalized(z,13) = A13(z,1)/Adenom(z,1); %GAG
    end

end
