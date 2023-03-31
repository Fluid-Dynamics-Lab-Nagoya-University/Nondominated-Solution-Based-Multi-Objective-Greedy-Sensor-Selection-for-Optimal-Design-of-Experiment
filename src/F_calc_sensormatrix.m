<<<<<<< HEAD
function [H]=F_calc_sensormatrix(p, n, SNSR)

   H=zeros(p, n);
   for pp=1:1:p
      H(pp, SNSR(pp))=1;
   end
   
end
=======
function [H]=F_calc_sensormatrix(p, n, SNSR)

   H=zeros(p, n);
   for pp=1:1:p
      H(pp, SNSR(pp))=1;
   end
   
end
>>>>>>> 6150b0a6442ac2200723bae0ca9384e6c5610ed9
