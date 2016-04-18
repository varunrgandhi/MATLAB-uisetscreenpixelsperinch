function uisetscreenpixelsperinch(varargin)
%UISETSCREENPIXELSPERINCH set the Root Property: 'ScreenPixelsPerInch'
%   UISETSCREENPIXELSPERINCH() launches a GUI that can be used
%   to visualize the effects of changing the root property
%   <a href="matlab: docsearch('ScreenPixelsPerInch')">'ScreenPixelsPerInch'</a> prior to actually setting its value.
%   The 'Text in MATLAB Figures' can be made to appear larger or smaller
%   by changing the value of the ScreenPixelsPerInch root property.
%
%   All the input parameters are optional.
%
%   The dialog box, helps in doing one of the following:
%      To increase the size of text and other items on MATLAB figures, 
%      – Using 120 PPI makes text more readable, and then click OK.
%      To decrease the size of text and other items on MATLAB figures, 
%      – Using 72 PPI will help fit more information on the text, and then click OK.
%      Or use a Custom Setting(recommended values would be 72,96 & 120).
%
%   UISETSCREENPIXELSPERINCH(ScreenPixelsPerInch_Value) will set the
%   value of the root property to the one specified as the input argument.
%
%
%   Example:
%           uisetscreenpixelsperinch()
%           uisetscreenpixelsperinch(120) % Set value to 120
%           uisetscreenpixelsperinch('reset') % Restores system defaults
%
%   See also text, axes, figure, uisetfont, uisetcolor

%   Copyright 1984-2009 The MathWorks, Inc.
%   Written 06/15/2009

error(nargchk(0, 1, nargin,'struct'));


hfig = findall(0,'Name','Set Screen Pixels Per Inch');
if ~isempty(hfig)
    if(nargin ~= 0)
        set(hfig,'visible','off');
    else
        figure(hfig);
    end
else
    Initialize;
    if(nargin == 0)
        figure(findall(0,'Name','Set Screen Pixels Per Inch'));
    end
end

hfig = findall(0,'Name','Set Screen Pixels Per Inch');

handles = getappdata(hfig,'handles');

if (nargin == 1)
    if(strcmpi(varargin{1},'RESET'))
        defaultppi_Callback([],[],handles)
        setppi_Callback(handles.setppi, [], handles)
    else
        set(handles.edit1,'String',varargin{1})
        setppi_Callback(handles.setppi, [], handles)
    end
end

end

function Initialize
% Draw GUI components
bkcol=get(0,'defaultfigurecolor');
figpos=get(0,'DefaultfigurePosition');
original_ppi = get(0,'ScreenPixelsPerInch');

% Create figure
handles.figure1 = figure('Tag','figure1','visible','off','NumberTitle','off','Name','Set Screen Pixels Per Inch','Resize','off', 'color',bkcol, ...
    'IntegerHandle','off','MenuBar','none', 'ToolBar','none','Units', 'pixels','Position',[figpos(1) figpos(2) 545.00 280.00]);

% UICONTROL Style = text and Tag = text1

handles.text1 = uicontrol('style','text' , 'Units', 'pixels', 'Position',[0.00 260.00 520.00 15.00],'backgroundColor',bkcol);
set(handles.text1,'Tag','text1','fontunits','pixels','fontsize',12.0000,'String','To set Screen Pixels Per Inch enter a value in the text box or drag the ruler with your mouse');

% Create axes
handles.ruler = axes('Parent',handles.figure1,'Tag','ruler','tickLength',[0.08 0.04],'YTick',[],'Units','pixels',...
    'Position',[20 220 288 25],'xminorTick','on','FontUnits','pixels', 'FontSize',10,'color',bkcol);

% UICONTROL Style = pushbutton and Tag = cancel

handles.cancel = uicontrol('style','pushbutton' , 'Units', 'pixels', 'Position',[390.00 20.00 60.00 24.00]);
set(handles.cancel,'Tag','cancel','fontunits','pixels','fontsize',12.0000,'String','Cancel','backgroundColor',bkcol);

