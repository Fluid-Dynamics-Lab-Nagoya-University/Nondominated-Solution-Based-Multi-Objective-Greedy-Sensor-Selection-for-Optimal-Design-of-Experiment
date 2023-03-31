% function [f,t_sort,t_comp,t_crowd1,t_crowd1_1,t_crowd1_2,t_crowd1_3,t_crowd2,t_crowd3] = F_ENS_SS_Lfix(x, M, V, Lmax)
function [f,t_sort,t_comp,t_crowd1,t_crowd2,t_crowd3] = F_ENS_SS_Lfix(x, M, V, Lmax)

% f = F_ENS_SS_Lfix.m : ------- Programer : Kumi Nakai, Taku Nonomura, 
%                                           Takayuki Nagata, Yuji Saito
%                               Last modified: 2021/9/27 K.Nakai
%  This function sort the current popultion based on non-domination. 
%  Xingyi Zhang; Ye Tian; Ran Cheng; Yaochu Jin, 
%  "An Efficient Approach to Nondominated Sorting for Evolutionary Multiobjective Optimization"
%  IEEE Transactions on Evolutionary Computation Vol. 19 Issue 2 pp. 201-213
%  The first front only implementation. 


%% Sorting based on the first objective (D-optimality)
tst_sort = tic;
[ ~ , iorder] = sort(x(:,V+1));
t_sort = toc(tst_sort);

%% ENS-SS
tst_comp = tic;
front     = 1; % initialize the front rank to 1
iselected = 0;
while true
    F(front).f = [];
    iorder_new = [];
    for i = iorder'
        dominated = 0 ;
        for j = F(front).f
            dom_cnt = 0;
            for k = 2 : M
                if x(i,V + k) < x(j,V + k)
                    break;
                else
                    dom_cnt = dom_cnt + 1;
                end
            end
            if dom_cnt == M - 1
                dominated = 1;
                break
            end
        end
        if dominated == 0
            x(i,M + V + 1) = front;
            F(front).f     = [i F(front).f];
        else
            iorder_new     = [iorder_new i];
        end
    end
    iorder    = iorder_new';
    iselected = iselected + size(F(front).f,2);
    F(front).f = fliplr(F(front).f);
    if iselected >= Lmax
        rankmax = front;
        break
    end
    front = front + 1 ;
end
x(find(x(:,M+V+1)==0),M+V+1) = front + 1;
t_comp = toc(tst_comp);

%%
tst_crowd1 = tic;
xfront = [];
for i=1:rankmax
    xfront = [xfront; x(F(i).f, 1:M+V+1)];
end
sorted_based_on_front = xfront;

%% Find the number and index/indeices of solution(s) in last rank
num_selected = 0;
for irank = 1 : rankmax-1
    num_selected = num_selected + numel(F(irank).f);
end
num_rankmax = size(F(rankmax).f,2); %number of solutions with rankmax
ind_rankmax = (sorted_based_on_front(:,M+V+1) == rankmax); %index vector of solutions with rankmax

%% Crowding distance
%The crowing distance is calculated as below
% For each front Fi, n is the number of individuals.
%   initialize the distance to be zero for all the individuals i.e. Fi(dj ) = 0,
%     where j corresponds to the jth individual in front Fi.
%   for each objective function m
%       * Sort the individuals in front Fi based on objective m i.e. I =
%         sort(Fi,m).
%       * Assign infinite distance to boundary values for each individual
%         in Fi i.e. I(d1) = ? and I(dn) = ?
%       * for k = 2 to (n ? 1)
%           · I(dk) = I(dk) + (I(k + 1).m ? I(k ? 1).m)/fmax(m) - fmin(m)
%           · I(k).m is the value of the mth objective function of the kth
%             individual in I

%%%%%Niche strategy
% Find the crowding distance for each individual in the last front
y = sorted_based_on_front(ind_rankmax, :);

% Sort each individual based on the objective
distance = zeros(num_rankmax, M); % crowding distance for each funciton
id_objmin = zeros(M, 1);
id_objmax = zeros(M, 1);
for i = 1 : M
    [~, index_of_objectives] = sort(y(:, V + i));
    sorted_based_on_objective = y(index_of_objectives, :);
    f_min = sorted_based_on_objective(1,           V + i);
    f_max = sorted_based_on_objective(num_rankmax, V + i);
    id_objmin(i) = index_of_objectives(1);
    id_objmax(i) = index_of_objectives(num_rankmax);
    distance(id_objmin(i), i) = Inf;
    distance(id_objmax(i), i) = Inf;
    for j = 2 : num_rankmax - 1
        next_obj     = sorted_based_on_objective(j + 1, V + i);
        previous_obj = sorted_based_on_objective(j - 1, V + i);
        if (f_max - f_min == 0)
            distance(index_of_objectives(j), i) = Inf;
        else
            distance(index_of_objectives(j), i) = ...
                (next_obj - previous_obj)/(f_max - f_min);
        end
    end
end
sum_distance = sum(distance, 2); % cronwding distance
y(:,M + V + 2) = sum_distance;
t_crowd1 = toc(tst_crowd1);

tst_crowd2 = tic;
%% Select sensors from the last front
id_objmin = unique(id_objmin); % removing duplication
id_objmax = unique(setdiff(id_objmax, id_objmin)); % removing duplication
no_objmin = length(id_objmin); % no. of sensors in the last front that minimize functions
no_objmax = length(id_objmax); % no. of sensors in the last front that maximize functions
id_objmin = id_objmin(randperm(no_objmin)); % avoid biased selection
id_objmax = id_objmax(randperm(no_objmax)); % avoid biased selection

Llast = Lmax - num_selected; % no. of sensors to be selected from the last front
w = zeros(Llast, M + V + 2); % sensors to be selected from the last front

t_crowd2 = toc(tst_crowd2);
tst_crowd3 = tic;
if Llast <= no_objmin
    w = y(id_objmin(1:Llast), :);
elseif Llast <= no_objmin + no_objmax
    w = y([id_objmin; id_objmax(1:Llast-no_objmin)], :);
else
    w(1:no_objmin + no_objmax, :) = y([id_objmin; id_objmax], :);
    isinf_distance = isinf(sum_distance);
    sum_distance(isinf_distance) = [];
    y(isinf_distance, :) = [];
    [~, id_sort_distance] = sort(sum_distance, 'descend');
    y = y(id_sort_distance, :);
    w(no_objmin + no_objmax + 1:end, :) = ...
        y(1:Llast - no_objmin - no_objmax, :);
end
f = [[sorted_based_on_front(1:num_selected, :), zeros(num_selected, 1)]; w];
t_crowd3 = toc(tst_crowd3);

end