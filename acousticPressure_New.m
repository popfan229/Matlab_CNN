function measdata = acousticPressure(echo, ecg, dataname)
global data;
global ContTime;
global kickNumber1;
global kickNumber2;

global soundUnderCuff;
global soundOutCuff;
        
global secondStart;
global firstStart;       
global handleAudio2;
global handleAudio1;
global cuffPressure;

global id;
global repNum;

global firstKickPressure1;
global secondKickPressure1;
global firstKickPressure2;
global secondKickPressure2;
global firstLocation;
global secondLocation;

global Fs;
global filePath;
global subjectID;
global pathname;

%% Creat the main figure
hMainFigure = figure('Name', 'Sound Generator', ...
    'NumberTitle', 'off', ...
    'Resize', 'on', ...
    'Units', 'pixel',...
    'HandleVisibility', 'callback',...
    'Position', [150 300 1024 568]);

%% Construct components

% 1) Axes 1 component: display imaging data frame-by-frame
hData1Axes = axes(...
    'Parent', hMainFigure,...
    'HandleVisibility', 'callback', ...
    'Units', 'normalized', ...
    'Position', [0.04    0.405    0.711    0.197], ...
    'XLimMode','manual',...
    'XLim', [0, 80], ...
    'NextPlot', 'replacechildren');
% title(hPlotImAxes, sprintf('Image No. :%s', dataname(12:16)));
hData2Axes = axes(...
    'Parent', hMainFigure, ...
    'HandleVisibility', 'callback', ...
    'Units', 'normalized', ...
    'Position', [0.04    0.098    0.711    0.197], ...
    'XLimMode','manual',...
    'XLim', [0, 80], ...
    'XTick', 0:10:80);

% 2)text box
tickFirstStart = uicontrol(hMainFigure, ...
    'Style', 'edit', ...?% can changed text
    'HandleVisibility', 'callback', ...
    'Units', 'normalized',...
    'Position', [0.18    0.839    0.106    0.069], ...
    'String', 0);
tickFirstSBP = uicontrol(hMainFigure, ...
    'Style', 'edit', ...?% can changed text
    'HandleVisibility', 'callback', ...
    'Units', 'normalized',...
    'Position', [0.36    0.839    0.106    0.069], ...
    'String', 0);
tickFirstDBP = uicontrol(hMainFigure, ...
    'Style', 'edit', ...?% can changed text
    'HandleVisibility', 'callback', ...
    'Units', 'normalized',...
    'Position', [0.54    0.839    0.106    0.069], ...
    'String', 0);

showFile = uicontrol(hMainFigure, ...
    'Style', 'edit', ...?% can changed text
    'HandleVisibility', 'callback', ...
    'Units', 'normalized',...
    'Position', [0.72    0.839    0.106    0.069], ...
    'String', 0);

tickSecondStart = uicontrol(hMainFigure, ...
    'Style', 'edit', ...?% can changed text
    'HandleVisibility', 'callback', ...
    'Units', 'normalized',...
    'Position', [0.18    0.7    0.106    0.069], ...
    'String', 0);
tickSecondSBP = uicontrol(hMainFigure, ...
    'Style', 'edit', ...?% can changed text
    'HandleVisibility', 'callback', ...
    'Units', 'normalized',...
    'Position', [0.36    0.7    0.106    0.069], ...
    'String', 0);
tickSecondDBP = uicontrol(hMainFigure, ...
    'Style', 'edit', ...?% can changed text
    'HandleVisibility', 'callback', ...
    'Units', 'normalized',...
    'Position', [0.54    0.7    0.106    0.069], ...
    'String', 0);

% 4)push button
hBeatNumEdit = uicontrol(hMainFigure, ...
    'Style', 'pushbutton', ...?% can changed text
    'HandleVisibility', 'callback', ...
    'Units', 'normalized',...
    'Position', [0.039    0.755    0.068    0.153], ...
    'String', 'Load', ...
    'Callback', @load);
hBeatNumEdit = uicontrol(hMainFigure, ...
    'Style', 'pushbutton', ...?% can changed text
    'HandleVisibility', 'callback', ...
    'Units', 'normalized',...
    'Position', [0.769    0.422    0.068    0.153], ...
    'String', 'PLAY', ...
    'Callback', @play_first);
hBeatNumEdit = uicontrol(hMainFigure, ...
    'Style', 'pushbutton', ...?% can changed text
    'HandleVisibility', 'callback', ...
    'Units', 'normalized',...
    'Position', [0.871    0.428    0.068    0.153], ...
    'String', 'STORE', ...
    'Callback', @store_first);
hBeatNumEdit = uicontrol(hMainFigure, ...
    'Style', 'pushbutton', ...?% can changed text
    'HandleVisibility', 'callback', ...
    'Units', 'normalized',...
    'Position', [0.773    0.115    0.068    0.153], ...
    'String', 'PLAY', ...
    'Callback', @play_second);
