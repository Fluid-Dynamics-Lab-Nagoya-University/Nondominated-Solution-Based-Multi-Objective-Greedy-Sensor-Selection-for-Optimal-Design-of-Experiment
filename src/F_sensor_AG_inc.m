function [isensors_inc, objlist]=F_sensor_AG_inc(U, p, isensors, Lmax)
    % objective function: minimum eigenvalue(CCT), (CTC)

    [n,r]=size(U);
    [~,pp] = size(isensors);
    pp = pp + 1;

    C = U(isensors,:);
    obj=zeros(1,n);

    if pp == 1
        for i=1:n
            obj(i) = 1/(U(i,:) * U(i,:)');
        end
    elseif pp <= r
        PFIM = C*C';
        IPFIM     = inv(PFIM);
        trIPFIM   = trace(IPFIM);
        A1        = IPFIM*C;
        A2        = eye(r,r) - C'*A1;
        for i=1:n
            obj(i) = ( norm(A1*U(i,:)',2)^2+1 ) / ( U(i,:)*A2*U(i,:)' ) + trIPFIM;%2021/5/6nakai-revise
        end
    else
        PFIM=C'*C;
        IPFIM     = inv(PFIM);
        trIPFIM   = trace(IPFIM);      
        for i=1:n
            obj(i) = - ( U(i,:)*IPFIM^2*U(i,:)' ) / ( 1+U(i,:)*IPFIM*U(i,:)' ) + trIPFIM;%2021/5/6nakai-revise
        end
    end
    obj(isensors) = inf;
    % disp(obj)
    [trlist, isensors_inc]=mink(obj, Lmax);
    objlist = trlist';
    isensors_inc =  isensors_inc';
end