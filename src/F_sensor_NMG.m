function [time, sensors_NMG, fND, time2] = F_sensor_NMG(U, p, Lmax, Rmax, nds_switch)

    tic;
    numND=1;
    sensors_NMG = [];
    for pp=1:p
        sensors=[];
        obj=[];
        % disp('CHP1 for debug');
        %% Evaluation of candidates
        tst_calcobj = tic;
        if pp == 1
                [   sensors,    obj] = F_sensor_calc_DAE(U, sensors_NMG);
        else
            for i=1:numND
                [tmpsensors, tmpobj] = F_sensor_calc_DAE(U, sensors_NMG(i,:));
                sensors = [ sensors ; tmpsensors ];
                obj     = [ obj     ; tmpobj     ];
                %size(tmpobj)
            end
        end
        % disp('CHP2 for debug');
        %% removal of overlap indices
        sensors = sort(sensors, 2);
        [sensors, ia] = unique(sensors, 'row', 'sorted');
        obj = obj(ia, :);
        
        time2.calcobj(pp,1) = toc(tst_calcobj);
        
        %% Preparation for nondominated sorting 
        tst_nds = tic;
        % disp('CHP3 for debug');
        x = [sensors obj] ;
        [~,M] = size(obj) ;
        [~,V] = size(sensors) ;
        
        %% Nondominated solution for next step 
        if nds_switch == 0     % VER. standard
            f = F_ENS_SS(x, M, V);
            iND = find(f(:,M+V+1)==1);
        elseif nds_switch == 1 % VER. ENS-SS_Rfix
            f = F_ENS_SS_Rfix(x, M, V, Rmax);
            iND = find(f(:,M+V+1)<=Rmax);
        elseif nds_switch == 2 % VER. ENS-SS_Lfix
            [f,time2.sort(pp,1),time2.comp(pp,1),time2.crowd1(pp,1),...
             time2.crowd2(pp,1),time2.crowd3(pp,1)] ...
            = F_ENS_SS_Lfix(x, M, V, Lmax);
%             [f,time2.sort(pp,1),time2.comp(pp,1),time2.crowd1(pp,1),...
%              time2.crowd1_1(pp,1),time2.crowd1_2(pp,1),time2.crowd1_3(pp,1),...
%              time2.crowd2(pp,1),time2.crowd3(pp,1)] ...
%             = F_ENS_SS_Lfix(x, M, V, Lmax);
            iND =1:Lmax;
        elseif nds_switch == 3 % Ver. T-ENS
            [f,time2.sort(pp,1),time2.comp(pp,1),time2.crowd(pp,1)] ...
            = F_TENS(x, M, V, Lmax);
            iND =1:Lmax;
        elseif nds_switch == 4 % Ver. T-ENS
            [f,time2.sort(pp,1),time2.comp(pp,1),time2.crowd1(pp,1),...
             time2.crowd2(pp,1),time2.crowd3(pp,1)] ...
            = F_ENS_SS_Lfix_old(x, M, V, Lmax);
            iND =1:Lmax;
%         else % VER.original
%             f = F_non_domination_sort(x, M, V);
        end
        
        % disp('CHP4 for debug');
        sensors_NMG = f(iND,1:V);
        [numND,~] = size(sensors_NMG);
        % disp(['Number of nondominated solution:', num2str(numND), ' of ', num2str(pp), ' th sensor selection']);
        fND = f(iND,:);
        time2.nds(pp,1) = toc(tst_nds);
    end
    %fND = f(iND,:);
    % [H]=F_calc_sensormatrix(p, n, sensors_NMG); 
    time=toc;
    
end