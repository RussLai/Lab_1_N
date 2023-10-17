function [invest,obj]=findoptimal(Demand,Adopt1,Fixedcost,Varcost,Agent,taxrate,period,subsidy,strategy,strat,i,j,coor,saving, total,obj,dep)

invest=0;

strat(i,j)=mean(nonzeros(strategy(i,j,:)));

%moving average
if isnan(strat(i,j))
    lb=0;
    ub=10;
else
    lb=(strat(i,j))-5;
    ub=(strat(i,j))-5;
end

%current income
taxinc=0;
for a=1:size(Agent,2)
    if Agent(a).cityi==i && Agent(a).cityj==j
    taxinc=taxinc+Agent(a).income;
    end 
end 

%constraint
total=total+saving;

%local agents
agentlist=[];
for a=1:size(Agent,2)
    if Agent(a).cityi>=coor(1) && Agent(a).cityi<=coor(2) && Agent(a).cityj>=coor(3) && Agent(a).cityj<=coor(4)
    agentlist(end+1)=a;
    end 
end

%Base case
if period==1
    %investment and price adjustment
    num=total;
    Adopt1=Adopt1+strat;
    Adopt1(i,j)=Adopt1(i,j)-strat(i,j);
    Adopt1(i,j)=Adopt1+num;
    obj=obj+taxinc;

    Price=Demand-1./Adopt1;
    minprice=min(Price(:));
    if minprice<0
        Price=Price+abs(minPrice);
    end

    %move agents
    for agent=randperm(agentlist)
        loci=Agent(i).cityi;
        locj=Agent(j).cityj;
        [loc1,loc2]=opt_utility(agent,Price,Agent,taxrate);
        Demand(loci,locj)=Demand(loci,locj)-Agent(agent).weight;
        Agent(agent).cityi=loc1;
        Agent(agent).cityj=loc2;
        Demand(loc1,loc2)=Demand(loc1,loc2)+Agent(agent).weight;
    end

    %return obj with discount rate
    obj=obj+(0.9^4)*taxinc;
    invest=num;
    return 

end 

maxobj=0;

%Recursive case
for num=lb:0.1:ub
    Adopt1=Adopt1+strat;
    Adopt1(i,j)=Adopt1(i,j)-strat(i,j);
    Adopt1(i,j)=Adopt1(i,j)+num;
    Adopt1=Adopt1*(1-dep);
    strategy(i,j,1)=strategy(i,j,2);
    strategy(i,j,2)=strategy(i,j,3);
    strategy(i,j,3)=invest;
    saving=total-Fixedcost(i,j)-(Varcost(i,j)-subsidy)*num;
    
    %Apply constraint
    if saving<0
        break
    end 
    
    %Adjustment
    Varcost=1./Adopt1;
    Price=Demand-1./Adopt1;
    minprice=min(Price(:));
    if minprice<0
        Price=Price+abs(minPrice);
    end
    
    %move agents
    for agent=randperm(agentlist)
        loci=Agent(i).cityi;
        locj=Agent(j).cityj;
        [loc1,loc2]=opt_utility(agent,Price,Agent,taxrate);
        Demand(loci,locj)=Demand(loci,locj)-Agent(agent).weight;
        Agent(agent).cityi=loc1;
        Agent(agent).cityj=loc2;
        Demand(loc1,loc2)=Demand(loc1,loc2)+Agent(agent).weight;
    end

    %compute income and obj
    taxinc=0;
    for a=1:size(Agent,2)
        if Agent(a).cityi==i && Agent(a).cityj==j
            taxinc=taxinc+Agent(a).income;
        end 
    end 

    obj=obj+(0.9^(5-period))*taxinc;
    
    %Recursion
    [~,obj]=findoptimal(Demand,Adopt,Fixedcost,Varcost,Agent,taxrate,period-1,subsidy,strategy,strat,i,j,coor,saving, total,obj,dep);

    %final return
    if obj>maxobj
        maxobj=obj;
        invest=num;
    end 
end 








