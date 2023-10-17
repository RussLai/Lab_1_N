function [result,loan1,loan2,loan3,loan4]=decide_strategy(a,Adopt,Fixedcost,Varcost,Acityi,Acityj,Ainc,Aweight,Asubsidy,Citypop,AAdopt,Ar)

beta=1;
r=Ar(a);
fix2=2;
fac=3;

adopted=AAdopt(a);
i=Acityi(a);
j=Acityj(a);
fix=Fixedcost(i,j);
var=Varcost(i,j);
wgt=Aweight(a);
inc=Ainc(a);
s=Asubsidy(a);

ratio=findaround(i,j,Citypop,Adopt);

s1=max(0,10-log(inc)-4*ratio);
s2=0.2*max(0,10-log(inc)-4*ratio);

if adopted==0

 
    loan1=((1-beta)*(inc-var)+beta*(fix-s)+s2)/(1+r+beta);
    loan2=(1-beta)*inc/(1+r+beta);
    loan4=((1-beta)*inc+s1-var-fix)/(1+r+beta);
    loan3=((1-beta)*inc-fix2+beta*(var-s))/(1+r+beta);

    loan1=min((inc-var)/(1+r),loan1);
    loan1=max(0,loan1);
    loan2=min(inc/(1+r),loan2);
    loan2=max(0,loan2);
    loan4=min((inc+s1-var-fix)/(1+r),loan4);
    loan4=max(0,loan4);
    loan3=min((inc-fix2)/(1+r),loan3);
    loan3=max(0,loan3);



    if (inc-fix-var+loan1+s)<=0
        utilA=-inf;
    else
    utilA=log(inc-var-fix+loan1+s)+wgt+ratio*fac + beta*1/(1+r)*(log(inc-(1+r)*loan1-var+s2)+wgt+ratio*fac);
    end

    if inc-var-fix+loan3+s<0
        utilB=-inf;
    else 
        utilB=log(inc-var-fix+loan3+s)+wgt+ratio*fac + beta*1/(1+r)*(log(inc-(1+r)*loan3-fix2)+(1-ratio)*fac);
    end 
  
    utilP=log(inc+loan4)+(1-ratio)*fac + beta*1/(1+r)*(log(inc+s1-var-fix-(1+r)*loan4)+wgt+fac*ratio);
  
    utilN=log(inc+loan2)+(1-ratio)*fac + beta*1/(1+r)*(log(inc-(1+r)*loan2)+(1-ratio)*fac);
   

     if max(utilA,utilB)>max(utilP,utilN)
        result=1;
        if utilA>utilB
            loan2=0;
            loan3=0;
            loan4=0;
        else 
            loan1=0;
            loan2=0;
            loan4=0;
        end 
    else 
        result=0;
        if utilP>utilN
            loan1=0;
            loan2=0;
            loan3=0;
        else 
            loan1=0;
            loan3=0;
            loan4=0;
        end 
    end

end 




if adopted==1

    

    loan1=((1-beta)*(inc-var)-beta*s+s2)/(1+r+beta);
    loan2=((1-beta)*inc+beta*fix2)/(1+r+beta);
    loan4=((1-beta)*inc+beta*fix2-var-fix+s1)/(1+beta+r);
    loan3=((1-beta)*inc+beta*(var-s)-fix2)/(1+beta+r);

    loan1=min((inc-var)/(1+r),loan1);
    loan1=max(0,loan1);
    loan2=min(inc/(1+r),loan2);
    loan2=max(0,loan2);
    loan4=min((inc-var-fix+s1)/(1+r),loan4);
    loan4=max(0,loan4);
    loan3=min((inc-fix2)/(1+r),loan3);
    loan3=max(0,loan3);



    if (inc-var+loan1+s)<=0
        utilA=-inf;
    else
        utilA=log(inc-var+loan1+s)+wgt+ratio*fac + beta*1/(1+r)*(log(inc-(1+r)*loan1-var+s2)+wgt+ratio*fac) ;
    end 

    if inc-var+loan3+s<0
        utilB=-inf;
    else
        utilB=log(inc-var+loan3+s)+wgt+ratio*fac + beta*1/(1+r)*(log(inc-(1+r)*loan3-fix2)+(1-ratio)*fac) + beta*(r/(1+r)^2)*(log(inc)+(1-ratio)*fac);
    end 

    if inc-fix2+loan4<0
        utilP=-inf;
    else 
        utilP=log(inc-fix2+loan4)+(1-ratio)*fac + beta*1/(1+r)*(log(inc-(1+r)*loan4-var-fix+s1)+(1-ratio)*fac) ;
    end 

    if inc-fix2+loan2<0
        utilN=-inf;
    else 
        utilN=log(inc-fix2+loan2)+(1-ratio)*fac + beta*1/(1+r)*(log(inc-(1+r)*loan2)+(1-ratio)*fac);
    end 

    if max(utilA,utilB)>max(utilP,utilN)
        result=0;
        if utilA>utilB
            loan2=0;
            loan3=0;
            loan4=0;
        else 
            loan1=0;
            loan2=0;
            loan4=0;
        end 
    else 
        result=-1;
        if utilP>utilN
            loan1=0;
            loan2=0;
            loan3=0;
        else 
            loan1=0;
            loan3=0;
            loan4=0;
        end 
    end
 
end 

end 