% UICONTROL Style = pushbutton and Tag = setppi

handles.setppi = uicontrol('style','pushbutton' , 'Units', 'pixels', 'Position',[320.00 20.00 60.00 24.00]);
set(handles.setppi,'Tag','setppi','fontunits','pixels','fontsize',12.0000,'String','OK','backgroundColor',bkcol);

% UICONTROL Style = edit and Tag = edit1

handles.edit1 = uicontrol('style','edit' , 'Units', 'pixels', 'Position',[440.00 220.00 60.00 20.00],'backgroundColor','white');
set(handles.edit1,'Tag','edit1','fontunits','pixels','fontsize',12.0000, ...
    'TooltipString','Value must be numeric between 20 and 500','String',num2str(original_ppi));


% UICONTROL Style = text and Tag = ui06

handles.panel1 = uipanel('Units', 'pixels', 'Position',[20 65 500 120],'backgroundColor',bkcol);
set(handles.panel1,'Tag','panel1','fontunits','pixels','fontsize',12,'Title','Preview Text');

% UICONTROL Style = text and Tag = preview

handles.preview = uicontrol('style','text' , 'Units', 'pixels', 'Position',[5 5 490 90],'Parent',handles.panel1,'backgroundColor',bkcol);
set(handles.preview,'Tag','preview','fontunits','pixels','fontname','default', ...
    'TooltipString','Previews the appearance text in the MATLAB figure windows');
set_preview(original_ppi,handles);

% UICONTROL  Style = popupmenu
handles.rulerunits = uicontrol('Style','popupmenu','Units','Pixels', 'Position',[335 220 80.00 20.00], 'backgroundColor','white', ...
    'fontunits','Pixels','fontsize',12,'String',{'INCH','MM'},'Value',1,'Tooltipstring','Ruler depicts the size of objects(eg., text) in MATLAB figures');

% UICONTROL  Style = help button
handles.helpbutton = uicontrol('style','pushbutton' , 'Units', 'pixels', 'Position',[460.00 20.00 60.00 24.00]);
set(handles.helpbutton,'Tag','helpbutton','fontunits','pixels','fontsize',12.0000,'String','HELP','backgroundColor',bkcol);


% UICONTROL  Style = reset button
handles.defaultppi = uicontrol('style','pushbutton' , 'Units', 'pixels', 'Position',[420.00 185.00 100.00 20.00]);
set(handles.defaultppi,'Tag','defaultppi','fontunits','pixels','fontsize',10.0000,'String','Restore Defaults','backgroundColor',bkcol);


% Define Callbacks

set(handles.cancel,'Callback',{@cancel_Callback,handles});
set(handles.setppi,'Callback',{@setppi_Callback,handles});
set(handles.edit1,'Callback',{@edit1_Callback,handles});
set(handles.text1,'Callback',{@text1_Callback,handles});
set(handles.preview,'Callback',{@preview_Callback,handles});
set(handles.rulerunits,'Callback',{@rulerunits_Callback,handles});
set(handles.helpbutton,'Callback','doc(''uisetscreenpixelsperinch'')');
set(handles.defaultppi,'Callback',{@defaultppi_Callback,handles});

set(handles.figure1,'handlevisibility','off','WindowButtonUpFcn',{@dropObject,handles},'WindowButtonMotionFcn',{@moveObject,handles});
set(handles.ruler,'ButtonDownFcn',{@axisbuttondown,handles});

newlims=[0 288/original_ppi];
set(handles.ruler,'xlim',newlims);
rulerunits_Callback([],[],handles);

setappdata(handles.figure1,'handles',handles);

end



function edit1_Callback(hObject, eventdata, handles)
% User text box callback
user_entry = round(str2double(get(hObject,'string')));
if(checkVal(user_entry,hObject))
    set_preview(user_entry,handles);
    newlims=[0 288/user_entry];
    set(handles.ruler,'xlim',newlims);
    rulerunits_Callback([],[],handles);
