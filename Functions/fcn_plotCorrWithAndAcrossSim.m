function fcn_plotCorrWithAndAcrossSim(R1,R2,varargin)
flag_do_debug = 1; % Flag to plot the results for debugging
flag_do_plots = 0; % Flag to plot the final results
flag_check_inputs = 1; % Flag to perform input checking

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
end

%% check input arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____                   _       
%  |_   _|                 | |      
%    | |  _ __  _ __  _   _| |_ ___ 
%    | | | '_ \| '_ \| | | | __/ __|
%   _| |_| | | | |_) | |_| | |_\__ \
%  |_____|_| |_| .__/ \__,_|\__|___/
%              | |                  
%              |_| 
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if flag_check_inputs == 1
    % Are there the right number of inputs?
    if nargin < 2 || nargin > 3
        error('Incorrect number of input arguments')
    end   

end

% Does user want to show the plots?
if 3 == nargin
    fig_num = varargin{1};
    figure(fig_num);
    flag_do_plots = 1;
else
    if flag_do_debug
        fig = figure();
        fig_num = fig.Number;
        flag_do_plots = 1;
    end
end

%% Main code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _       
%  |  \/  |     (_)      
%  | \  / | __ _ _ _ __  
%  | |\/| |/ _` | | '_ \ 
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(fig_num);
hold on;
h1 = plot(R1.mean_col(:,(1:end)),'r','LineWidth',2);

for ii = 1:length(R2.R)
h2 = plot(R2.R(:,ii),'k','color',[0.6,0.6,0.6]);
end
h3 = plot(R2.upperBD,'k','LineWidth',2);
plot(R2.lowerBD,'k','LineWidth',2);
h4 = plot(R2.mean_col,'b','LineWidth',2);

cls_SUMOplot.fcn_setFigureFormat;
legend([h1,h2,h3,h4],'Mean of correlation coefficient within simulations', ...
    "Correlation coefficient across simulations", ...
    "99 percentile boundary of correlation coefficient across simulations" ...
    ,"Mean of correlation coefficient across simulations");

xlabel('Adjacent comparison ID');
ylabel('Correlation coefficient');












end