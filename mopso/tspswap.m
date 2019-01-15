function [l,m,n ] = tspswap(a)
l=randi(length(a));
m=randi(length(a));
while l==m

m=randi(length(a));
end
n=a;
b=n(l);
n(l)=n(m);
n(m)=b;



end

