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
global removeSample;

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
        
        id = (str2num(filename(4))-1)*3 + str2num(filename(1));
        subjectID = str2num([pathname(87) pathname(88) pathname(89)]);



        cuffPressure      = data(:,1);     % cuff pressure
        
        soundUnderCuff    = data(:,2);     % microphone
        soundOutCuff      = data(:,3);     % brath
        
        removeSample = 25*2000; % remove 25s
        

        
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
%         cutTime = 14.5 * 2000;
%         endCutTime = 7.8*2000;
%         soundUnderCuff(1:cutTime) = 0;
%         soundUnderCuff(end-endCutTime:end)=0;
%     
%         soundOutCuff(1:cutTime) = 0;
%         soundOutCuff(end-endCutTime:end)=0;
%         
%         wavwrite(soundUnderCuff,2000,'test.wav');
        
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
        
        close(2);
        
        figure(2)
        plot(t,cuffFit);
        hold on
        plot(t,cuffPressure,'r');
        plot(t,soundUnderCuff+105,'k');
        plot(t,soundOutCuff+95,'r');
        
        for n = 38.6*2000 : 42*2000
            if (soundUnderCuff(n)> 0.1)
                soundUnderCuff(n) = soundUnderCuff(n)*0.4;
            elseif (soundUnderCuff(n)< -0.1)
                soundUnderCuff(n) = soundUnderCuff(n)*0.4;
            end
        end
        
        dt = 16.5*2000:42*2000;
        t = [1/2000:1/2000:length(dt)/2000];
        figure(3)
        subplot(311)
        plot(t,cuffFit(dt),'k');
        ylabel('Cuff pressure (mmHg)');
        xlim([0 26.5]);
        hold off
        subplot(312)
        plot(t,soundUnderCuff(dt),'k');
        ylabel('Amplitude of korotkoff sound');
        xlim([0 26.5]);
        subplot(313)
        plot(t,soundOutCuff(dt),'k');
        ylabel('Amplitude of korotkoff sound');
        xlim([0 26.5]);
        
        %------------------------------

        hold off   
    end

    function play_first(hObject, eventdata)
        figure(2)
        hold on
        SBPINt = 21.5;
        SBPOUTt = 21.35;
        DBPINt = 39.22;
        DBPOUTt = 36.61;
        plot([SBPINt SBPINt],[150 40],'r');
        plot([SBPOUTt SBPOUTt],[150 40],'k');
        plot([DBPINt DBPINt],[150 40],'k');
        plot([DBPOUTt DBPOUTt],[150 40],'r');
        hold off           
    end

    function play_second(hObject, eventdata)

        kickNumber2 = 0;
        
        secondStart=datestr(now, 'HH:MM:SS:FFF');
        set(tickSecondStart, 'String',secondStart);
               
        fs = 2000;
        handleAudio2 = audioplayer(soundOutCuff, fs); 
%         stop(handleAudio1);
        play(handleAudio2);
           
    end

    function store_first(hObject, eventdata)
        kickNumber1 = kickNumber1+1 ;  
    
        if kickNumber1 == 1
            str=datestr(now, 'HH:MM:SS:FFF');
            duration = timeDuration(firstStart, str);%%%%%%%%%%%%%%%%%
            firstKickPressure1 = cuffPressure(duration*2); 
            set(tickFirstSBP, 'String',num2str(firstKickPressure1));

            figure(2)
            hold on
            plot([duration*2/Fs duration*2/Fs],[150 40],'r');
        end
        
        if kickNumber1 == 2
            str=datestr(now, 'HH:MM:SS:FFF');
            duration = timeDuration(firstStart, str);%%%%%%%%%%%%%%%%%
            secondKickPressure1 = cuffPressure(duration*2); 
            set(tickFirstDBP, 'String',num2str(secondKickPressure1));
            
            result = [firstKickPressure1,secondKickPressure1];
            xlswrite(['Z:\Fan Pan\2013-04 Effect of position on BP\Data Analysis\2013-04 Effect of position on BP\Individual results\' 'Result-'... 
               [pathname(87) pathname(88) pathname(89)] '.xls'], result, ['C' num2str(id+2) ':D' num2str(id+2)]);
           
            figure(2)
            hold on
            plot([duration*2/Fs duration*2/Fs],[150 40],'r');
        end
        
    end

    function store_second(hObject, eventdata)
        kickNumber2 = kickNumber2+1 ;
        
        if kickNumber2 == 1
            str=datestr(now, 'HH:MM:SS:FFF');
            duration = timeDuration(secondStart, str);%%%%%%%%%%%%%%%%%
            firstKickPressure2 = cuffPressure(duration*2); 
            set(tickSecondSBP, 'String',num2str(firstKickPressure2));
            figure(2)
            hold on
            plot([duration*2/Fs duration*2/Fs],[150 40],'k');
        end
        
        if kickNumber2 == 2
            str=datestr(now, 'HH:MM:SS:FFF');
            duration = timeDuration(secondStart, str);%%%%%%%%%%%%%%%%%
            secondKickPressure2 = cuffPressure(duration*2); 
            set(tickSecondDBP, 'String',num2str(secondKickPressure2));
 
            result = [firstKickPressure2,secondKickPressure2];
            xlswrite(['Z:\Fan Pan\2013-04 Effect of position on BP\Data Analysis\2013-04 Effect of position on BP\Individual results\' 'Result-'... 
               [pathname(87) pathname(88) pathname(89)] '.xls'], result, ['E' num2str(id+2) ':F' num2str(id+2)]);

            figure(2)
            hold on
            plot([duration*2/Fs duration*2/Fs],[150 40],'k');
            
        end

    end





end