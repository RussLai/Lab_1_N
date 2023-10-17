function [Asubsidy,total]=findsubsidy(Acityi,Acityj,Ainc,Adopt,AAdopt,run,stype,budget,Sub_pre,Citypop,Varcost, Fixedcost)

total=0;
if stype<10
    total=budget;
end 
pop=size(Ainc,2);
numcity=size(Adopt,1);
Avginc=zeros(numcity);
Asubsidy=zeros(1,pop);

for i=1:numcity
    for j=1:numcity
        Avginc(i,j)=mean(Ainc(Acityi==i&Acityj==j));
    end 
end 

if stype==-1
    Asubsidy=zeros(1,pop);
    return
end 

%%Type 0: Fixed Budget subsidy
if stype==0  %uniform subsidy to minimum adopter cities (DC)
    Asubsidy=zeros(1,pop);
    minadopt=min(Adopt(:));
    minnum=sum(Adopt(:)==minadopt);
    for i=1:numcity
        for j=1:numcity
            if Adopt(i,j)==minadopt
                Asubsidy(Acityi==i&Acityj==j)=budget/minnum/Citypop(i,j);
            end 
        end 
    end 
    return
end 

if stype==1  %uniform subsidy to minimum adopter cities nonadopters (DC)
    Asubsidy=zeros(1,pop);
    minadopt=min(Adopt(:));
    minnum=sum(Adopt(:)==minadopt);
    for i=1:numcity
        for j=1:numcity
            if Adopt(i,j)==minadopt
                tmp=sum(Acityi==i&Acityj==j&AAdopt==0);
                Asubsidy(Acityi==i&Acityj==j&AAdopt==0)=budget/minnum/tmp;
            end 
        end 
    end 
    return
end 




if stype==2   %uniform subsidy to everyone (C)
    Asubsidy=zeros(1,pop)+budget/pop;
    return
end 


if stype==3 %uniform subsidy to every city (DC)
    Asubsidy=zeros(1,pop);
    for i=1:numcity
        for j=1:numcity
            Asubsidy(Acityi==i&Acityj==j)=budget/(numcity^2)/Citypop(i,j);
        end 
    end 
    return
end 

% 
if stype==4    %uniform subsidy to the poor (C)
    avginc=mean(Ainc);
    numbelow=sum(Ainc<avginc);
    Asubsidy=zeros(1,pop);
    Asubsidy(Ainc<avginc)=budget/numbelow;
    return
end 


% 
if stype==5     %uniform subsidy to the poor with nonadopters threshold (C)
    avginc=mean(Ainc(AAdopt==0));
    numbelow=sum(Ainc<avginc);
    Asubsidy=zeros(1,pop);
    Asubsidy(Ainc<avginc)=budget/numbelow;
    return
end 


% % 
if stype==6     %uniform subsidy to the poor in low adopter cities (C/DC)
    Asubsidy=zeros(1,pop);
    avginc=mean(Ainc(AAdopt==0));
    minadopt=min(Adopt(:));
    minnum=sum(Adopt(:)==minadopt);
    for i=1:numcity
        for j=1:numcity
            if Adopt(i,j)==minadopt
                tmp=sum(Acityi==i&Acityj==j&Ainc<avginc);
                Asubsidy(Acityi==i&Acityj==j&Ainc<avginc)=budget/minnum/tmp;
            end 
        end 
    end 
    return
end

if stype==7 %uniform subsidy to the poor in low adopter cities (DC)
    Asubsidy=zeros(1,pop);
    minadopt=min(Adopt(:));
    minnum=sum(Adopt(:)==minadopt);
    for i=1:numcity
        for j=1:numcity
            if Adopt(i,j)==minadopt
                avginc=mean(Ainc(Acityi==i&Acityj==j&AAdopt==0));
                tmp=sum(Acityi==i&Acityj==j&Ainc<avginc);
                Asubsidy(Acityi==i&Acityj==j&Ainc<avginc)=budget/minnum/tmp;
            end 
        end 
    end 
    return
