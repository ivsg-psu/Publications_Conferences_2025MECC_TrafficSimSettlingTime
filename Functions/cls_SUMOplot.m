% This is a class to generate SUMO plots.
classdef cls_SUMOplot
    % This function generates the following plots:
    % - average velocity VS manhattan distance
    % - average velocity VS radius
    % - vehicle number VS manhattan distance
    % - vehicle number VS radius
    % - variance width VS. vehicle number
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % average velocity VS manhattan distance
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
    end

    methods (Static)
        %% fcn_plotAverageVelocity.m
        function fcn_plotAverageVelocity(Vavg,dimension,figpath,period)
            % dimension: 'radius' or 'manhattanDis'
            st = dbstack; %#ok<*UNRCH>
            fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
            figure();
            % Set figure dimension
            fwidth=800;%
            fheight=800/1.618;%
            fright=100;%
            fbottom=400;%
            set(gcf,'position',[fright,fbottom,fwidth,fheight])
            hold on;
            for ii = 1:length(Vavg.bl.averageVelocityMatrix.(dimension)(:,1)) % since we removed the first and last line to avoid edge data;
                h1 = plot(Vavg.bl.dis.(dimension),Vavg.bl.averageVelocityMatrix.(dimension)(ii,:),'k');
                h1.Color(4) = 0.2;
            end
            h2 = plot(Vavg.bl.dis.(dimension),Vavg.bl.variance.(dimension).avgVelocity.upperBD,'k--','linewidth',2);
            h3 = plot(Vavg.bl.dis.(dimension),Vavg.bl.variance.(dimension).avgVelocity.lowerBD,'k--','linewidth',2);
            h4 = plot(Vavg.bl.dis.(dimension),Vavg.bl.variance.(dimension).avgVelocity.avgVel_each_radius,'k','linewidth',2);
            h5 = plot(Vavg.per.dis.(dimension),Vavg.per.variance.(dimension).avgVelocity.avgVel_each_radius,'r','linewidth',2);
            if strcmp(dimension,'radius')
                xlabel('Euclidian distance to perturbation[m]','interpreter','latex','fontsize',14);
            elseif strcmp(dimension,'manhattanDis')
                xlabel('Manhattan distance to perturbation[m]','interpreter','latex','fontsize',14);
            end
            ylabel('Speed[mps]','interpreter','latex','fontsize',14);
            xlim("auto");
            ylim([6 15]);

            set(gcf,'color','w');
            set(gca, 'FontName', 'Times New Roman', 'FontSize', 14,'linewidth',1.5);
            box on;
            legend([h1,h2,h4,h5],{'Average velocity at different simulation time','95th percentile of average velocity from baseline',...
                'Average velocity of baseline','Average velocity of perturbed'});
            legend([h1,h2,h4,h5],{'Average velocity at different simulation time','95th percentile of average velocity from baseline',...
                'Average velocity of baseline','Average velocity of perturbed'});
            clear h1 h2 h3 h4 h5;
            print(gcf,strcat(figpath,'/avgVelocity_',dimension,'_period',period,'_'),'-dpng');
        end