end
end

function defaultppi_Callback(hObject,EventData,handles)
% Restore Defaults button
factory=get(0,'Factory');
set(handles.edit1,'string',factory.factoryRootScreenPixelsPerInch);
edit1_Callback(handles.edit1,[], handles);
end

function setppi_Callback(hObject, eventdata, handles)
% OK button callback
user_entry = round(str2double(get(handles.edit1,'string')));

if (checkVal(user_entry,hObject))
    set(0,'screenPixelsPerInch',user_entry);
    
    fprintf('\nTo preserve this setting for future MATLAB sessions,\n')
    disp('add the following in a <a href="matlab:doc startup">startup.m</a> file: ');
    fprintf('set(0,''ScreenPixelsPerInch'',%d);\n',user_entry);
    fprintf('\nRoot property ''ScreenPixelsPerInch'' is now set to: %d\n',user_entry);
    
    close(handles.figure1);
else
    if(strcmpi(get(handles.figure1,'visible'),'off'))
        close(handles.figure1)
    end
    error('MATLAB:uisetscreenpixelperinch:invalidValue','UISCREENPIXELSPERINCH requires a numeric value between 20-500')
end
end

function set_preview(ppi_val,handles)
% Sets the preview text in the preview panel based on the PPI value
font_name= get(handles.preview,'FontName');
str = sprintf('10 point ''%s''  font at %d ''ScreenPixelsPerInch''',font_name,ppi_val);
set(handles.preview,'fontunits' , 'Pixels','fontsize',(10 * ppi_val /72),'string',str);
end

function out=checkVal(user_entry,hObject)
% Checks if user entry is a valid one
if (isnan(user_entry) || user_entry<20 || user_entry>500)
    out = false;
else
    out=true;
end
end

function axisbuttondown(hObject,evt,handles)
% For the Ruler to initialize dragging
setappdata(handles.figure1,'axisset',1);
setappdata(handles.figure1,'prev',get(handles.figure1,'CurrentPoint'));
end

function dropObject(hObject,evt,handles)
% For the Ruler to stop dragging
test=getappdata(handles.figure1,'axisset');
if test == 1
    setappdata(handles.figure1,'axisset',0);
end
end

function moveObject(hObject,Evt,handles)
% For the ruler during the dragging operations
test=getappdata(handles.figure1,'axisset');
prev=getappdata(handles.figure1,'prev');
if test == 1
    curr = get(handles.figure1,'CurrentPoint');
    if (curr(1)>=15 && curr(1)<=300 &&curr(2)>=200 &&curr(2)<=280)
        change = curr(1)-prev(1);
        
        if(abs(change)< 10 )
            limchng=1-(change/prev(1));
            newlims=(get(handles.ruler,'xlim'))*limchng;
            set(handles.ruler,'xlim',newlims);
            rulerunits_Callback([],[],handles);
            new_ppi=round(288/newlims(2));
            if(checkVal(new_ppi,handles.edit1))
                set(handles.edit1,'string',new_ppi);
                edit1_Callback(handles.edit1,[], handles);
            else
                setappdata(handles.figure1,'axisset',0);
                factory=get(0,'Factory');
                set(handles.edit1,'string',factory.factoryRootScreenPixelsPerInch);
                edit1_Callback(handles.edit1,[], handles);
            end
        end
        
        setappdata(handles.figure1,'prev',get(handles.figure1,'CurrentPoint'));
    end
end
end

function rulerunits_Callback(hObject,eventdata,handles)
% pop-up menu callback to change the units diplayed on the ruler x-axis
sel=get(handles.rulerunits,'Value');
a=get(handles.ruler,'XTick');
if(sel==1)
    set(handles.ruler,'XtickLabel',a);
else
    b=a*25.4;
    set(handles.ruler,'XtickLabel',b);
end
end

function cancel_Callback(hObject,eventdata,handles)
% cancel button callback
close(handles.figure1);
end


