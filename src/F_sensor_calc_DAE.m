function [isensors ,obj] = F_sensor_calc_DAE(U, isensors)
    % objective function: minimum eigenvalue(CCT), (CTC)

    [n,r]=size(U);
    [~,p]=size(isensors);
    p = p + 1;
    v = 3;
    diff_sensors = setdiff(1:n, isensors);
    n2 = length(diff_sensors);
    obj = zeros(n2, v);
%    H=zeros(p,n);
    
    % sensor=zeros(1,p-1);
    C = U(isensors,1:end);
    %C = zeros(p-1,p-1);

    %Overlap of selection is reset by assign 0 for sensor candidate
    for pp=1:p-1
        U(isensors(pp),:)=zeros(1,r);
    end


    if p == 1
        for ii = 1:n2   % <---
            i = diff_sensors(ii);
            obj(ii,1) = - U(i,:) * U(i,:)';
            obj(ii,2) = - 1/obj(i,1);
            obj(ii,3) =   obj(ii,1);
        end        
    else
        if p <= r
            PFIM = C*C';
            detPFIM   = det(PFIM);
            IPFIM     = inv(PFIM);
            trIPFIM   = trace(IPFIM);
            Y         = eye(r) - C'*IPFIM*C;
            A1        = IPFIM*C;
            A2        = eye(r,r) - C'*A1;
            for ii = 1:n2   % <---
                i = diff_sensors(ii);
                obj(ii,1) = - U(i,:)*Y*U(i,:)'*detPFIM; 
                obj(ii,2) =   ( norm(A1*U(i,:)',2)^2+1 ) / ( U(i,:)*A2*U(i,:)' ) + trIPFIM; 
                obj(ii,3) = - min(eig( [C;U(i,:)] * [C' U(i,:)']));
            end
        else
            PFIM=C'*C;
            detPFIM   = det(PFIM);
            IPFIM     = inv(PFIM);
            trIPFIM   = trace(IPFIM);
            for ii = 1:n2   % <---
                i = diff_sensors(ii);
                obj(ii,1) = - (1 + U(i,:)*IPFIM*U(i,:)')*detPFIM ;
                obj(ii,2) = - ( U(i,:)*IPFIM^2*U(i,:)' ) / ( 1+U(i,:)*IPFIM*U(i,:)' ) + trIPFIM;  %tr[inv(CTC)]
                obj(ii,3) = - min(eig( PFIM + U(i,:)'*U(i,:) ));
            end
        end
    end
    isensors  = [ repmat(isensors, n2, 1) diff_sensors' ];
% size(isensors)
% disp(isensors)

end