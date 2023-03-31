function f = F_ENS_SS(x, M, V)

%% function f = F_ENS_SS(x, M, V)
%  This function sort the current popultion based on non-domination. 
%  Xingyi Zhang; Ye Tian; Ran Cheng; Yaochu Jin, 
%  "An Efficient Approach to Nondominated Sorting for Evolutionary Multiobjective Optimization"
%  IEEE Transactions on Evolutionary Computation Vol. 19 Issue 2 pp. 201-213
%  The first front only implementation. 
%  Impremented by Kumi Nakai, 


[N, m] = size(x);
clear m

% Initialize the front number to 1.
front = 1;

% There is nothing to this assignment, used only to manipulate easily in
% MATLAB.
F(front).f = [];
individual = [];

[ ~ , iorder] = sort(x(:,V+1));

for i = iorder' %jtmp=1:N
    dominated = 0 ;
    for j = F(front).f
        dom_count = 0;
        for k = 2 : M
            if x(i,V + k) > x(j,V + k)
                dom_count = dom_count + 1 ;
            end
            %disp(['i:' num2str(i) ' j:' num2str(j) ' k:' num2str(k) ' dom_count:' num2str(dom_count)]);
        end
        if dom_count == M - 1
            dominated = 1;
            break
        end
    end
    if dominated == 0
        x(i,M + V + 1) = 1;
        F(front).f = [i F(front).f];
    end
end

F(front).f = fliplr(F(front).f);

x(find(x(:,M+V+1)==0),M+V+1)=2;%front;

[temp,index_of_fronts] = sort(x(:,M + V + 1));
for i = 1 : length(index_of_fronts)
    sorted_based_on_front(i,:) = x(index_of_fronts(i),:);
end
current_index = 0;

%% Crowding distance
%The crowing distance is calculated as below
% • For each front Fi, n is the number of individuals.
%   – initialize the distance to be zero for all the individuals i.e. Fi(dj ) = 0,
%     where j corresponds to the jth individual in front Fi.
%   – for each objective function m
%       * Sort the individuals in front Fi based on objective m i.e. I =
%         sort(Fi,m).
%       * Assign infinite distance to boundary values for each individual
%         in Fi i.e. I(d1) = ? and I(dn) = ?
%       * for k = 2 to (n ? 1)
%           · I(dk) = I(dk) + (I(k + 1).m ? I(k ? 1).m)/fmax(m) - fmin(m)
%           · I(k).m is the value of the mth objective function of the kth
%             individual in I

%%%%%Niche strategy
% Find the crowding distance for each individual in each front   
%for front = 1 : (length(F) - 1)
for front = 1 : length(F) 
%    objective = [];
    distance = 0;
    y = [];
    previous_index = current_index + 1;
    for i = 1 : length(F(front).f)
        y(i,:) = sorted_based_on_front(current_index + i,:);
    end
    current_index = current_index + i;
    % Sort each individual based on the objective
    sorted_based_on_objective = [];
    for i = 1 : M
        [sorted_based_on_objective, index_of_objectives] = ...
            sort(y(:,V + i));
        sorted_based_on_objective = [];
        for j = 1 : length(index_of_objectives)
            sorted_based_on_objective(j,:) = y(index_of_objectives(j),:);
        end
        f_max = ...
            sorted_based_on_objective(length(index_of_objectives), V + i);
        f_min = sorted_based_on_objective(1, V + i);
        y(index_of_objectives(length(index_of_objectives)),M + V + 1 + i)...
            = Inf;
        y(index_of_objectives(1),M + V + 1 + i) = Inf;
        for j = 2 : length(index_of_objectives) - 1
            next_obj  = sorted_based_on_objective(j + 1,V + i);
            previous_obj  = sorted_based_on_objective(j - 1,V + i);
            if (f_max - f_min == 0)
                y(index_of_objectives(j),M + V + 1 + i) = Inf;
            else
                y(index_of_objectives(j),M + V + 1 + i) = ...
                     (next_obj - previous_obj)/(f_max - f_min);
            end
        end
    end
    distance = [];
    distance(:,1) = zeros(length(F(front).f),1);
    for i = 1 : M
        distance(:,1) = distance(:,1) + y(:,M + V + 1 + i);
    end
    y(:,M + V + 2) = distance;
    y = y(:,1 : M + V + 2);
    z(previous_index:current_index,:) = y;
end
f = z();




