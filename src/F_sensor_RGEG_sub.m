function [isensors,History] = F_sensor_RGEG_sub(U, pmax, Lmax, ns)
%for debug
History = cell(2,pmax);
%end for debug    
% Lmax=50;
[nmax,r]=size(U);
isensors=[];
for p = 1:pmax
    if p == 1         
        objlist_all  = [];
        isensors_all = [];        
        [isensors_inc, objlist] = F_sensor_REG_inc(U, p, isensors, Lmax, ns);
        objlist_all  = [ objlist_all  ; objlist ] ;
        isensors_all = [ isensors_all ; isensors_inc ]; 
    else 
        objlist_all  = [];
        isensors_all = [];

        for L=1:Lmax
            [isensors_inc, objlist] = F_sensor_REG_inc(U, p, isensors(L,:), Lmax, ns);
            objlist_all  = [ objlist_all  ; objlist ] ;
            isensors_all = [ isensors_all ; [ repmat(isensors(L,:), [Lmax,1]) isensors_inc ] ]; 
        end
    end
    [objmaxtmp,indx] = maxk(objlist_all,Lmax*10);
    if Lmax == 1
        isensors = isensors_all(indx(1),:);
        objmax   = objmaxtmp(1,:);
        %disp(['sub', num2str(isensors)])
    else       
        isensors = zeros(Lmax,p);
        isensors = isensors_all(indx(1),:);
        Ltmp=1;
        for L=2:Lmax*10
            isensors_tmp = isensors_all(indx(L),:);
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
    %for debug
    Histroy{1,p}=objmax;
    Histroy{2,p}=isensors;
    %end for debug 
end 
