% 仿真实验

clear;
clc;

PX0 = [  1,   1,   7,   4,   4,   6,   7,   9,   7,   9,   4,   6]';
PY0 = [  3,   6,   1,   6,   9,   2,   4,   2,   6,   9,   1,   9]';
VX0 = [1.5,  -2, 1.2, 1.5,   0,-2.4,   3, 1.8, 0.8,-0.6, 2.3, 2.5]';
VY0 = [1.5, 2.5, 1.5,-1.5,   3, 1.2,   0, 1.2,-0.4,  -3,-1.2, 2.5]';
PXt(:, 1) = PX0;
PYt(:, 1) = PY0;
VXt(:, 1) = VX0;
VYt(:, 1) = VY0;
UXt(:, 1) = zeros(12,1);
UYt(:, 1) = zeros(12,1);
Vt  = sqrt( (VXt(:,1)).^2 + (VYt(:,1)).^2 );
EXt = zeros(12,1);
EYt = zeros(12,1);

Z0 = [];

A =[0 1 0 0 0 0 0 0 0 0 1 0;
    1 0 0 1 1 0 0 0 0 0 0 0;
    0 0 0 0 0 1 1 1 0 0 0 0;
    0 1 0 0 1 0 1 0 1 0 1 0;
    0 1 0 1 0 0 0 0 0 0 0 1;
    0 0 1 0 0 0 1 0 0 0 1 0;
    0 0 1 1 0 1 0 1 1 0 0 0;
    0 0 1 0 0 0 1 0 0 1 0 0;
    0 0 0 1 0 0 1 0 0 1 0 1;
    0 0 0 0 0 0 0 1 1 0 0 1;
    1 0 0 1 0 1 0 0 0 0 0 0;
    0 0 0 0 1 0 0 0 1 1 0 0;];

D =[2 0 0 0 0 0 0 0 0 0 0 0;
    0 3 0 0 0 0 0 0 0 0 0 0;
    0 0 3 0 0 0 0 0 0 0 0 0;
    0 0 0 5 0 0 0 0 0 0 0 0;
    0 0 0 0 3 0 0 0 0 0 0 0;
    0 0 0 0 0 3 0 0 0 0 0 0;
    0 0 0 0 0 0 5 0 0 0 0 0;
    0 0 0 0 0 0 0 3 0 0 0 0;
    0 0 0 0 0 0 0 0 4 0 0 0;
    0 0 0 0 0 0 0 0 0 3 0 0;
    0 0 0 0 0 0 0 0 0 0 3 0;
    0 0 0 0 0 0 0 0 0 0 0 3;];

L = D - A;

% 时间参数
tbegin = 0;
tfinal = 10;
dT = 0.001;
T(:,1) = 0; 

% 计算次数
times = (tfinal - tbegin) / dT;

for time = 1:1:times
    % 记录时间
    T(:, time+1) = T(:, time) + dT;

    % 记录状态
    lambda=3.3; mu=2.6; alpha=3.8; beta=2.1; kappa=3.2;
    for i = 1:1:length(L)
        PXij = 0;
        PYij = 0;
        VXij = 0;
        VYij = 0;
        UXt(i, time) = 0;
        UYt(i, time) = 0;
        for j = 1:1:length(L)
            if L(i,j)==-1
                % 这里是相邻节点的差值
                pij = sqrt( (PXt(i,time)-PXt(j,time))^2 + (PYt(i,time)-PYt(j,time))^2 );
                
                PXij = PXij + (lambda/(pij^alpha) - mu/(pij^beta)) * ( PXt(i,time)-PXt(j,time) );
                VXij = VXij + kappa * (VXt(i,time)-VXt(j,time));
                
                PYij = PYij + (lambda/(pij^alpha) - mu/(pij^beta)) * ( PYt(i,time)-PYt(j,time) );
                VYij = VYij + kappa * (VYt(i,time)-VYt(j,time));                
                
%                 % 这里是相邻节点的差值
%                 PXij = PXij + ( PXt(i,time)-PXt(j,time) );
%                 VXij = VXij + ( VXt(i,time)-VXt(j,time) );
%                 
%                 PYij = PYij + ( PYt(i,time)-PYt(j,time) );
%                 VYij = VYij + ( VYt(i,time)-VYt(j,time) );

                % 最后得到的控制输入，这里是位置与速度的合成方式，可更改
                UXt(i, time) = UXt(i, time) - ( PXij + VXij );
                UYt(i, time) = UYt(i, time) - ( PYij + VYij );
            end                
        end
    end
    % 迭代过程，一定是加号
    VXt(:, time+1) = VXt(:, time) + dT * UXt(:, time);
    VYt(:, time+1) = VYt(:, time) + dT * UYt(:, time);
    PXt(:, time+1) = PXt(:, time) + dT * VXt(:, time);
    PYt(:, time+1) = PYt(:, time) + dT * VYt(:, time);
    
    Vt (:, time+1) = sqrt( (VXt(:,time+1)).^2 + (VYt(:,time+1)).^2 );
end


