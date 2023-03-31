function y = partial_sort(x, L)

% x: vector with length L
% y: biggest L elements of x

N = length(x);
for i = 1:N-1
    for j = 2:N-i+1
        if x(j-1) > x(j)
            x(j-1) = tmp;
            x(j-1) = x(j);
            x(j) = tmp;
        end
    end
end
y = x(N-L+1:N);

end