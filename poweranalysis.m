function poweranalysis(varargin)
%% prepare input and output names
if nargin==0 % if function called with no arguments    
    % set first data input
    if ~exist('FirstData','var')
        FirstData='H:\My Documents\MATLAB\matlab_data\beta-A-2_image1.mat';
        fprintf('setting 0.5g big particles image 1 to default: %s\n',FirstData);
    end
    % set second data input
    if ~exist('SecondData','var')
        SecondData = 'H:\My Documents\MATLAB\matlab_data\beta-A-3-image1.mat';
        fprintf('setting 3.5g big particles image 1 to default: %s\n',SecondData);
    end
    % set third data input
    if ~exist('ThirdData','var')
        ThirdData = 'H:\My Documents\MATLAB\matlab_data\beta-A-4-image1.mat';
        fprintf('setting 0.5g small particles image 1 to default: %s\n',ThirdData);
    end
    % set forth data input
    if ~exist('ForthData','var')
        ForthData = 'H:\My Documents\MATLAB\matlab_data\beta-A-5-image1.mat';
        fprintf('setting 3.5g small particles image 1 to default: %s\n',ForthData);
    end
    if ~exist('ImageNumber','var')
        ImageNumber = '1';
        fprintf('setting image number 1 to default: %s\n',ImageNumber);
    end
    if ~exist('Position','var')
        Position = 'A';
        fprintf('setting image number A to default: %s\n',Position);
    end
elseif nargin==6
    % get samples data from arguments
    FirstData = varargin{1};
    SecondData = varargin{2};
    ThirdData = varargin{3};
    ForthData = varargin{4};
    ImageNumber = varargin{5};
    Position = varargin{6};
else
    error('0 or 6 arguments needed');
end
%% Highpass filter paramerters prepare
FSampling=100e6; 
PassBand=100e3;   
StopBand=70e3;
%% Data analysis parmerters prepare
freq_expand=64;
colour=['r','y','b','g']; % colours for different sample
DataIn=[load(FirstData),load(SecondData),load(ThirdData),load(ForthData)];
%% Calculate energy contains in the signal
    for j=1:4
    data=DataIn(j);
    D=data.data
 for p=1:112
     %% filt the signal
     HighPassFilter=MakeHighPassFilter(StopBand,PassBand,FSampling);
     DataInHP=filter(HighPassFilter,D(5000:12000,p));
     %% analysis energy inside the signal
     F = abs(fft(DataInHP,length(DataInHP)*freq_expand));
     powfirst = F(1:floor(end/2)).*conj(F(1:floor(end/2)));
     firsthalf_pow = sum(powfirst);
     powsecond = F(floor(end/2)+1:floor(end)).*conj(F(floor(end/2)+1:floor(end)));
     secondhalf_pow = sum(powsecond);
     
     total_pow(p) = firsthalf_pow+secondhalf_pow;% total energy iside the signal
     energy_ratio(p)=secondhalf_pow/firsthalf_pow;% energy diffence between two sections
     
    
 end
     figure(1);
     a=plot(total_pow,colour(j),'LineWidth',2); xlabel('elements [N]'); ylabel('energy [W]');
     title('energy compare'); grid on; hold on; 
     
     figure(2);
     b=plot(energy_ratio,colour(j),'LineWidth',2); xlabel('elements [N]'); ylabel('energy ratio');
     title('energy ratio compare'); grid on; hold on; 
end
energyCurrentFileName = sprintf('energy %s at position %s',ImageNumber,Position);
ratioCurrentFileName = sprintf('ratio %s at position %s',ImageNumber,Position);
figure(1);
legend('0.5g-big','3.5g-big','0.5-small','3.5g-small');
print('-dpng',energyCurrentFileName);

figure(2);
legend('0.5g-big','3.5g-big','0.5-small','3.5g-small');
print('-dpng',ratioCurrentFileName);


