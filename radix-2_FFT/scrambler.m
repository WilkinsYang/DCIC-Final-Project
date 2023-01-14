%% scrambler module
function sequence=scrambler(x,stage)
temp=zeros(1,length(x));
sequence=zeros(1,length(x));
if(stage==1)
    sequence=x;
else
    temp(1:1:length(x)/2)=x(1:2:end);
    temp((length(x)/2)+1:1:end)=x(2:2:end);
    sequence(1:1:length(x)/2)=scrambler(temp(1:1:length(x)/2),stage-1);
    sequence((length(x)/2)+1:1:end)=scrambler(temp((length(x)/2)+1:1:end),stage-1);
end
end