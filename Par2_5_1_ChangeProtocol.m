% ��ֵ����

clear
clc

% �캽�߲���
ul(:,1) = [5 2]';
vl(:,1) = [0 0]';

% �����߲���
% PXf1(:,1)= 3; PYf1(:,1)=-2; VXf1(:,1)= 0; VYf1(:,1)= 0;
% PXf2(:,1)= 6; PYf2(:,1)= 4; VXf2(:,1)= 0; VYf2(:,1)= 0;
% PXf3(:,1)=-5; PYf3(:,1)=-5; VXf3(:,1)= 0; VYf3(:,1)= 0;
% PXf4(:,1)=-4; PYf4(:,1)= 3; VXf4(:,1)= 0; VYf4(:,1)= 0;

PX = [3  6 -5 -4]';
PY = [-2 4 -5  3]';

VX = [0  0  0  0]';
VY = [0  0  0  0]';

% �������룺d
% ͨ�ž��룺R
d = 0.5;
R = 1.0;

% ʱ�����
tbegin = 0;
tfinal = 60;
dT = 0.01;
T(:,1) = 0; 

% �������
times = (tfinal - tbegin) / dT;

for time = 1:1:times
    % �캽�߹켣
    ul(:,time+1) = [5 5]' -3 * cos( (T(:,time)+20)*pi/40 ) * [1 0]'...
                          -3 * sin( (T(:,time)+20)*pi/40 ) * [0 1]';
    vl(:,time+1) =         3 * sin( (T(:,time)+20)*pi/40 ) * [1 0]'...
                          -3 * cos( (T(:,time)+20)*pi/40 ) * [0 1]';
                      
    % ���ݾ��룬�����Ƿ���ͨ�Ź�ϵ���Ӷ��õ� L ����
    for i=1:4
        Sum1 = 0;
        Par2 = 0;
        Sum3 = 0;
        Sum4 = 0;
        Par5 = 0;
        Sum6 = 0;
        Sum7 = 0;
        Par8 = 0;
        % ��һ��
        for j=1:4
            % �����⵽����֮�����ͨ�Ź�ϵ
            if j~=i && abs(PX(i,time)-PX(j,time)) <= R
                % �����ݶ����ƺ����˻����
                Sum1 = Sum1 + nable_fun(PX(i,time),PX(j,time)) * Vij_Fun(PX(i,time),PX(j,time));
            end
        end
        if abs(PX(i,time)-ul(1,time)) >= R
            Par2 = nable_fun(PX(i,time),ul(1,time)) * Vij_Fun(PX(i,time),ul(1,time));
        end
        % �ڶ���
        for j=1:4
        if j~=i && abs(PX(i,time)-PX(j,time)) <= R
            for k=1:4
            if k~=i && abs(PX(i,time)-PX(k,time)) <= R
                Sum4 = Sum4 + (VX(i,time)-VX(k,time));
            end
            end
            if abs(PX(i,time)-ul(1,time)) >= R
                Par5 = VX(i,time) - vl(1,time);
            end
            Sum3 = Sum3 + sign(Sum4 + Par5);
        end
        end
        % ������
        for j=1:4
        if j~=i && abs(PX(i,time)-PX(j,time)) <= R
            for k=1:4
            if k~=i && abs(PX(i,time)-PX(k,time)) <= R
                Sum7 = Sum7 + (VX(j,time)-VX(k,time));
            end
            end
            if abs(PX(j,time)-ul(1,time)) >= R
                Par8 = VX(j,time) - vl(1,time);
            end
            Sum6 = Sum6 + sign(Sum7 + Par8);
        end
        end

        % �����������
        alpha = 10;
        UX(i,time+1) = -Sum1 - Par2 - alpha*Sum3 + alpha*Sum6;
    end
    
    % ���� X ����
    VX(:,time+1) = VX(:,time) + dT * UX(:,time);
    PX(:,time+1) = PX(:,time) + dT * VX(:,time+1);
    
    % ���� X ����
    
    % ��¼ʱ��
    T(:, time+1) = T(:, time) + dT;
end

% ����ͼ��
% figure(1)
% plot3(T(:,1:times), ul(1,1:times), ul(2,1:times));
% xlabel('T');
% ylabel('X');
% zlabel('Y');

figure(2)
subplot(2,1,1); 
plot(T(:,1:times),PX(1,1:times),...
      T(:,1:times),PX(2,1:times),...
      T(:,1:times),PX(3,1:times),...
      T(:,1:times),PX(4,1:times),...
      T(:,1:times),ul(1,1:times), 'linewidth',1.5); 
legend('f1','f2','f3','f4', 'L');
xlabel('T');
ylabel('X');

title('Position');
grid on

subplot(2,1,2); 
plot(T(:,1:times),VX(1,1:times),...
      T(:,1:times),VX(2,1:times),...
      T(:,1:times),VX(3,1:times),...
      T(:,1:times),VX(4,1:times),'linewidth',1.5); 
legend('f1','f2','f3','f4');
xlabel('T');
ylabel('X');

title('Speed');
grid on

% figure(2)
% subplot(2,1,1); 
% plot3(T(:,1:times),PX(1,1:times),PY(1,1:times),...
%       T(:,1:times),PX(2,1:times),PY(2,1:times),...
%       T(:,1:times),PX(3,1:times),PY(3,1:times),...
%       T(:,1:times),PX(4,1:times),PY(4,1:times),...
%       T(:,1:times),ul(1,1:times),ul(2,1:times), 'linewidth',1.5); 
% legend('f1','f2','f3','f4', 'L');
% xlabel('T');
% ylabel('X');
% zlabel('Y');
% title('Position');
% grid on
% 
% subplot(2,1,2); 
% plot3(T(:,1:times),VX(1,1:times),VY(1,1:times),...
%       T(:,1:times),VX(2,1:times),VY(2,1:times),...
%       T(:,1:times),VX(3,1:times),VY(3,1:times),...
%       T(:,1:times),VX(4,1:times),VY(4,1:times),'linewidth',1.5); 
% legend('f1','f2','f3','f4');
% xlabel('T');
% ylabel('X');
% zlabel('Y');
% title('Speed');
% grid on




% �ƺ���
function Vij = Vij_Fun(xi, xj)
% �������룺d
% ͨ�ž��룺R
d = 0.5;
R = 1.0;
xij = abs(xi - xj);
Vij = (xij - d)^2 * (R - xij) / (xij + (R-xij)/240)...
    + (xij) * (xij - d)^2 / (R-xij+xij/240);
end

% �����ݶȺ���
function nabla_PX = nable_fun(xi, xj)
    nabla_PX = (239*abs(xi - xj)*sign(xi - xj)*(abs(xi - xj) - 1/2)^2)/(240*((239*abs(xi - xj))/240 - 1)^2) - (sign(xi - xj)*(abs(xi - xj) - 1/2)^2)/((239*abs(xi - xj))/240 + 1/240) - (2*abs(xi - xj)*sign(xi - xj)*(abs(xi - xj) - 1/2))/((239*abs(xi - xj))/240 - 1) - (2*sign(xi - xj)*(abs(xi - xj) - 1)*(abs(xi - xj) - 1/2))/((239*abs(xi - xj))/240 + 1/240) - (sign(xi - xj)*(abs(xi - xj) - 1/2)^2)/((239*abs(xi - xj))/240 - 1) + (239*sign(xi - xj)*(abs(xi - xj) - 1)*(abs(xi - xj) - 1/2)^2)/(240*((239*abs(xi - xj))/240 + 1/240)^2);
end














