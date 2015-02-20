function poweranalysis(varargin)
%% prepare input and output names
if nargin==0 % if function called with no arguments    
    % set first data input
    if ~exist('FirstData','var')
        FirstData='H:\My Documents\MATLAB\matlab_data\beta-C-2_image2.mat';
        fprintf('setting 0.5g big particles image 1 to default: %s\n',FirstData);
    end
    % set second data input
    if ~exist('SecondData','var')
        SecondData = 'H:\My Documents\MATLAB\matlab_data\beta-C-3-image2.mat';
        fprintf('setting 3.5g big particles image 1 to default: %s\n',SecondData);
    end
    % set third data input
    if ~exist('ThirdData','var')
        ThirdData = 'H:\My Documents\MATLAB\matlab_data\beta-C-4-image2.mat';
        fprintf('setting 0.5g small particles image 1 to default: %s\n',ThirdData);
    end
    % set forth data input
    if ~exist('ForthData','var')
        ForthData = 'H:\My Documents\MATLAB\matlab_data\beta-C-5-image2.mat';
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
colour=['r','y','b','g']; % colours for different sample
DataIn=[load(FirstData),load(SecondData),load(ThirdData),load(ForthData)];
%% Calculate energy contains in the signal
for j=1:4
    data = DataIn(j); % 'DaraIn' is a struct the same to 'data'
    D = data.data % get the matrix from the struct
 for p=1:112
     %% filt the signal
     HighPassFilter=MakeHighPassFilter(StopBand,PassBand,FSampling);
     DataInHP=filter(HighPassFilter,D(5000:12000,p));
     %% analysis energy inside the signal
     PowerOfSignalPart1=mean(DataInHP(1:3501).*DataInHP(1:3501));
     PowerOfSignalPart2=mean(DataInHP(3501:7001).*DataInHP(3501:7001));
     total_pow(p) = PowerOfSignalPart1+PowerOfSignalPart2;% total energy iside the signal
     energy_ratio(p)=PowerOfSignalPart2/PowerOfSignalPart1;% energy diffence between two sections  
 end
 %% energy compare figure
     figure(5);
     plot(total_pow,colour(j),'LineWidth',2); xlabel('elements [N]'); ylabel('energy [W]');
     title('energy compare'); grid on; hold on; 
 %% ratio compare figure     
     figure(6);
     plot(energy_ratio,colour(j),'LineWidth',2); xlabel('elements [N]'); ylabel('energy ratio');
     title('energy ratio compare'); grid on; hold on; 
end
%% save the figures
energyCurrentFileName = sprintf('energy %s at position %s',ImageNumber,Position);
ratioCurrentFileName = sprintf('ratio %s at position %s',ImageNumber,Position);

figure(5);
legend('0.5g-big','3.5g-big','0.5-small','3.5g-small');
print('-dpng',energyCurrentFileName);

figure(6);
legend('0.5g-big','3.5g-big','0.5-small','3.5g-small');
print('-dpng',ratioCurrentFileName);