%% fcn_plotVehicleNumber.m
        function fcn_plotVehicleNumber(Vavg,dimension,figpath,period)
            % SimMode: 'bl','per'
            % dimension: 'radius','manhattanDis'


            st = dbstack; %#ok<*UNRCH>
            fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
            figure();
            fwidth=800;
            fheight=800/1.618;
            fright=100;
            fbottom=400;
            set(gcf,'position',[fright,fbottom,fwidth,fheight])
            hold on;
            for ii = 1:length(Vavg.bl.vehicleNumber.(dimension)(:,1)) % since we removed the first and last line to avoid edge data;
                h1 = plot(Vavg.bl.dis.(dimension),Vavg.bl.vehicleNumber.(dimension)(ii,:),'k');
                h1.Color(4) = 0.2;
            end
            h2 = plot(Vavg.bl.dis.(dimension),Vavg.bl.variance.(dimension).avgVehNumber.upperBD,'k--','linewidth',2);
            h3 = plot(Vavg.bl.dis.(dimension),Vavg.bl.variance.(dimension).avgVehNumber.lowerBD,'k--','linewidth',2);
            h4 = plot(Vavg.bl.dis.(dimension),Vavg.bl.variance.(dimension).avgVehNumber.avgVehNumber,'k','linewidth',2);
            h5 = plot(Vavg.per.dis.(dimension),Vavg.per.variance.(dimension).avgVehNumber.avgVehNumber,'r','linewidth',2);

            if strcmp(dimension,'radius')
                xlabel('Euclidian distance to perturbation[m]','interpreter','latex','fontsize',14);
            elseif strcmp(dimension,'manhattanDis')
                xlabel('Manhattan distance to perturbation[m]','interpreter','latex','fontsize',14);
            end
            ylabel('Vehicle Number','interpreter','latex','fontsize',14);
            xlim("auto");
            ylim([-500 3000]);
            set(gcf,'color','w');
            set(gca, 'FontName', 'Times New Roman', 'FontSize', 14,'linewidth',1.5);
            box on;
            legend([h1,h2,h4,h5],{'Vehicle number of baseline','95th percentile of vehicle number from baseline','Mean vehicle number of baseline',...
                'Mean vehicle number of perturbed'});

            print(gcf,strcat(figpath,'/vehicleNumber_',dimension,'_period',period,'_'),'-dpng');

        end
%% fcn_plotMFD.m
         function fcn_plotMFD(MFD,simMode,figpath,period)
            % This function plots the macroscopic fundamental diagram of a road
            % network

            % INPUTS:
            % MFD: this is a struct that contains the following fields:
            % Rho: density, veh/km
            % Q: flow rate, veh/hr
            % fitojb: the curve fit object of the MFD data points
            % simMode: 'bl' or 'per'
            st = dbstack; %#ok<*UNRCH>
            fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);

            fitfcn = @(x) MFD.fitobj.a*(x^3) + MFD.fitobj.b*(x^2)+MFD.fitobj.c*x;           
            fitcoe.a = string(round(MFD.fitobj.a,2));
            fitcoe.b = string(round(MFD.fitobj.b,2));
            fitcoe.c = string(round(MFD.fitobj.c,2));
            fiteq = strcat(fitcoe.a,'\rho^3','+',fitcoe.b,'\rho^2','+',fitcoe.c,'\rho');

            figure();             
            fwidth=800;
            fheight=800/1.618;
            fright=100;
            fbottom=400;
            set(gcf,'position',[fright,fbottom,fwidth,fheight])
            plot(MFD.Rho,MFD.Q,'ko','linewidth',2);
            box on; 
            hold on;
            fplot(fitfcn,'r','linewidth',2);
            xlim([0 max(MFD.Rho)]);
            set(gcf,'color','w');
            set(gca, 'FontName', 'Times New Roman', 'FontSize', 14,'linewidth',2);
            xlabel('Density[veh/km]');
            ylabel('Flow rate[veh/hr]');
            legend('Network flow',fiteq,'Location','northwest');


            
            print(gcf,strcat(figpath,'/MFD_',simMode,'_period',period,'_'),'-dpng');
         end
%% fcn_plotbothMFD.m