end 

% 
if stype==8   %uniform subsidy to the poor with high noise, mistargeting
    Aincnoise=zeros(1,pop);
    for i = 1:pop
        Aincnoise(i)=normrnd(Ainc(i),2);
    end 
    avginc=mean(Aincnoise(AAdopt==0));
    numbelow=sum(Aincnoise<avginc);
    Asubsidy=zeros(1,pop);
    Asubsidy(Aincnoise<avginc)=budget/numbelow;
    return
end 


% 
if stype==9    %uniform subsidy with high noise to the poor in low adopter cities (C/DC)
    Aincnoise=zeros(1,pop);
    for i = 1:pop
        Aincnoise(i)=normrnd(Ainc(i),2);
    end
    Asubsidy=zeros(1,pop);
    avgincnoise=mean(Aincnoise(AAdopt==0));
    minadopt=min(Adopt(:));
    minnum=sum(Adopt(:)==minadopt);
    for i=1:numcity
        for j=1:numcity
            if Adopt(i,j)==minadopt
                tmp=sum(Acityi==i&Acityj==j&Ainc<avgincnoise);
                Asubsidy(Acityi==i&Acityj==j&Ainc<avgincnoise)=budget/minnum/tmp;
            end 
        end 
    end 
    return
end 

%%Type 1: Proportional subsidy, lumpsum

frac=0.5; %change
Svar=Fixedcost*frac;

if stype==10 %uniform to everyone (C)
    Asubsidy=zeros(1,pop);
    for p=1:pop
        i=Acityi(p);
        j=Acityj(p);
        Asubsidy(p)=Svar(i,j);
    end 
    total=sum(Asubsidy);
    return
end 

if stype==11 %to poor, (Income C)
    Asubsidy=zeros(1,pop);
    avginc=mean(Ainc);
    for p=1:pop
        i=Acityi(p);
        j=Acityj(p);
        if Ainc(p)<avginc
            Asubsidy(p)=Svar(i,j);
        end 
    end 
    total=sum(Asubsidy);
    return
end 

if stype==12 %to poor, (Income DC)
    Asubsidy=zeros(1,pop);
    for p=1:pop
        i=Acityi(p);
        j=Acityj(p);
        if Ainc(p)<Avginc(i,j)
            Asubsidy(p)=Svar(i,j);
        end 
    end 
    total=sum(Asubsidy);
    return
end 

if stype==13 %to nonadopters
    Asubsidy=zeros(1,pop);
    for p=1:pop
        i=Acityi(p);
        j=Acityj(p);
        if AAdopt(p)==0
            Asubsidy(p)=Svar(i,j);
        end 
    end 
    total=sum(Asubsidy);
    return
end 


if stype==14 %to nonadopters, low inc(C)
    Asubsidy=zeros(1,pop);
    avginc=mean(Ainc);
    for p=1:pop
        i=Acityi(p);
        j=Acityj(p);
        if AAdopt(p)==0 && Ainc(p)<avginc
            Asubsidy(p)=Svar(i,j);
        end 
    end 
    total=sum(Asubsidy);
    return
end 

if stype==15 %to nonadopters, low inc(DC)
    Asubsidy=zeros(1,pop);
    for p=1:pop
        i=Acityi(p);
        j=Acityj(p);
        if AAdopt(p)==0 && Ainc(p)<Avginc(i,j)
            Asubsidy(p)=Svar(i,j);
        end 
    end 
    total=sum(Asubsidy);
    return
end 


%%Type 2: Income Adjusted subsidy, or variable cost discounted

frac=0.3; %change
Svar=Varcost*frac;


if stype==20 %proportional amount to variable cost
    for i=1:numcity
        for j=1:numcity
            Asubsidy(Acityi==i & Acityj==j)=Svar(i,j);
        end 
    end 

    total=sum(Sub_pre(AAdopt==1));
    return
end 

