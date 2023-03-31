function[isensors_inc, objlist]= F_sensor_DG_inc(U, p, isensors,L)

    [n,r]=size(U);
    % THETApp=zeros(p,r);
    abs=zeros(1,n);
    tmp=zeros(1,r);
    sensor=zeros(1,p);
    THETApp = U(isensors,1:end);    
    THETAppTHETApptinv=zeros(p,p);
    
    if p == 1 
        %% p=1
        for nn=1:n
            detTHETA = 1;
            tmp(1,:)=U(nn,:);
            J(nn)=tmp(1,:)*tmp(1,:)';
        end       
        J(isensors) = 0;
    elseif p <= r
        %% 1<p<=r
        detTHETA = det(THETApp*THETApp');
        THETAppTHETApptinv=inv(THETApp*THETApp');
        Y=eye(r)-THETApp'*THETAppTHETApptinv*THETApp;
        for nn=1:n
            tmp(1,:) = U(nn,:);
            J(nn) = tmp(1,:)*Y*tmp(1,:)';
        end
        J(isensors) = 0;
    else 
        %% r<p
        detTHETA = det(THETApp'*THETApp);
        THETApptTHETAppinv=inv(THETApp'*THETApp);
        for nn=1:n
            tmp(1,:) = U(nn,:);
            J(nn) = 1 + tmp*THETApptTHETAppinv*tmp';
        end           
        J(isensors) = 0;
    end
    % disp(J)
    J=J.*detTHETA;
    %[~,sensor(pp)]=max(abs);
    
    %% Take k components of maximum
    [detlist, isensors_inc] = maxk(J,L);
    objlist = detlist'; % column
    isensors_inc = isensors_inc'; % column
    %THETApp(pp,:)=U(sensor(pp),:);
    %U(sensor(pp),:) = zeros(1,r);

    %isensors=sensor';  
end