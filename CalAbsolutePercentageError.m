function [apeVect,MAPE]=CalAbsolutePercentageError(actual,forecasted)
% Validate sizes of actual and forecasted
% variables must have the same size
if size(actual)~= size(forecasted)
    msgStr='Sizes Are Not Compatible:\nActual size and forecast size must have the same size\n\tactual: %dx%d ,\n\tforecast: %dx%d';
    msg=MException("MyComponent:noSuchVariable",sprintf(msgStr,size(actual),size(forecasted)));
    throw(msg)
end
% APE stands for Absolute Percentage Error calculate for each i
% APE(i)= (abs(actual(i)-forecasted(i))/actual(i))*100
forecasted=floor(forecasted);
for i=1:size(actual,1)
    apeVect(i,1)=abs(((actual(i,1)-forecasted(i,1))/actual(i,1)))*100;
end
% MAPE stands for Mean Absolute Percentage Error calculate for all resultes
% MAPE = 1/N*sum(APE(i)), Where N is the apeVect size
for i=1:size(apeVect,1)
    MAPE=sum(apeVect);
    MAPE=MAPE/size(apeVect,1);
end
end