if stype==21 %fixed amount (C)
    Asubsidy=zeros(1,pop);
    Asubsidy=Asubsidy+budget/pop;
   
   total=sum(Sub_pre(AAdopt==1));
end 

if stype==22 %fixed amount (DC)
    s=budget/numcity;
    for i=1:numcity
        for j=1:numcity
            Asubsidy(Acityi==i & Acityj==j)=s/Citypop(i,j);
        end 
    end 
   
   total=sum(Sub_pre(AAdopt==1));
   return
end 


if stype==23 %proportional to income, ie tax exemption/value added
    frac=0.1;
    for i=1:pop
       Asubsidy=Ainc*frac;
    end 

    total=sum(Sub_pre(AAdopt==1));
    return
end 



%%Type 3: Functional subsidy (no strategy)

c=0.2; %change
if stype==30 || stype==50 %separable linear, target, fix
    for p=1:pop
        i=Acityi(p);
        j=Acityj(p);
        inc=Ainc(p);
        ratio=findaround(i,j,Citypop,Adopt);
        tmp=max(0,10-log(inc)-4*ratio); %change
        if AAdopt(p)==0
            Asubsidy(p)=tmp;
        else
            Asubsidy(p)=c*tmp;
        end 
    end 
    total=sum(Asubsidy);
    return
end

if stype==31 %separable linear, no-target, fix
    for p=1:pop
        inc=Ainc(p);
        i=Acityi(p);
        j=Acityj(p);
        ratio=findaround(i,j,Citypop,Adopt);
        tmp=max(0,10-log(inc)-4*ratio);
        Asubsidy(p)=(1+c)/2*tmp;
    end 
    total=sum(Asubsidy);
    return
end

if stype==32 %separable linear, target, fix-cost prop
    for p=1:pop
        inc=Ainc(p);
        i=Acityi(p);
        j=Acityj(p);
        ratio=findaround(i,j,Citypop,Adopt);
        fix=Fixedcost(i,j);
        tmp=max(1,log(inc)+ratio); %change
        if Adopt==0
             Asubsidy(p)=fix*(1/tmp);
        else
            Asubsidy(p)=c*fix*(1/tmp);   
        end 
    end 
    total=sum(Asubsidy);
    return
end


if stype==33 %separable linear, no-target, fix-cost prop
    for p=1:pop
        inc=Ainc(p);
        i=Acityi(p);
        j=Acityj(p);
        ratio=findaround(i,j,Citypop,Adopt);
        fix=Fixedcost(i,j);
        tmp=max(1,log(inc)+ratio);
        Asubsidy(p)=(1+c)/2*fix*(1/tmp);
    end 
    total=sum(Asubsidy);
    return
end


if stype==34 %separable linear, var-cost prop
    for p=1:pop
        inc=Ainc(p);
        i=Acityi(p);
        j=Acityj(p);
        ratio=findaround(i,j,Citypop,Adopt);
        var=Varcost(i,j);
        tmp=max(1,log(inc)+ratio);
        Asubsidy(p)=5*var*(1/tmp);  
    end 
    total=sum(Sub_pre(AAdopt==1));
    return
end


if stype==35 %non-separable, target, fix
    for p=1:pop
        inc=Ainc(p);
        i=Acityi(p);
        j=Acityj(p);
        ratio=findaround(i,j,Citypop,Adopt);
        tmp=max(0,10-10*((log(inc)^0.2)*(ratio^0.8))); %change
        if AAdopt(p)==0
            Asubsidy(p)=tmp;
        else
            Asubsidy(p)=c*tmp;
        end 
    end 
    total=sum(Asubsidy);
    return
end

if stype==35 %non-separable, no target, fix
    for p=1:pop
        inc=Ainc(p);
        i=Acityi(p);
        j=Acityj(p);
        ratio=findaround(i,j,Citypop,Adopt);
        tmp=max(0,10-10*((log(inc)^c)*(ratio^(1-c))));
        Asubsidy(p)=(1+c)/2*tmp;
    end 
    total=sum(Asubsidy);
    return
end

