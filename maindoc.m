clear 

numcity=100;
taxrate=0.2;
period=4;
fraction=1.25;
% depreciate=0.02;

%cost difference
Fixedcost=rand(numcity);

%initialize adoption
Adopt=rand(numcity)+5;

%Initialize variable cost
Varcost=1./Adopt;

%initial agent
numAgents=numcity^2*fraction;

inc=zeros(1,numAgents);
for i=1:numAgents
    inc(i)=lognrnd(3.5,1);
end 
mininc=abs(min(inc(:)));
inc=inc+mininc;


Agent(1,numAgents)=struct();
for i=1:numAgents
        Agent(i).weight=rand();
        Agent(i).income=inc(i);
        Agent(i).cityi=randi(numcity);
        Agent(i).cityj=randi(numcity);
        Agent(i).sight=randi(5);
end 

%Initial demand
Demand=zeros(numcity);
for i=1:numAgents
    p=Agent(i).cityi;
    q=Agent(i).cityj;
    Demand(p,q)=Demand(p,q)+Agent(i).weight;
end

%Initial Price
Price=Demand-1./Adopt;
minprice=min(Price(:));
if minprice<0
    Price=Price+abs(minprice);
end 

%Initial Strategy
strategy=zeros(numcity,numcity,3);


%simulation
nruns=500;
mu=0.7;
sigma=0.1;
for runs=1:nruns
%     subsidy=normrnd(mu,sigma);
    %city investment
    sub=1./Adopt;
    submean=mean(sub(:));
    subsd=std(sub(:));
    sub=(sub-submean)./subsd;
    subsidy=normcdf(sub);
    for i=randperm(numcity)
        for j=randperm(numcity)
%             Adopt=Adopt*(1-depreciate);
            invest=opt_investment(Demand,Adopt,i,j,Fixedcost,Varcost,Agent,taxrate,period,subsidy,strategy,depreciate);
            Adopt(i,j)=Adopt(i,j)+invest;
            strategy(i,j,1)=strategy(i,j,2);
            strategy(i,j,2)=strategy(i,j,3);
            strategy(i,j,3)=invest;
        end 
    end 

    %price changes
    Varcost=1./Adopt;
    Price=Demand-1./Adopt;
    minprice=min(Price(:));
    if minprice<0
        Price=Price+abs(minprice);
    end
    
    %move agents
    for agent=randperm(numAgents)
        loci=Agent(i).cityi;
        locj=Agent(j).cityj;
        [loc1,loc2]=opt_utility(agent,Price,Agent,taxrate);
        Demand(loci,locj)=Demand(loci,locj)-Agent(agent).weight;
        Agent(agent).cityi=loc1;
        Agent(agent).cityj=loc2;
        Demand(loc1,loc2)=Demand(loc1,loc2)+Agent(agent).weight;
    end 

end 














