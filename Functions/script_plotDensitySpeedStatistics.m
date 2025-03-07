% This script takes the edge based results of SUMO simulations, and
% generate speed and density statitics.

% INPUTS: baseline and perturbed edge based results, in xml
% OUTPUTS: statistics plots



% 边际图示例
% marginalPlotDemo
% @author : slandarer
% Zhaoxu Liu / slandarer (2023). marginal plot 
% (https://www.mathworks.com/matlabcentral/fileexchange/123470-marginal-plot), 
% MATLAB Central File Exchange. 检索来源 2023/1/19.
clc;close all;

sim_name = '300m_9x9_twoLane_twoDirection_remove1Lane';
sim_name = 'PortionOfSC';

bl_1sec = readtable(['bl_',sim_name,'_aggregated1_sec.csv']);
bl_05sec = readtable(['bl_',sim_name,'_aggregated0.5_sec.csv']);
bl_02sec =  readtable(['bl_',sim_name,'_aggregated0.2_sec.csv']);
bl_01sec = readtable(['bl_',sim_name,'_aggregated0.1_sec.csv']);
bl_005sec = readtable(['bl_',sim_name,'_aggregated0.05_sec.csv']);
bl_002sec = readtable(['bl_',sim_name,'_aggregated0.02_sec.csv']);

per_1sec = readtable(['per_',sim_name,'_aggregated1_sec.csv']);
per_05sec = readtable(['per_',sim_name,'_aggregated0.5_sec.csv']);
per_02sec = readtable(['per_',sim_name,'_aggregated0.2_sec.csv']);
per_01sec = readtable(['per_',sim_name,'_aggregated0.1_sec.csv']);
per_005sec = readtable(['per_',sim_name,'_aggregated0.05_sec.csv']);
per_002sec = readtable(['per_',sim_name,'_aggregated0.02_sec.csv']);

bl_1secDS = [bl_1sec.edge_density,bl_1sec.edge_speed];
bl_05secDS = [bl_05sec.edge_density,bl_05sec.edge_speed];
bl_02secDS = [bl_02sec.edge_density,bl_02sec.edge_speed];
bl_01secDS = [bl_01sec.edge_density,bl_01sec.edge_speed];
bl_005secDS = [bl_005sec.edge_density,bl_005sec.edge_speed];
bl_002secDS = [bl_002sec.edge_density,bl_002sec.edge_speed];

per_1secDS = [per_1sec.edge_density,per_1sec.edge_speed];
per_05secDS = [per_05sec.edge_density,per_05sec.edge_speed];
per_02secDS = [per_02sec.edge_density,per_02sec.edge_speed];
per_01secDS = [per_01sec.edge_density,per_01sec.edge_speed];
per_005secDS = [per_005sec.edge_density,per_005sec.edge_speed];
per_002secDS = [per_002sec.edge_density,per_002sec.edge_speed];


% 构造三个符合高斯分布的点集
% PntSet1=mvnrnd([2 3],[1 0;0 2],300);
% PntSet2=mvnrnd([6 7],[1 0;0 2],300);
% PntSet3=mvnrnd([14 9],[1 0;0 1],300);
blSet = {bl_1secDS,bl_05secDS,bl_02secDS,bl_01secDS,bl_005secDS,bl_002secDS};
perSet = {per_1secDS,per_05secDS,per_02secDS,per_01secDS,per_005secDS,per_002secDS};

% 将数据放进元胞数组
% PntSet={PntSet1,PntSet2,PntSet3};
% -------------------------------------------------------------------------
% 配色预设(here to change the default color list)

C1=[211 43 43;61 96 137;249 206 61;76 103 86;80 80 80]./255;
C2=[102,173,194;36,59,66;232,69,69;194,148,102;54,43,33]./255;
C1=[60 64 91;223,122,94;130 178 154;244,241,222;240 201 134]./255;
C4=[122,117,119;255,163,25;135,146,73;126,15,4;30,93,134]./255;
C5=[198,199,201;38,74,96;209,80,51;241,174,44;12,13,15]./255;
C6=[235,75,55;77,186,216;58,84,141;2,162,136;245,155,122]./255;
C7=[23,23,23;121,17,36;31,80,91;44,9,75;61,36,42]./255;
C8=[47,62,66;203,129,70;0 64 115;152,58,58;20 72 83]./255;


% colorList=C2;
% colorList = [C2;C4];
% -------------------------------------------------------------------------
% 在这改边缘图及中心图种类
% (here to change the type of marginal plot and main plot)
%    |
%    |
%    |
% \  |  /
%  \ | /
%   \|/
%     
mainType=1;
marginType=4;
%  
%   /|\
%  / | \
% /  |  \
%    |
%    |
%    |
%% =========================================================================
% figure图床及主要区域axes坐标区域创建及基础修饰
% fig=figure('Units','normalized','Position',[.3,.2,.5,.63]);

%% =========================================================================
% 主要区域散点图绘制
switch mainType
    case 1 % 散点图
        
        for i=1:length(blSet)
            [axM,axR,axU] = fcn_setStatisFig(i);
            tPntSet1=blSet{i};
            h1 = scatter(axM,tPntSet1(:,1),tPntSet1(:,2),70,'x','CData',C1(1,:),'MarkerFaceAlpha',.6); 
        
 
            tPntSet2=perSet{i};
            h2 = scatter(axM,tPntSet2(:,1),tPntSet2(:,2),70,'s','CData',C1(2,:),'MarkerFaceAlpha',.6);

            axR.YLim=axM.YLim;
            axU.XLim=axM.XLim;
            
            % BASELINE
%             [f,xi]=ksdensity(tPntSet1(:,1));
%             fill(axU,[xi,xi(1)],[f,0],C1(1,:),...
%                 'FaceAlpha',0.3,'EdgeColor','none');
%             plot(axU,xi,f,'Color',C1(1,:),'LineWidth',1.2);  
%            
%             [f,yi]=ksdensity(tPntSet1(:,2));
%             fill(axR,[f,0],[yi,yi(1)],C1(1,:),...
%                 'FaceAlpha',0.3,'EdgeColor','none');
%             plot(axR,f,yi,'Color',C1(1,:),'LineWidth',1.2);
%             
%             % PERTURBED 
%             [f,xi]=ksdensity(tPntSet2(:,1));
%             fill(axU,[xi,xi(1)],[f,0],C1(2,:),...
%                 'FaceAlpha',0.3,'EdgeColor','none');
%             plot(axU,xi,f,'Color',C1(2,:),'LineWidth',1.2);  
%             
%             [f,yi]=ksdensity(tPntSet2(:,2));
%             fill(axR,[f,0],[yi,yi(1)],C1(2,:),...
%                 'FaceAlpha',0.3,'EdgeColor','none');
%             plot(axR,f,yi,'Color',C1(2,:),'LineWidth',1.2); 
        nbins = 50;

        histogram(axR,tPntSet1(:,2),nbins,'FaceColor',C1(1,:),'Orientation','horizontal',...
            'EdgeColor',[1 1 1]*.1,'FaceAlpha',0.6,'LineWidth',1)
        histogram(axU,tPntSet1(:,1),nbins,'FaceColor',C1(1,:),...
            'EdgeColor',[1 1 1]*.1,'FaceAlpha',0.6,'LineWidth',1)

        histogram(axR,tPntSet2(:,2),nbins,'FaceColor',C1(2,:),'Orientation','horizontal',...
            'EdgeColor',[1 1 1]*.1,'FaceAlpha',0.6,'LineWidth',1)
        histogram(axU,tPntSet2(:,1),nbins,'FaceColor',C1(2,:),...
            'EdgeColor',[1 1 1]*.1,'FaceAlpha',0.6,'LineWidth',1)
     
            
            linkaxes([axM,axR],'y');
            linkaxes([axM,axU],'x');

        legend(axM,[h1,h2],{'Baseline','Perturbed'},'FontSize',14,'Box','off','Location','northeast')


        end
        


%        legendStr{length(PntSet)}='';
%         for i=1:length(PntSet)
%             legendStr{i}=['Class-',num2str(i)];
%         end
%         legend(axM,legendStr,'FontSize',14,'Box','off','Location','best');
    
end

%%
% -------------------------------------------------------------------------
% 边际图绘制




%% ========================================================================
% 所使用到的函数
% 置信椭圆定位函数
function [X,Y]=getEllipse(Mu,Sigma,S,pntNum)
% 置信区间 | 95%:5.991  99%:9.21  90%:4.605
% (X-Mu)*inv(Sigma)*(X-Mu)=S

invSig=inv(Sigma);

[V,D]=eig(invSig);
aa=sqrt(S/D(1));
bb=sqrt(S/D(4));

t=linspace(0,2*pi,pntNum);
XY=V*[aa*cos(t);bb*sin(t)];
X=(XY(1,:)+Mu(1))';
Y=(XY(2,:)+Mu(2))';
end

function [axM,axR,axU] = fcn_setStatisFig(figureNum)
fig=figure(figure);
set(fig,'Units','normalized','Position',[.3,.2,.5,.63]);
axM=axes('Parent',fig);hold on;
set(axM,'Position',[.08,.08,.65,.65],'LineWidth',1.1,'Box','on','TickDir','in',...
    'XMinorTick','on','YMinorTick','on','XGrid','on','YGrid','on','GridLineStyle','--',...
    'FontName','Times New Roman','FontSize',12,'GridAlpha',.09)
axM.XLabel.String='Density[veh/km]';
axM.YLabel.String='Speed[m/s]';
axM.XLabel.FontSize=14;
axM.YLabel.FontSize=14;
% -------------------------------------------------------------------------
% 右侧axes坐标区域创建及基础修饰
axR=axes('Parent',fig);hold on;
set(axR,'Position',[.75,.08,.23,.65],'LineWidth',1.1,'Box','off','TickDir','out',...
    'XMinorTick','on','YMinorTick','on','XGrid','on','YGrid','on','GridLineStyle','--',...
    'FontName','Times New Roman','FontSize',12,'GridAlpha',.09,'TickLength',[.006 .015],'YTickLabel','')
axR.XLabel.String='Speed statistics';
axR.XLabel.FontSize=14;
% -------------------------------------------------------------------------
% 上方axes坐标区域创建及基础修饰
axU=axes('Parent',fig);hold on;
set(axU,'Position',[.08,.76,.65,.2],'LineWidth',1.1,'Box','off','TickDir','out',...
    'XMinorTick','on','YMinorTick','on','XGrid','on','YGrid','on','GridLineStyle','--',...
    'FontName','Times New Roman','FontSize',12,'GridAlpha',.09,'TickLength',[.006 .015],'XTickLabel','')
axU.YLabel.String='Density statistics';
axU.YLabel.FontSize=14;

end




% Zhaoxu Liu / slandarer (2023). marginal plot 
% (https://www.mathworks.com/matlabcentral/fileexchange/123470-marginal-plot), 
% MATLAB Central File Exchange. 检索来源 2023/1/19.