function [maxi,maxj]= opt_utility(a,Price,Agent,taxrate)

coor=zeros(1,4);

sz=size(Price,1);
i=Agent(a).cityi;
j=Agent(a).cityj;
k=Agent(a).sight;

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
        
maxutil=-inf;
maxi=0;
maxj=0;
for p=coor(2):coor(1)
    for q=coor(4):coor(3)
        price=Price(p,q);
        inc=taxrate*Agent(a).income;
        b=Agent(a).weight;
        util=exp(b*log(b)+(1-b)*log(1-b)+log(inc)-b*log(price));
        if util>maxutil
            maxutil=util;
            maxi=p;
            maxj=q;
        end 
    end
end 


end 

            