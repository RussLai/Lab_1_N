function ratio=findaround(i,j,Citypop,Adopt)

sz=size(Adopt,1);

up=max(i-1,1);
down=min(sz,i+1);
left=max(j-1,1);
right=min(j+1,sz);

aroundA=0;
aroundN=0;
for p=up:down
    for q=left:right
        if p~=i || q~=j
            aroundA=aroundA+Adopt(p,q);
            aroundN=aroundN+Citypop(p,q);
        end
    end 
end 

spotA=Adopt(i,j);
spotN=Citypop(i,j);

ratio=1/3*aroundA/aroundN+2/3*spotA/spotN;