subplot(2,3,1)
plot(T(1,:),VXt(1,:),'-', T(1,:),VXt(2,:),':', T(1,:),VXt(3,:),'--', T(1,:),VXt(4,:),'-.',...
     T(1,:),VXt(5,:), T(1,:),VXt(6,:), T(1,:),VXt(7,:), T(1,:),VXt(8,:),...
     T(1,:),VXt(9,:), T(1,:),VXt(10,:), T(1,:),VXt(11,:), T(1,:),VXt(12,:),...
     'linewidth',1)
grid on
% legend('VX_1', 'VX_2', 'VX_3', 'VX_4', 'VX_5', 'VX_6', 'VX_7', 'VX_8', 'VX_9', 'VX_{10}', 'VX_{11}', 'VX_{12}');
title('X axis Speed')

subplot(2,3,2)
plot(T(1,:),PXt(1,:),'-', T(1,:),PXt(2,:),':', T(1,:),PXt(3,:),'--', T(1,:),PXt(4,:),'-.',...
     T(1,:),PXt(5,:), T(1,:),PXt(6,:), T(1,:),PXt(7,:), T(1,:),PXt(8,:),...
     T(1,:),PXt(9,:), T(1,:),PXt(10,:), T(1,:),PXt(11,:), T(1,:),PXt(12,:),...
     'linewidth',1)
grid on
% legend('PX_1', 'PX_2', 'PX_3', 'PX_4', 'PX_5', 'PX_6', 'PX_7', 'PX_8', 'PX_9', 'PX_{10}', 'PX_{11}', 'PX_{12}');
title('X axis Position')

subplot(2,3,4)
plot(T(1,:),VYt(1,:),'-', T(1,:),VYt(2,:),':', T(1,:),VYt(3,:),'--', T(1,:),VYt(4,:),'-.',...
     T(1,:),VYt(5,:), T(1,:),VYt(6,:), T(1,:),VYt(7,:), T(1,:),VYt(8,:),...
     T(1,:),VYt(9,:), T(1,:),VYt(10,:), T(1,:),VYt(11,:), T(1,:),VYt(12,:),...
     'linewidth',1)
grid on
% legend('VY_1', 'VY_2', 'VY_3', 'VY_4', 'VY_5', 'VY_6', 'VY_7', 'VY_8', 'VY_9', 'VY_{10}', 'VY_{11}', 'VY_{12}');
title('Y axis Speed')

subplot(2,3,5)
plot(T(1,:),PYt(1,:),'-', T(1,:),PYt(2,:),':', T(1,:),PYt(3,:),'--', T(1,:),PYt(4,:),'-.',...
     T(1,:),PYt(5,:), T(1,:),PYt(6,:), T(1,:),PYt(7,:), T(1,:),PYt(8,:),...
     T(1,:),PYt(9,:), T(1,:),PYt(10,:), T(1,:),PYt(11,:), T(1,:),PYt(12,:),...
     'linewidth',1)
grid on
% legend('PY_1', 'PY_2', 'PY_3', 'PY_4', 'PY_5', 'PY_6', 'PY_7', 'PY_8', 'PY_9', 'PY_{10}', 'PY_{11}', 'PY_{12}');
title('Y axis Position')

subplot(2,3,3)
plot(T(1,:),Vt(1,:),'-', T(1,:),Vt(2,:),':', T(1,:),Vt(3,:),'--', T(1,:),Vt(4,:),'-.',...
     T(1,:),Vt(5,:), T(1,:),Vt(6,:), T(1,:),Vt(7,:), T(1,:),Vt(8,:),...
     T(1,:),Vt(9,:), T(1,:),Vt(10,:), T(1,:),Vt(11,:), T(1,:),Vt(12,:),...
     'linewidth',1)
grid on
% legend('V_1', 'V_2', 'V_3', 'V_4', 'V_5', 'V_6', 'V_7', 'V_8', 'V_9', 'V_{10}', 'V_{11}', 'V_{12}');
title('Speed')

subplot(2,3,6)
plot3(T(1,:),PXt(1,:),PYt(1,:),'-', T(1,:),PXt(2,:),PYt(2,:),':', T(1,:),PXt(3,:),PYt(3,:),'--', T(1,:),PXt(4,:),PYt(4,:),'-.',...
      T(1,:),PXt(5,:),PYt(5,:), T(1,:),PXt(6,:),PYt(6,:), T(1,:),PXt(7,:),PYt(7,:), T(1,:),PXt(8,:),PYt(8,:),...
      T(1,:),PXt(9,:),PYt(9,:), T(1,:),PXt(10,:),PYt(10,:), T(1,:),PXt(11,:),PYt(11,:), T(1,:),PXt(12,:),PYt(12,:),...
     'linewidth',1)
grid on
% legend('V_1', 'V_2', 'V_3', 'V_4', 'V_5', 'V_6', 'V_7', 'V_8', 'V_9', 'V_{10}', 'V_{11}', 'V_{12}');
title('Position')
xlabel('T');
ylabel('PX');
zlabel('PY');




