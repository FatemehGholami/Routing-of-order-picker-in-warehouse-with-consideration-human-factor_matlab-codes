function  pop=sorting(pop)

[~,index]=sort([pop.cdis],'descend');
pop=pop(index);

[~,index]=sort([pop.rank]);
pop=pop(index);



end