hBeatNumEdit = uicontrol(hMainFigure, ...
    'Style', 'pushbutton', ...?% can changed text
    'HandleVisibility', 'callback', ...
    'Units', 'normalized',...
    'Position', [0.874    0.121    0.068    0.153], ...
    'String', 'STORE', ...
    'Callback', @store_second);

% % 1.1) data menu components callback functions
    function load(hObject, eventdata)

        % load file
        clc
        clear all
        
        kickNumber1 = 0;
        kickNumber2 = 0;
        Fs = 2000;

        [filename, pathname] = uigetfile('*.csv', 'Pick a csv file');
        path = [pathname filename];
        data = csvread(path);
        filePath = pathname;
           
        id = str2num(filename(1:end-3));

        cuffPressure      = data(:,1);     % cuff pressure        
        soundUnderCuff    = data(:,2);     % microphone
        soundOutCuff      = data(:,3);     % brath
                
        %----- process cuffPressure
        cuffPressure     = (cuffPressure-1)*100;
        [v_T_Ft tRange] = SegmentOP(cuffPressure, 2000,cuffPressure);

        cuffFit = cuffPressure(tRange);
        cuffFitAva = cuffFit(v_T_Ft);     
        Xi = 0:1:length(cuffFit)-1;
        cuffInterp = interp1(v_T_Ft,cuffFitAva,Xi,'linear');
        cuffPressure = cuffInterp;
  
        %----- process data range
        soundUnderCuff = soundUnderCuff(tRange);
        soundOutCuff = soundOutCuff(tRange);
%         cuffPressure = cuffPressure(tRange);

        %-----------------

        
        %-----------------
        
        % display the data in figure          
        t = [1/2000:1/2000:length(soundUnderCuff)/2000]; % Fs = 2000Hz
        time = length(soundUnderCuff)/2000;
        plot(hData1Axes,t,soundUnderCuff);  
        plot(hData2Axes,t,soundOutCuff);  
        xlim(hData1Axes,[0 time]);
        xlim(hData2Axes,[0 time]);
        set(showFile, 'String',filename);
        set(tickFirstDBP, 'String',num2str(0));
        set(tickFirstSBP, 'String',num2str(0));
        set(tickSecondDBP, 'String',num2str(0));
        set(tickSecondSBP, 'String',num2str(0));
         
    end

    function play_first(hObject, eventdata)
        kickNumber1 = 0;
         
        fs = 2000;
        handleAudio1 = audioplayer(soundUnderCuff, fs); 
        play(handleAudio1);               
    end

    function play_second(hObject, eventdata)

        kickNumber2 = 0;
                     
        fs = 2000;
        handleAudio2 = audioplayer(soundOutCuff, fs); 
%         stop(handleAudio1);
        play(handleAudio2);
    end

    function store_first(hObject, eventdata)
        kickNumber1 = kickNumber1+1 ;  
    
        if kickNumber1 == 1
            info = get(handleAudio1, 'CurrentSample');  %get currentSample playing
            firstKickPressure1 = cuffPressure(info); 
            set(tickFirstSBP, 'String',num2str(firstKickPressure1));
            firstLocation = info;         
            set(hData1Axes,'NextPlot','add')
            plot(hData1Axes,[info/Fs info/Fs],[2.5 -2.5],'r');
        end
        
        if kickNumber1 == 2
            info = get(handleAudio1, 'CurrentSample');  %get currentSample playing
            secondKickPressure1 = cuffPressure(info); 
            set(tickFirstDBP, 'String',num2str(secondKickPressure1));
            secondLocation = info; 
            result = [firstKickPressure1,secondKickPressure1, firstLocation, secondLocation];
            
            set(hData1Axes,'NextPlot','add')
            plot(hData1Axes,[info/Fs info/Fs],[2.5 -2.5],'r');
            xlswrite('..\BPresult\ResultIn.xls'... % sound in cuff
                , result, ['C' num2str(id+2) ':F' num2str(id+2)]);
        end
        
    end

    function store_second(hObject, eventdata)
        kickNumber2 = kickNumber2+1 ;
        
        if kickNumber2 == 1

            info = get(handleAudio2, 'CurrentSample');  %get currentSample playing
            firstKickPressure2 = cuffPressure(info); 
            firstLocation = info;
            set(tickSecondSBP, 'String',num2str(firstKickPressure2));
 
            set(hData2Axes,'NextPlot','add')
            plot(hData2Axes,[info/Fs info/Fs],[2.5 -2.5],'r');
        end
        
        if kickNumber2 == 2

            info = get(handleAudio2, 'CurrentSample');  %get currentSample playing
            secondKickPressure2 = cuffPressure(info);
            secondLocation = info; 
            set(tickSecondDBP, 'String',num2str(secondKickPressure2));
            result = [firstKickPressure2, secondKickPressure2, firstLocation, secondLocation];
 
            set(hData2Axes,'NextPlot','add')
            plot(hData2Axes,[info/Fs info/Fs],[2.5 -2.5],'r');
                        
            xlswrite('..\BPresult\ResultOut.xls'... % sound in cuff
                , result, ['C' num2str(id+2) ':F' num2str(id+2)]);           
        end

    end





end