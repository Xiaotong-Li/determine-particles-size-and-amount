function meanpower(varargin)
%% prepare input and output names
if nargin==0 % if function called with no arguments    
    % set first data input
    if ~exist('FirstData','var')
        FirstData='D:\2015-01-29\matlab\L-sp-0.501.mat';
        fprintf('setting 0.5g big particles image 1 to default: %s\n',FirstData);
    end
    % set second data input
    if ~exist('SecondData','var')
        SecondData = 'D:\2015-01-29\matlab\L-sp-1.001.mat';
        fprintf('setting 3.5g big particles image 1 to default: %s\n',SecondData);
    end
    % set third data input
    if ~exist('ThirdData','var')
        ThirdData = 'D:\2015-01-29\matlab\L-sp-1.501.mat';
        fprintf('setting 0.5g small particles image 1 to default: %s\n',ThirdData);
    end
    % set forth data input
    if ~exist('ForthData','var')
        ForthData = 'D:\2015-01-29\matlab\L-sp-2.001.mat';
        fprintf('setting 3.5g small particles image 1 to default: %s\n',ForthData);
    end
    if ~exist('FifthData','var')
        FifthData = 'D:\2015-01-29\matlab\L-sp-2.501.mat';
        fprintf('setting 3.5g small particles image 1 to default: %s\n',FifthData);
    end
     if ~exist('SixthData','var')
        SixthData = 'D:\2015-01-29\matlab\L-sp-3.001.mat';
        fprintf('setting 0.5g small particles image 1 to default: %s\n',SixthData);
    end
    % set forth data input
    if ~exist('SeventhData','var')
        SeventhData = 'D:\2015-01-29\matlab\L-sp-0.502.mat';
        fprintf('setting 3.5g small particles image 1 to default: %s\n',SeventhData);
    end
    if ~exist('EighthData','var')
        EighthData = 'D:\2015-01-29\matlab\L-sp-0.503.mat';
        fprintf('setting 3.5g small particles image 1 to default: %s\n',EighthData);
    end
    if ~exist('Amount','var')
        Amount = '0.5g small';
        fprintf('setting image number 1 to default: %s\n',Amount);
    end
    if ~exist('Position','var')
        Position = 'A';
        fprintf('setting image number A to default: %s\n',Position);
    end
elseif nargin==10
    % get samples data from arguments
    FirstData = varargin{1};
    SecondData = varargin{2};
    ThirdData = varargin{3};
    ForthData = varargin{4};
    FifthData = varargin{5};
    SixthData = varargin{6};
    SeventhData = varargin{7};
    EighthData = varargin{8};
    Amount = varargin{9};
    Position = varargin{10};
else
    error('0 or 7 arguments needed');
end
RefData = load('D:\2015-01-29\matlab\L-001.mat');
%% Highpass filter paramerters prepare
FSampling=100e6; 
PassBand=100e3;   
StopBand=70e3;
%% Data analysis parmerters prepare
colour=['r','y','b','g','k','c','m','-.r*']; % colours for different sample
DataIn=[RefData,load(FirstData),load(SecondData),load(ThirdData),load(ForthData),load(FifthData),load(SixthData),load(SeventhData),load(EighthData)];
%% define figures name
energyCurrentFileName = sprintf('energyeach %s at position %s',Amount,Position);
ratioCurrentFileName = sprintf('ratio %s at position %s',Amount,Position);
TpowerCurrentFileName = sprintf('powerall %s at position %s',Amount,Position);
%% Calculate energy contains in the signal
for j=1:9
    data = DataIn(j); % 'DaraIn' is a struct the same to 'data'
    D = data.data % get the matrix from the struct
 for p=1:112
     %% filt the signal
     HighPassFilter=MakeHighPassFilter(StopBand,PassBand,FSampling);
     DataInHP=filter(HighPassFilter,D(5000:12000,p));
     %% analysis energy inside the signal
     PowerOfSignalPart1=mean(DataInHP(1:3501).*DataInHP(1:3501));
     PowerOfSignalPart2=mean(DataInHP(3501:7001).*DataInHP(3501:7001));
     Tpower=0;
     atten=0;
     total_pow(p) = PowerOfSignalPart1+PowerOfSignalPart2;% total energy iside the signal
     energy_ratio(p)=PowerOfSignalPart2/PowerOfSignalPart1;% energy diffence between two sections  
     Tpower=Tpower+total_pow(p);
     if j==1
         ref_total_pow = total_pow;
     end
     
     atten_ratio(p)=total_pow(p)./ref_total_pow(p);
     atten=atten+atten_ratio(p);
 end
     %TP(j)=Tpower;
     AT(j)=atten;
 %% energy compare figure
     %figure(1);
     %plot(total_pow,colour(j),'LineWidth',2); xlabel('elements [N]'); ylabel('energy [W]');
     %title('energy for each element'); grid on; hold on; 
 %% ratio compare figure     
     %figure(2);
     %plot(energy_ratio,colour(j),'LineWidth',2); xlabel('elements [N]'); ylabel('energy ratio');
     %title('energy ratio compare'); grid on; hold on; 
 %% ratio compare figure     
     %figure(3);
     %stem(TP,'LineWidth',2); xlabel('image number [N]'); ylabel('power [W]');
     %title('Power in all elements'); grid on; hold on;
 %% compare to water
     figure(2);
     plot(atten_ratio,colour(j),'LineWidth',2); xlabel('elements [N]'); ylabel('ratio [W]');
     title('energy for each element compared to water'); grid on; hold on; 
     figure(3);
     stem(AT,'LineWidth',2); xlabel('elements [N]'); ylabel('ratio [W]');
     title('energy for each element compared to water'); grid on; hold on; 
end
%% save the figures

figure(1);
legend('image 1','image 2','image 3','image 4','image 5','image 6','image 7','image 8');
print('-dpng',energyCurrentFileName);

figure(2);
legend('image 1','image 2','image 3','image 4','image 5','image 6','image 7','image 8');
print('-dpng',ratioCurrentFileName);

figure(3);
print('-dpng',TpowerCurrentFileName);


