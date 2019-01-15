function  pop=crowding_distance(pop,F)

nf=length(F);
nobj=length(pop(1).cost);
npop=length(pop);


C=[pop.cost]';

emp.value=[];
emp.index=[];
sortf=repmat(emp,nf,nobj);


for i=1:npop
    
    fi=pop(i).rank;
    m=F{fi};
    nm=length(m);
    Cfi=C(m,:);
    crdis=0;
    
    for o=1:nobj
        
        Cobj=Cfi(:,o);
        
        if isempty(sortf(fi,o).value)
           [value,index]=sort(Cobj);
           sortf(fi,o).value=value;
           sortf(fi,o).index=m(index);
           sortf(fi,o).maxvalue=value(end);
           sortf(fi,o).minvalue=value(1);
        end
        
        value=sortf(fi,o).value;
        index=sortf(fi,o).index;
        maxvalue=sortf(fi,o).maxvalue;
        minvalue=sortf(fi,o).minvalue;
        
        
        j=find(index==i);
        
        
        if j==1 || j==nm
            crdis=crdis+inf;
        else
            
            valueC=value(j+1);
            valueA=value(j-1);
            
            crdisB=abs(valueC-valueA)/(maxvalue-minvalue);
            crdis=crdis+crdisB;

        end
        
        
    end
    
    pop(i).cdis=crdis;
    
    
end





end








