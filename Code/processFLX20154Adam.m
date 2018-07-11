

function [sitedataH]=processFLX20154Adam(fn)
%imports FLUXNET data at any timestep based on filename(fn), where fn is
%typically a cell string of data under a folder.  Example: fn=fuf(['/Users/kdw223/Google Drive/Research/NZ_Method/2015FLUXDATA']);
csvimport(char(fn), 'columns', {'TIMESTAMP','TA_F','LE_F_MDS','H_F_MDS','GPP_DT_VUT_REF', 'SW_IN_F', 'LW_IN_F', });
% time, temperature(C), latent heat, sensible heat, NEE, quality flag for
% gap-filling, respiration, goo, incoming sunlight, preciptiation
%any number of variables can be added or removed, just reference the column
%header in the .csv
data=ans;
w=num2str(data(:, 1)); %creating time strings/arrays
yr=str2num(w(:, 1:4));
month=str2num(w(:, 5:6));
day=str2num(w(:, 7:8));

EF=(data(:, 3)./(data(:, 3)+data(:, 4))); %evaporative fraction is a metric for water availability which is highly relevant to the biosphere.  
%Using something like VPD will limit how many sites you can look at, so I
%used this instead, am happy to send relevant papers
sitedataH=data(:, [1 2 5 8 7 6]); %cleaning up data so now it is [ time temp nee gpp r qFlag]
sitedataH=[sitedataH EF data(:, 9) month day yr data(:, 10)]; %adding time components
Tann=nanmean(sitedataH(:, 2)); %annual mean temperature

idx=sitedataH(:, 7)<-1;%-9999 means missing data in fluxnet/ameri-flux, so the following is just some filtering to remove missing/bad data
sitedataH=sitedataH(~idx, :);
idx=sitedataH(:, 7)>1;
sitedataH=sitedataH(~idx, :);
idx=any(sitedataH==-9999, 2);
sitedataH=sitedataH(~idx, :);
idx=sitedataH(:, 6)==0;
sitedataH=sitedataH(~idx, :);
idx=~isnan(sitedataH(:, 1));
sitedataH=sitedataH(idx, :);

end