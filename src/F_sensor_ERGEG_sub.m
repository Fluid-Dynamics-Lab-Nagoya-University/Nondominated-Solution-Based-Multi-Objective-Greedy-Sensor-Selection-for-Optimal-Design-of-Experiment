<<<<<<< HEAD
function [isensors,History,time_elite] = F_sensor_ERGEG_sub(U, pmax, Lmax, ns, pov)
%for debug
History = cell(2,pmax);
%end for debug    
% Lmax=50;
[nmax,r]=size(U);
isensors=[];
[time_elite, ~, isensors_elite] = F_sensor_EG(U, pov); % normal EG beforehand

for p = 1:pmax
%    disp(['p = ', num2str(p)])
    if p == 1
        objlist_all  = [];
        isensors_all = [];
        [isensors_inc, objlist] = F_sensor_eliteREG_inc(U, isensors, Lmax, ns, isensors_elite);
        objlist_all  = [ objlist_all  ; objlist ] ;
        isensors_all = [ isensors_all ; isensors_inc ];
    else
        objlist_all  = [];
        isensors_all = [];
        for L=1:Lmax
            % [isensors_inc, objlist] = F_sensor_RDG_inc(U, isensors(L,:), Lmax,ns);
            [isensors_inc, objlist] = F_sensor_eliteREG_inc(U, isensors(L,:), Lmax, ns, isensors_elite); % utilize normal EG solution, column vector
            objlist_all  = [ objlist_all  ; objlist ] ;
            isensors_all = [ isensors_all ; [ repmat(isensors(L,:), [Lmax,1]) isensors_inc ] ];
        end
    end
    [objmaxtmp,indx] = maxk(objlist_all,Lmax*10);

    %%
    [H]=F_calc_sensormatrix(p, nmax, isensors_elite);
    C = H*U;
    if p <= r
        objmax(1,1) = min(eig(C*C'));
    else
        objmax(1,1) = min(eig(C'*C));
    end
    %%

    if Lmax == 1
        isensors = isensors_all(indx(1),:);
        objmax   = objmaxtmp(1,:);
        %disp(['sub', num2str(isensors)])
    else
        isensors = zeros(Lmax,p);
        isensors = isensors_elite(1:p,:)'; % solution of normal DG as the first parent, plus group solutions as Lmax-1 parents
        Ltmp=1;        
        for L=1:Lmax*10 %% for L=2:Lmax*2
            isensors_tmp = isensors_all(indx(L),:);   % ?
            if norm(sort(isensors(Ltmp,:))-sort(isensors_tmp)) ~= 0
                Ltmp = Ltmp + 1;
                isensors(Ltmp,:) = isensors_tmp;
                objmax  (Ltmp,:) = objmaxtmp(L);
            end
            if Ltmp == Lmax
                break;
            end
        end
        if Ltmp ~= Lmax
            disp('Ltmp < Lmax')
            stop
        end
    end
    [~,sortind]=sort(objmax,'descend');
    %for debug
    Histroy{1,p}=objmax(sortind);
    Histroy{2,p}=isensors(sortind,:);
    %end for debug 
end 
isensors=isensors(sortind,:);
%size(isensors)
=======
function [isensors,History,time_elite] = F_sensor_ERGEG_sub(U, pmax, Lmax, ns, pov)
%for debug
History = cell(2,pmax);
%end for debug    
% Lmax=50;
[nmax,r]=size(U);
isensors=[];
[time_elite, ~, isensors_elite] = F_sensor_EG(U, pov); % normal EG beforehand

for p = 1:pmax
%    disp(['p = ', num2str(p)])
    if p == 1
        objlist_all  = [];
        isensors_all = [];
        [isensors_inc, objlist] = F_sensor_eliteREG_inc(U, isensors, Lmax, ns, isensors_elite);
        objlist_all  = [ objlist_all  ; objlist ] ;
        isensors_all = [ isensors_all ; isensors_inc ];
    else
        objlist_all  = [];
        isensors_all = [];
        for L=1:Lmax
            % [isensors_inc, objlist] = F_sensor_RDG_inc(U, isensors(L,:), Lmax,ns);
            [isensors_inc, objlist] = F_sensor_eliteREG_inc(U, isensors(L,:), Lmax, ns, isensors_elite); % utilize normal EG solution, column vector
            objlist_all  = [ objlist_all  ; objlist ] ;
            isensors_all = [ isensors_all ; [ repmat(isensors(L,:), [Lmax,1]) isensors_inc ] ];
        end
    end
    [objmaxtmp,indx] = maxk(objlist_all,Lmax*10);

    %%
    [H]=F_calc_sensormatrix(p, nmax, isensors_elite);
    C = H*U;
    if p <= r
        objmax(1,1) = min(eig(C*C'));
    else
        objmax(1,1) = min(eig(C'*C));
    end
    %%

    if Lmax == 1
        isensors = isensors_all(indx(1),:);
        objmax   = objmaxtmp(1,:);
        %disp(['sub', num2str(isensors)])
    else
        isensors = zeros(Lmax,p);
        isensors = isensors_elite(1:p,:)'; % solution of normal DG as the first parent, plus group solutions as Lmax-1 parents
        Ltmp=1;        
        for L=1:Lmax*10 %% for L=2:Lmax*2
            isensors_tmp = isensors_all(indx(L),:);   % ?
            if norm(sort(isensors(Ltmp,:))-sort(isensors_tmp)) ~= 0
                Ltmp = Ltmp + 1;
                isensors(Ltmp,:) = isensors_tmp;
                objmax  (Ltmp,:) = objmaxtmp(L);
            end
            if Ltmp == Lmax
                break;
            end
        end
        if Ltmp ~= Lmax
            disp('Ltmp < Lmax')
            stop
        end
    end
    [~,sortind]=sort(objmax,'descend');
    %for debug
    Histroy{1,p}=objmax(sortind);
    Histroy{2,p}=isensors(sortind,:);
    %end for debug 
end 
isensors=isensors(sortind,:);
%size(isensors)
>>>>>>> 6150b0a6442ac2200723bae0ca9384e6c5610ed9
