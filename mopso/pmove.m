function npar = pmove( par,pbest,gbest,w,c1,c2 )

%in tabe ye chance box misazad, vali baraye har particle , na hameye
%particle ha be khatere hamin ma esme function ra chbox nagozashtim
chbox=zeros(w+c1+c2,size(par,2));
for i=1:w
    [l,m,n]=tspswap(par);
    chbox(i,:)=n;
end
for i=w+1:w+c1
    [l,m,n]=tspswap(pbest);
    chbox(i,:)=n;
end
for i=w+c1+1:w+c1+c2
    [l,m,n]=tspswap(gbest);
    chbox(i,:)=n;
end
r=randi(w+c1+c2);
npar=chbox(r,:);

end



