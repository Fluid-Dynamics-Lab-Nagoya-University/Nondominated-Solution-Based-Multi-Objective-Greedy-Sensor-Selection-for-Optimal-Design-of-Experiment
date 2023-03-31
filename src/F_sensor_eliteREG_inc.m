function[isensors_inc, objlist]= F_sensor_eliteREG_inc(Uorg, isensors, Lmax, ns, isensors_elite)
    [~,p]=size(isensors);
    p=p+1;
    
    [n,r]=size(Uorg);
    
    % sensor=zeros(1,p-1);
    C = Uorg(isensors,1:end);
    %THETAppTHETApptinv=zeros(p-1,p-1);

    %Overlap of selection is reset by assign 0 for sensor candidate
    for pp=1:p-1
        Uorg(isensors(pp),:)=zeros(1,r);
    end
        
    %Store EG solution as sensor candidate
    isensors_elite_indp=isensors_elite(~ismember(isensors_elite,isensors));
    U=Uorg(isensors_elite_indp,:);
    [pov,pov2]=size(isensors_elite_indp);
    %generate randomized subspace from independent space
    indp=1:n;
    %%
%        size(isensors_DG);
%        size(isensors);
    %%

    indx_chosen=unique([isensors_elite; isensors']);

    indp(indx_chosen')=[];
    [~,n_indp]=size(indp);
    randind=randperm(n_indp,ns-pov-p+1);
    %disp(ns-(n-n_indp))
    %disp(ns-pov)
    Uindp=Uorg(indp(randind)',:);
    
    %combine sensor candidate matrix
    U=[U; Uindp; Uorg(isensors,:)]; % if ns>n-p+1, the selection goes over zero columns in U's bottom
    % U=[U; Uindp; zeros(p-1,r)]; % if ns>n-p+1, the selection goes over zero columns in U's bottom
    indx=[isensors_elite_indp' indp(randind) isensors];
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

    obj=zeros(1,ns);
    if p <= r
        for i=1:1:ns
            obj(i)=min(eig( [C;U(i,:)] * [C' U(i,:)'])); % Fastest
            % obj(i)=eigs( [C;U(i,:)] * [C' U(i,:)'], 1, 'smallestabs'); %usable in R2020a but higher cost
            % obj(i)=svds( [C;U(i,:)] * [C' U(i,:)'], 1, 'smallest'); %usable in R2020a but higher cost
        end
    else
        for i=1:1:ns
            obj(i)=min(eig( C'*C + U(i,:)'*U(i,:) ));
            % obj(i)=eigs( C'*C + U(i,:)'*U(i,:), 1, 'smallestabs');
            % obj(i)=svds( C'*C + U(i,:)'*U(i,:), 1, 'smallest');
        end
    end
    
    %% Take k components of maximum
    [eiglist, isensors_inc]=maxk(obj, Lmax);

    objlist = eiglist'; % column
    isensors_inc = indx(isensors_inc)'; % column
    %THETApp(pp,:)=U(sensor(pp),:);
    %U(sensor(pp),:) = zeros(1,r);

    %isensors=sensor';  
end