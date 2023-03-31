<<<<<<< HEAD
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

=======
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

>>>>>>> 6150b0a6442ac2200723bae0ca9384e6c5610ed9
end