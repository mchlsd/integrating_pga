for i=0:0.001:1 
    [y,t,x] = lsim(ss(H),u,t,0.0500 ./ss(H).C);
    if (y(1)>0.09 && y(1)<0.11)
        display (i)
    end
end