% chan_reg() - Perform Eyeregression on segmented data.
%
% Usage:
%   >>  EEG = chan_reg( EEG, EyeCh );
% Inputs:
%   EEG     - EEG dataset.
%   EyeCh   - Index of bipolar eye channel or enter two channel indices to create a bipolar channel.
%    
% Outputs:
%   EEG     - EEG dataset.
%
% See also: 
%   POP_EyeReg, EEGLAB 

% Copyright (C) <2006>  <James Desjardins> <Brock University>
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

function EEG = chan_reg(EEG,regChInd,GCCor)


regChInd=str2num(regChInd);

if nargin < 2
	help EyeReg;
	return;
end;	

% Perform eye regression on EEG dataset using EyeCh.

x=zeros(1,length(EEG.data(1,:,1)),length(EEG.data(1,1,:)));
EEG.data=cat(1,EEG.data,x);
EEG.nbchan=EEG.nbchan+1;
EEG.chanlocs(EEG.nbchan).labels='regCh';


chregwbh = waitbar(1/EEG.nbchan,['Regressing channel 1 of ' num2str(EEG.nbchan) '.']);
for i=1:length(EEG.data(1,1,:));
    
    datCh=EEG.data(:,:,i);
    if GCCor
        datChRes=datCh-mean(EEG.data,3);
    end
    
    if length(regChInd)==1;
        regCh=EEG.data(regChInd,:,i);
        if GCCor
            regChRes=regCh-mean(EEG.data(regChInd,:,:),3);
        end
    end
    if length(regChInd)==2;
        regCh=EEG.data(regChInd(1),:,i)-EEG.data(regChInd(2),:,i);
        if GCCor
            regChRes=regCh-mean(EEG.data(regChInd(1),:,:)-EEG.data(regChInd(2),:,:),3);
        end
    end
    
    if ~GCCor
        regChCalc=regCh;
        datChCalc=datCh;
    else
        regChCalc=regChRes;
        datChCalc=datChRes;
    end
    
    for ii=1:length(EEG.data(:,1,1));
        waitbar(ii/EEG.nbchan,chregwbh,['Regressing channel ' num2str(ii) ' of ' num2str(EEG.nbchan) '.']);
        
        X=sum(regChCalc);
        X2=sum(regChCalc.^2);
        N=length(regChCalc);
        Y=sum(datChCalc(ii,:,:));
        Y2=sum(datChCalc(ii,:,:).^2);
        XY=sum(regChCalc.*datChCalc(ii,:,:));
        byx(i)=(XY-(X*Y/N))/(X2-(X*X/N));
        ayx(i)=(Y-(byx(i)*X))/N;
        
        yp=byx(i)*regCh+ayx(i);
        
        TempEEG=datCh(ii,:,:)-yp;
        EEG.data(ii,:,i)=TempEEG;
    end
    EEG.data(length(EEG.data(:,1,1)),:,i)=regChCalc;
end

EEG.nbchan=length(EEG.data(:,1,1));

close(chregwbh);
