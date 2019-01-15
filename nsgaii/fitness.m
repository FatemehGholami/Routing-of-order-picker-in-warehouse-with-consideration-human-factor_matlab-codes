function cost=fitness(sol,data)

sol = sol.pos;
x=zeros(data.N,data.N);
wp=zeros(1,data.N);
v=zeros(data.N,data.N);
de=zeros(data.N,data.N);
e=zeros(data.N,data.N);
t=zeros(data.N,data.N);
 
x(1,sol(1)+1) = 1;
x(sol(data.nvar)+1,1)=1;

for i=1:(data.nvar-1)
    x(sol(i)+1,sol(i+1)+1)=1;
end


wp(1) = data.w0;
wp(sol(1)+1) = data.w0 + data.w(sol(1));
for i=1:(data.nvar-1)
    wp(sol(i+1)+1)=wp(sol(i)+1) + data.w(sol(i+1));
end
z1=0;
z2=0;
for i=1:data.N
    for j=1:data.N
        de(i,j)= (10^-2)*data.d(i,j)*(0.112*data.bw + 1.15*wp(i)*data.a + 0.505*data.s*wp(i)*data.a);
        v(i,j) = data.vmax*(1- data.v1*(wp(i)^data.v2));
        t(i,j) = data.d(i,j)/v(i,j);
        e(i,j) = 0.024*data.bw*(t(i,j)/60) + de(i,j);
        z1 = z1 + t(i,j)*x(i,j);
        z2 = z2 + e(i,j)*x(i,j);
    end
end


cost = [z1 z2]';

end
