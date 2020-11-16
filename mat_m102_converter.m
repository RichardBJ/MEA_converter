
%% Where matlab.mat is the name of your exported Axion file
%% and electrodes are the names of your electrodes
load('matlab.mat');
% This will basically include a structure "x" that has everything in it
% Remember electrodes named by their x y grid, i.e., there is no electrode 1
electrodes={'14','41'};
% or just do all of 'em
% Note, will skip "Ref" electrode
all=true;

%% Now begin

if all == false
    for i=1:length(electrodes)
        do_trode(electrodes(i), x);
    end
else
     for i=1:length(labels(1,:))
        trode=cell2mat(labels(1,i));
        if strcmp(trode,'Ref')
            continue
        else
            do_trode(trode, x);
        end
    end   
end


function do_trode(electrode,x)
    labels=x.Labels(2,:);
    lek = find(contains(labels,electrode));
    si = length(x.AllTimeData)/max(x.AllTimeData);
    data=x.AllVoltages(lek,:)';
    spikes=x.Spikes(lek);
    spikes= double(cell2mat(spikes));
    plot(x.AllTimeData',data);
    hold on
    pks=spikes./spikes;
    pks=pks*max(data);
    spikes=spikes./1e6;
    scatter(spikes, pks,5);
    tp=int64(spikes*si);

    spikechan=zeros(1,length(x.AllTimeData))';

    spikechan(tp)=1;
    master=[x.AllTimeData',data,spikechan];
    hold off
    pause(1);
    %lab=num2str(lek);
    compat=str2double(electrode);
    if compat<10
        filename=['output_0',num2str(compat),'.csv'];
    else
        filename=['output_',num2str(compat),'.csv'];
    end
    disp(['Writing ',filename])
    dlmwrite(filename, master, 'delimiter', ',', 'precision', 9);
    disp(['Apparent success with ',filename])
end


