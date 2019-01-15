n = 10;
d = randi([2, 100], [n n]);

for i =1:n
    d(i,i) = 0;
    for j = 1:n
        distance(i,j) = d(i,j);
        distance(j,i) = d(i,j);
    end
end