function [isensors_inc, objlist]=F_sensor_REG_inc(Uorg, p, isensors, Lmax, ns)
    % objective function: minimum eigenvalue(CCT), (CTC)

    [n,r]=size(Uorg);
    [~,p] = size(isensors);   % <------- modified to p from pp
    p = p + 1;
%     H=zeros(p,n);

    C = Uorg(isensors,:);
    %Overlap of selection is reset by assign 0 for sensor candidate
    for pp=1:p-1   % <------- if p=1, pp is empty
        Uorg(isensors(pp),:) = zeros(1,r);
    end
    randind = randperm(n,ns);
    U = Uorg(randind,:);

    %anotherway
    %ns=min(n-p+1,ns)
    %randind=randperm(n)
    %for pp=1:p-1
    %    randind(find(randind == isensors(pp))) = [];
    %end
    %randind=randind(1:ns);
    %U=Uorg(randind,:);

    % for pp=1:1:p
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
        % disp(obj)
        [eiglist, isensors_inc]=maxk(obj, Lmax);
        objlist = eiglist';
        % isensors_inc =  isensors_inc';
        isensors_inc = randind(isensors_inc)'; % column
        % C=[C;U(isensor(pp),:)]; % for next step calculation
        % U(isensor(pp),:)=zeros(1,r); % zero reset to exclude from candidate
    % end
%     disp('objRGEG')
%     disp(eiglist(1,Lmax))


end