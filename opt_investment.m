function invest=opt_investment(Demand,Adopt,i,j,Fixedcost,Varcost,Agent,taxrate,period,subsidy,strategy,dep)

%proper coordinates
coor=zeros(1,4);
sz=size(strategy,1);
k=4;

south = [i+k  sz  sz i+k];
north = [1  i-k  1 i-k];
east  = [j+k  sz  sz j+k];
west  = [1  j-k  1 j-k];
        
c{1} = south;  c{2} = north;  c{3} = east;  c{4} = west;
for m = 1:4
    if (c{m}(1) > c{m}(2))
        coor(m) = c{m}(3);
    else 
        coor(m)= c{m}(4);
    end 
end

%fix strategy
strat=zeros(sz,sz);
for p=1:sz
    for q=1:sz
        strat(p,q)=mean(nonzeros(strategy(p,q,:)));
    end 
end 

subsidy=subsidy(i,j);

%optimal amount
invest=findoptimal2(Demand,Adopt,Fixedcost,Varcost,Agent,taxrate,period,subsidy,strategy,strat,i,j,coor,0,0,0,dep);