if stype==36 %non-separable, target, fix-cost prop
    for p=1:pop
        inc=Ainc(p);
        i=Acityi(p);
        j=Acityj(p);
        ratio=findaround(i,j,Citypop,Adopt);
        fix=Fixedcost(i,j);
        tmp=max(1,10*((log(inc)^c)*(ratio^(1-c))));
        if Adopt==0
            Asubsidy(p)=fix*(1/tmp);
        else
            Asubsidy(p)=c*fix*(1/tmp);
        end 
    end 
    total=sum(Asubsidy);
    return 
end


if stype==37 %non-separable linear, no-target, fix-cost prop
    for p=1:pop
        inc=Ainc(p);
        i=Acityi(p);
        j=Acityj(p);
        ratio=findaround(i,j,Citypop,Adopt);
        fix=Fixedcost(i,j);
        tmp=max(1,10*((log(inc)^c)*(ratio^(1-c))));
        Asubsidy(p)=(1+c)/2*fix*(1/tmp);
    end 
    total=sum(Asubsidy);
    return
end


if stype==38 %non-separable, var-cost prop
    for p=1:pop
        inc=Ainc(p);
        i=Acityi(p);
        j=Acityj(p);
        ratio=findaround(i,j,Citypop,Adopt);
        var=Varcost(i,j);
        tmp=max(1,10*((log(inc)^c)*(ratio^(1-c))));
        Asubsidy(p)=5*var*(1/tmp);       
    end 
    total=sum(Sub_pre(AAdopt==1));
    return
end



%%Type 4: Run time subsidy
multiplier=1.05; %change
low=40; %change
med=60; %change
high=80; %change
if stype==40 %exp, fix budget, uniform everyone
    rbudget=budget;
    if run>=low && run<med
        rbudget=budget*(multiplier^(run-low));
    end 
    if run>=med && run<high
        rbudget=budget*((2-multiplier)^(run-med));
    end 
    Asubsidy=zeros(1,pop)+rbudget/pop;
    total=sum(Asubsidy);
    return
end 

if stype==41 %exp, fix budget, non-adopters (DC)
    rbudget=budget;
    if run>=low && run<med
        rbudget=budget*(multiplier^(run-low));
    end 
    if run>=med && run<high
        rbudget=budget*((2-multiplier)^(run-med));
    end 
    minadopt=min(Adopt(:));
    minnum=sum(Adopt(:)==minadopt);
    for i=1:numcity
        for j=1:numcity
            if Adopt(i,j)==minadopt
                Asubsidy(Acityi==i&Acityj==j)=rbudget/minnum/Citypop(i,j);
            end 
        end 
    end
     total=sum(Asubsidy);
     return 
end 

if stype==42 %exp, fix budget, non-adopters, poor (DC)
    rbudget=budget;
    if run>=low && run<med
        rbudget=budget*(multiplier^(run-low));
    end   
    if run>=med && run<high
        rbudget=budget*((2-multiplier)^(run-med));
    end 
    avginc=mean(Ainc(AAdopt==0));
    minadopt=min(Adopt(:));
    minnum=sum(Adopt(:)==minadopt);
    for i=1:numcity
        for j=1:numcity
            if Adopt(i,j)==minadopt
                tmp=sum(Acityi==i&Acityj==j&Ainc<avginc);
                Asubsidy(Acityi==i&Acityj==j&Ainc<avginc)=rbudget/minnum/tmp;
            end 
        end 
    end 
     total=sum(Asubsidy);
     return
end

if stype==43 %exp, proportional to fix cost, everyone
    r=1;
    if run>=low && run<=med
        c=1/frac;
        tmp=1-1/(c*(run-(low-1)));
        r=tmp/frac;
    end 
    if run>=med && run<high
        r=0;
    end 

    for p=1:pop
        i=Acityi(p);
        j=Acityj(p);
        Asubsidy(p)=r*Svar(i,j);
    end 
    total=sum(Asubsidy);
    return
end 


