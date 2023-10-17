function result=decide(a,Adopt,Fixedcost,Varcost,Acityi,Acityj,Ainc,Aweight,Asubsidy,Citypop,AAdopt)

fix2=2;
ratio_multiplier=1;

adopted=AAdopt(a);
i=Acityi(a);
j=Acityj(a);
fix=Fixedcost(i,j);
var=Varcost(i,j);
wgt=Aweight(a);
inc=Ainc(a);
s=Asubsidy(a);

ratio=findaround(i,j,Citypop,Adopt);

if adopted==0

    if (inc-fix-var+s)<=0
        utilA=-inf;
    else
    utilA=log(inc-fix-var+s)+wgt+ratio*ratio_multiplier;
    end

    utilN=log(inc)+(1-ratio)*ratio_multiplier;

    if utilA>utilN
        result=1;
    else 
        result=0;
    end
end 

if adopted==1

    if (inc-var+s)<=0
        utilA=-inf;
    else
        utilA=log(inc-var+s)+wgt+ratio*ratio_multiplier;
    end 
    utilN=log(inc-fix2)+(1-ratio)*ratio_multiplier;

    if utilA>utilN
        result=0;
    else
        result=-1;
    end 
end 

end 







