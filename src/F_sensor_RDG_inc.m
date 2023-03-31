function[isensors_inc, objlist]= F_sensor_RDG_inc(Uorg, isensors, L, ns)
    [~,p]=size(isensors);
    p=p+1;
    
    [n,r]=size(Uorg);
    % THETApp=zeros(p,r);
    abs=zeros(1,n);
    tmp=zeros(1,r);
    % sensor=zeros(1,p-1);
    THETApp = Uorg(isensors,1:end);
    THETAppTHETApptinv=zeros(p-1,p-1);

    %Overlap of selection is reset by assign 0 for sensor candidate
    for pp=1:p-1
        Uorg(isensors(pp),:)=zeros(1,r);
    end
    randind=randperm(n,ns);
    U=Uorg(randind,:);

    %anotherway
    %ns=min(n-p+1,ns)
    %randind=randperm(n)
    %for pp=1:p-1
    %    randind(find(randind == isensors(pp))) = [];
    %end
    %randind=randind(1:ns);
    %U=Uorg(randind,:);

    if p == 1 
        %% p=1
        for nn=1:ns   % <---
            detTHETA = 1;
            tmp(1,:)=U(nn,:);
            J(nn)=tmp(1,:)*tmp(1,:)';
        end       
    elseif p <= r 
        %% 1<p<=r
        detTHETA = det(THETApp*THETApp');
        THETAppTHETApptinv=inv(THETApp*THETApp');
        Y=eye(r)-THETApp'*THETAppTHETApptinv*THETApp;
        for nn=1:ns
            tmp(1,:) = U(nn,:);
            J(nn) = tmp(1,:)*Y*tmp(1,:)';
        end        
    else 
        %% r<p
        detTHETA = det(THETApp'*THETApp);
        THETApptTHETAppinv=inv(THETApp'*THETApp);
        for nn=1:ns
            tmp(1,:) = U(nn,:);
            J(nn) = 1 + tmp*THETApptTHETAppinv*tmp';
        end           
    end
    % disp(J)
    J=J.*detTHETA;
    %[~,sensor(pp)]=max(abs);
    
    %% Take k components of maximum
    [detlist, isensors_inc] = maxk(J,L);
    objlist = detlist'; % column
    isensors_inc = randind(isensors_inc)'; % column
    %THETApp(pp,:)=U(sensor(pp),:);
    %U(sensor(pp),:) = zeros(1,r);

    %isensors=sensor';  
end