if stype==44 %exp, proportional to fix cost, unadopted (DC)
    r=1;
    if run>=low && run<=med
        c=1/frac;
        tmp=1-1/(c*(run-(low-1)));
        r=tmp/frac;
    end 
    if run>=med && run<high
        r=0;
    end 

     for p=1:pop
        i=Acityi(p);
        j=Acityj(p);
        if AAdopt(p)==0
            Asubsidy(p)=r*Svar(i,j);
        end 
    end 
    total=sum(Asubsidy);
    return
end 

if stype==45 %exp, proportional to fix cost, unadopted poor (DC)
    r=1;
    if run>=low && run<=med
        c=1/frac;
        tmp=1-1/(c*(run-(low-1)));
        r=tmp/frac;
    end 
    if run>=med && run<high
        r=0;
    end 

    for p=1:pop
        i=Acityi(p);
        j=Acityj(p);
        if AAdopt(p)==0 && Ainc(p)<Avginc(i,j)
            Asubsidy(p)=r*Svar(i,j);
        end 
    end 
    total=sum(Asubsidy);
    return
end 

if stype==46 %exp, function, fix, everyone (DC)
    r=1;
    if run>=low && run<=med
        r=multiplier^(run-low);
    end 
    if run>=med && run<high
        r=(2-multiplier)^(run-med);
    end 
    for p=1:pop
        inc=Ainc(p);
        i=Acityi(p);
        j=Acityj(p);
        ratio=findaround(i,j,Citypop,Adopt);
        tmp=max(0,10-log(inc)+4*ratio);
        if AAdopt(p)==0
            Asubsidy(p)=r*tmp;
        else
            Asubsidy(p)=r*c*tmp;
        end 
    end 
    total=sum(Asubsidy);
    return 
end 


if stype==47 %exp, function, fix, no target (DC)
    r=1;
    if run>=low && run<=med
        r=multiplier^(run-low);
    end 
    if run>=med && run<high
        r=(2-multiplier)^(run-med);
    end 
   
    for p=1:pop
        inc=Ainc(p);
        i=Acityi(p);
        j=Acityj(p);
        ratio=findaround(i,j,Citypop,Adopt);
        tmp=max(0,10-(log(inc)+4*ratio));
        Asubsidy(p)=r*(1+c)/2*tmp;
    end 
    total=sum(Asubsidy);
    return
end 

if stype==48 %separable linear, target, fix-cost prop
    r=1;  
    if run>=low && run<=med
        q=1/frac;
        tmp=1-1/(q*(run-(low-1)));
        r=tmp/frac;
    end 
    if run>=med && run<high
        r=0;
    end

    for p=1:pop
        inc=Ainc(p);
        i=Acityi(p);
        j=Acityj(p);
        ratio=findaround(i,j,Citypop,Adopt);
        fix=Fixedcost(i,j);
        tmp=max(1,log(inc)+4*ratio);
        if Adopt==0
             Asubsidy(p)=r*fix*(1/tmp);
        else
            Asubsidy(p)=r*c*fix*(1/tmp);   
        end 
    end 
    total=sum(Asubsidy);
    return 
end


if stype==49 %separable linear, no-target, fix-cost prop
    r=1;
    if run>=low && run<=med
        q=1/frac;
        tmp=1-1/(q*(run-(low-1)));
        r=tmp/frac;
    end 
    if run>=med && run<high
        r=0;
    end

    for p=1:pop
        inc=Ainc(p);
        i=Acityi(p);
        j=Acityj(p);
        ratio=findaround(i,j,Citypop,Adopt);
        fix=Fixedcost(i,j);
        tmp=max(1,log(inc)+4*ratio);
        Asubsidy(p)=r*(1+c)/2*fix*(1/tmp);
    end 
    total=sum(Asubsidy);
    return
end


%%Type 5: Functional subsidy (with strategy) 
% % 
%     %revealed preference
% 
%     %revealed preference, mistargeting
% 
%     %revealed preference with asymmetric information

    %Benchmark: uniform subsidy to randomly selected individual