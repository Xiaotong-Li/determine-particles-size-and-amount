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
elseif nargin==5
    % get samples data from arguments
    FirstData = varargin{1};
    SecondData = varargin{2};
    ThirdData = varargin{3};
    ForthData = varargin{4};
    FifthData = varargin{5};
else
    error('0 or 5 arguments needed');
end
%% Highpass filter paramerters prepare
FSampling=100e6; 
PassBand=100e3;   
StopBand=70e3;
%% Data analysis parmerters prepare
DataIn=[load(FirstData),load(SecondData),load(ThirdData),load(ForthData),load(FifthData)];
%% define figures name
HistogramBins = 7;
d=0;
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
     total_pow(p) = PowerOfSignalPart1+PowerOfSignalPart2;% total energy iside the signal
 end
 %% determine size
 pd=hist(total_pow,HistogramBins);
 if pd(1)>50
    d=d+1;
 end
end


if d>3
    fprintf('The sample is big particles.');
else
    fprintf('The sample is small particels.');
end


