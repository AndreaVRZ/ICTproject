%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------------------------FIRST APPROACH------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%In this first approach all data set is used!
%PAY ATTENTION: in order to use this script put it in the CONTSID folder!!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clear all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('ident_test_T3_P2A1_LAST.mat')
Ts=0.02;
data=iddata(q,u,Ts,'InterSample','zoh')
figure; 
subplot 211; plot(t,data.u); grid; xlabel('t [s]'); ylabel('u'); title('PITCH CONTROL VARIABLE')
subplot 212; plot(t,data.y); grid; xlabel('t [s]'); ylabel('q [deg/s]'); title('MEASURED PITCH ANGULAR VELOCITY')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%DATA PROCESSING AND ANALYSIS ---> removing zero order trend
figure; 
subplot(2,1,1) 
grid; plot(data.u); %original input (PITCH CONTROL VARIABLE) 
hold on;   
U0=detrend(data.u,'constant'); %detrended input
grid; plot(U0,'r'); legend('original data','detrended data'); xlabel('t [s]'); ylabel('u')
hold off; 
subplot(2,1,2) 
grid;plot(data.y); %original output (MEASURED PITCH ANGULAR VELOCITY) 
hold on; 
Y0=detrend(data.y,'constant'); %detrended output
grid; plot(Y0,'r'); xlabel('t [s]'); ylabel('q [deg/s]') 
hold off;

data_detrend=iddata(Y0,U0,Ts,'InterSample','zoh') %detrended data set
%--------------------------------------------------------------------------
%DATA PROCESSING AND ANALYSIS ---> data splitting
id=data_detrend(1:2817) %identification data
figure; plot(id); grid

cv=data_detrend(2818:5634) %cross-validation data
figure; plot(cv); grid
 
v=data_detrend(5635:8451) %validation data
figure; plot(v); grid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MODEL IDENTIFICATION
M01=tdsrivc(id,[1 1]) %identified model with nz=0 and np=1
e01=cv.y-simc(M01,cv); %prediction error
J(1)=sum(e01'*e01) %performance index

M02=tdsrivc(id,[1 2]) %identified model with nz=0 and np=2
e02=cv.y-simc(M02,cv); %prediction error
J(2)=sum(e02'*e02) %performance index

M03=tdsrivc(id,[1 3]) %identified model with nz=0 and np=3
e03=cv.y-simc(M03,cv); %prediction error
J(3)=sum(e03'*e03) %performance index

M04=tdsrivc(id,[1 4]) %identified model with nz=0 and np=4
e04=cv.y-simc(M04,cv); %prediction error
J(4)=sum(e04'*e04) %performance index

M05=tdsrivc(id,[1 5],'Td',0.059) %identified model with nz=0 and np=5
e05=cv.y-simc(M05,cv); %prediction error
J(5)=sum(e05'*e05) %performance index
%--------------------------------------------------------------------------
M12=tdsrivc(id,[2 2]) %identified model with nz=1 and np=2
e12=cv.y-simc(M12,cv); %prediction error
J(6)=sum(e12'*e12) %performance index

M13=tdsrivc(id,[2 3]) %identified model with nz=1 and np=3
e13=cv.y-simc(M13,cv); %prediction error
J(7)=sum(e13'*e13) %performance index

M14=tdsrivc(id,[2 4]) %identified model with nz=1 and np=4
e14=cv.y-simc(M14,cv); %prediction error
J(8)=sum(e14'*e14) %performance index

M15=tdsrivc(id,[2 5],'Td',0.06) %identified model with nz=1 and np=5
e15=cv.y-simc(M15,cv); %prediction error
J(9)=sum(e15'*e15) %performance index
%--------------------------------------------------------------------------
M23=tdsrivc(id,[3 3]) %identified model with nz=2 and np=3
e23=cv.y-simc(M23,cv); %prediction error
J(10)=sum(e23'*e23) %performance index

M24=tdsrivc(id,[3 4],'Td',0.06) %identified model with nz=2 and np=4
e24=cv.y-simc(M24,cv); %prediction error
J(11)=sum(e24'*e24) %performance index

M25=tdsrivc(id,[3 5],'Td',0.06) %identified model with nz=2 and np=5
e25=cv.y-simc(M25,cv); %prediction error
J(12)=sum(e25'*e25) %performance index
%--------------------------------------------------------------------------
M34=tdsrivc(id,[4 4],'Td',0.06) %identified model with nz=3 and np=4
e34=cv.y-simc(M34,cv); %prediction error
J(13)=sum(e34'*e34) %performance index

M35=tdsrivc(id,[4 5],'Td',0.06) %identified model with nz=3 and np=5
e35=cv.y-simc(M35,cv); %prediction error
J(14)=sum(e35'*e35) %performance index
%--------------------------------------------------------------------------
M45=tdsrivc(id,[5 5]) %identified model with nz=4 and np=5
e45=cv.y-simc(M45,cv); %prediction error
J(15)=sum(e45'*e45) %performance index
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CROSS-VALIDATION
%The best performance index is J(8)=6.849*10^4 --> BEST MODEL: M14
%Delay: 0.0623s
%Np=4 - Nz=1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%VALIDATION
figure; comparec(v,M14); grid
%RT2=0.6752
%--------------------------------------------------------------------------
figure
vect_t=(1:v.N)'*v.Ts;
shadedplot(vect_t,v.y,simc(M14,v));
xlabel('t [s]')
axis([0 58 -60 50])
