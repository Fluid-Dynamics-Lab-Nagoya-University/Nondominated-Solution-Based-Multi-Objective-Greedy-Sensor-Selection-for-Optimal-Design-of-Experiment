function[isensors_inc, objlist]= F_sensor_eliteRDG_inc(Uorg, isensors, L, ns, isensors_DG)
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
        
    %Store DG solution as sensor candidate
    isensors_DG_indp=isensors_DG(~ismember(isensors_DG,isensors));
    U=Uorg(isensors_DG_indp,:);
    [pov,~]=size(isensors_DG_indp);
    %generate randomized subspace from independent space
    indp=1:n;
    %%
%        size(isensors_DG);
%        size(isensors);
    %%
    indx_chosen=unique([isensors_DG; isensors']);

    indp(indx_chosen')=[];
    [~,n_indp]=size(indp);
    randind=randperm(n_indp,ns-pov-p+1);
    %disp(ns-(n-n_indp))
    %disp(ns-pov)
    Uindp=Uorg(indp(randind)',:);
    

    %combine sensor candidate matrix
    U=[U; Uindp; Uorg(isensors,:)]; % if ns>n-p+1, the selection goes over zero columns in U's bottom
    % U=[U; Uindp; zeros(p-1,r)]; % if ns>n-p+1, the selection goes over zero columns in U's bottom
    indx=[isensors_DG_indp' indp(randind) isensors];
    %size(U)
    %size(indx)

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
    isensors_inc = indx(isensors_inc)'; % column
    %THETApp(pp,:)=U(sensor(pp),:);
    %U(sensor(pp),:) = zeros(1,r);

    %isensors=sensor';  
end