function fcn_plotbothMFD(MFD_bl,MFD_per,figpath,period)
            % This function plots the macroscopic fundamental diagram of a road
            % network

            % INPUTS:
            % MFD: this is a struct that contains the following fields:
            % Rho: density, veh/km
            % Q: flow rate, veh/hr
            % fitojb: the curve fit object of the MFD data points
            % simMode: 'bl' or 'per'
            st = dbstack; %#ok<*UNRCH>
            fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);

            fitfcn_bl = @(x) MFD_bl.fitobj.a*(x^3) + MFD_bl.fitobj.b*(x^2)+MFD_bl.fitobj.c*x;           
            fitcoe_bl.a = string(round(MFD_bl.fitobj.a,2));
            fitcoe_bl.b = string(round(MFD_bl.fitobj.b,2));
            fitcoe_bl.c = string(round(MFD_bl.fitobj.c,2));
            fiteq_bl = strcat(fitcoe_bl.a,'\rho^3','+',fitcoe_bl.b,'\rho^2','+',fitcoe_bl.c,'\rho');
            
            fitfcn_per = @(x) MFD_per.fitobj.a*(x^3) + MFD_per.fitobj.b*(x^2)+MFD_per.fitobj.c*x;           
            fitcoe_per.a = string(round(MFD_per.fitobj.a,2));
            fitcoe_per.b = string(round(MFD_per.fitobj.b,2));
            fitcoe_per.c = string(round(MFD_per.fitobj.c,2));
            fiteq_per = strcat(fitcoe_per.a,'\rho^3','+',fitcoe_per.b,'\rho^2','+',fitcoe_per.c,'\rho');



            figure();             
            fwidth=800;
            fheight=800/1.618;
            fright=100;
            fbottom=400;
            set(gcf,'position',[fright,fbottom,fwidth,fheight])
            h1 = plot(MFD_bl.Rho,MFD_bl.Q,'ko','linewidth',2);
            box on; 
            hold on;
            h2 = plot(MFD_per.Rho,MFD_per.Q,'bo','linewidth',2);
            h3 = fplot(fitfcn_bl,'k','linewidth',2);
            h4 = fplot(fitfcn_per,'b','linewidth',2);

            xlim([0 max(max(MFD_bl.Rho),max(MFD_per.Rho))]);
            set(gcf,'color','w');
            set(gca, 'FontName', 'Times New Roman', 'FontSize', 14,'linewidth',2);
            xlabel('Density[veh/km]');
            ylabel('Flow rate[veh/hr]');
            legend([h1,h2,h3,h4],'Baseline network flow rate','Perturbed network flow rate',...
                fiteq_bl,fiteq_per,'location','northwest');
            
            print(gcf,strcat(figpath,'/MFD_both','_period',period,'_'),'-dpng');
        end
%% plot histogram for t test results
function fcn_plotTTestHist(tTestResult,figpath,period)
% This function plots the histogram of t test results that compare the
% density of edgedata from baseline and perturbed.


for ii = 1:length(tTestResult)
    if isnan(tTestResult{ii}.h)
        disp('Identical density found in a edge from baseline and perturbed')
    end
    hmatrix(ii) = tTestResult{ii}.h;
end

figure();
histogram(hmatrix);
ylabel('Frequency');
xlabel('Test Decision');
cls_SUMOplot.fcn_setFigureFormat;
print(gcf,strcat(figpath,'/ttest','_period',period,'_'),'-dpng');
end

function fcn_setFigureFormat
% Setting figure properties
fwidth=640;%
fheight=350;%
fright=100;%
fbottom=400;%
set(gcf,'position',[fright,fbottom,fwidth,fheight],'color','w');

% Settings properties for axes
% axes_handle = gca;
% set(axes_handle, 'FontName', 'Times New Roman', 'FontSize', 12,'LineWidth',1.5);

ax = gca;
ax.FontSize = 12;
ax.FontName = 'Times New Roman';
ax.LineWidth = 1.5;
ax.Box = 'on';
ax.TickDir = 'out';
ax.XMinorTick = 'on';
ax.YMinorTick = 'on';
ax.XGrid = 'on';
ax.YGrid = 'on';
ax.GridLineStyle = '--';
% Set the figure properties
set(gcf, 'Color', 'w');
set(gca, 'LooseInset', get(gca, 'TightInset'));

% Add labels and title
xlabelhandle = get(gca,'XLabel');
set(xlabelhandle,'FontSize', 12, 'FontWeight', 'bold');
ylabelhandle = get(gca,'YLabel');
set(ylabelhandle,'FontSize', 12, 'FontWeight', 'bold');




end






    end
end



