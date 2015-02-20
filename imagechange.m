function imagechange(varargin)
%% prepare input and output names
if nargin==0 % if function called with no arguments    
    % set first data input
    if ~exist('FirstData','var')
        FirstData='H:\My Documents\MATLAB\matlab_data\beta-A-2_image1.mat';
        fprintf('setting 0.5g big particles image 1 to default: %s\n',FirstData);
    end
    % set second data input
    if ~exist('SecondData','var')
        SecondData = 'H:\My Documents\MATLAB\matlab_data\beta-A-2_image2.mat';
        fprintf('setting 3.5g big particles image 1 to default: %s\n',SecondData);
    end
    % set third data input
    if ~exist('ThirdData','var')
        ThirdData = 'H:\My Documents\MATLAB\matlab_data\beta-A-2_image3.mat';
        fprintf('setting 0.5g small particles image 1 to default: %s\n',ThirdData);
    end
    % set forth data input
    if ~exist('ForthData','var')
        ForthData = 'H:\My Documents\MATLAB\matlab_data\beta-A-2_image4.mat';
        fprintf('setting 3.5g small particles image 1 to default: %s\n',ForthData);
    end
    if ~exist('FifthData','var')
        FifthData = 'H:\My Documents\MATLAB\matlab_data\beta-A-2_image5.mat';
        fprintf('setting 3.5g small particles image 1 to default: %s\n',FifthData);
    end
    if ~exist('Amount','var')
        Amount = '0.5g big';
        fprintf('setting image number 1 to default: %s\n',Amount);
    end
    if ~exist('Position','var')
        Position = 'A';
        fprintf('setting image number A to default: %s\n',Position);
    end
elseif nargin==7
    % get samples data from arguments
    FirstData = varargin{1};
    SecondData = varargin{2};
    ThirdData = varargin{3};
    ForthData = varargin{4};
    FifthData = varargin{5};
    Amount = varargin{6};
    Position = varargin{7};
else
    error('0 or 7 arguments needed');
end
%% Highpass filter paramerters prepare
FSampling=100e6; 
PassBand=100e3;   
StopBand=70e3;
%% Data analysis parmerters prepare
colour=['r','y','b','g','k']; % colours for different sample
DataIn=[load(FirstData),load(SecondData),load(ThirdData),load(ForthData),load(FifthData)];
%% define figures name
energyCurrentFileName = sprintf('energyeach %s at position %s.png',Amount,Position);
ratioCurrentFileName = sprintf('ratio %s at position %s.png',Amount,Position);
TpowerCurrentFileName = sprintf('powerall %s at position %s.png',Amount,Position);
HistogramBins = 7;
legendorder = {'image 1','image 2','image 3','image 4','image 5'};
d=0;
e=0;
%% Calculate energy contains in the signal
for j=1:5
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
     total_pow(p) = PowerOfSignalPart1+PowerOfSignalPart2;% total energy iside the signal
     energy_ratio(p)=PowerOfSignalPart2/PowerOfSignalPart1;% energy diffence between two sections  
     Tpower=Tpower+total_pow(p);
 end
     TP(j)=Tpower;
 %% energy compare figure
     figure(1);
     plot(total_pow,colour(j),'LineWidth',2); xlabel('elements [N]'); ylabel('energy [W]');
     title('energy for each element'); grid on; hold on; 
 %% ratio compare figure     
     figure(2);
     plot(energy_ratio,colour(j),'LineWidth',2); xlabel('elements [N]'); ylabel('energy ratio');
     title('energy ratio compare'); grid on; hold on; 
 %% ratio compare figure     
     figure(3);
     stem(TP,'LineWidth',2); xlabel('image number [N]'); ylabel('power [W]');
     title('Power in all elements'); grid on; hold on;
 %% power distribution
     figure(j+3);
     hist(total_pow,5); xlabel('energy for each element [W]'); ylabel('counts [N]');
     title('energy distribution againts elemnets'); legend(legendorder(j));grid on;
 %% determine size
      pd=hist(total_pow,HistogramBins);
      if pd(1)>50
        d=d+1;
      end
 %% power distribution
     figure(j+8);
     hist(energy_ratio,HistogramBins); xlabel('energy for each element [W]'); ylabel('counts [N]');
     title('energy distribution againts elemnets'); legend(legendorder(j));grid on;
 %% determine size
     rd=hist(energy_ratio,HistogramBins);
     if rd(1)>70
        e=e+1;
     end
end
%% save the figures

figure(1);
legend(legendorder);
print('-dpng',energyCurrentFileName);

figure(2);
legend(legendorder);
print('-dpng',ratioCurrentFileName);

figure(3);
print('-dpng',TpowerCurrentFileName);

if d>3
    fprintf('The sample is big particles.');
else
    fprintf('The sample is small particels.');
end

