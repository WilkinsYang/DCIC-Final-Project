%% range decision (used to decide the quanization range)
function range=ddr(x)
    if(real(x)==0)
        range=0;
    else
        range=round(log2(max(abs(real(x)))));
    end
end