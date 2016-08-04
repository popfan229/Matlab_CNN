function [ durationMS ] = timeDuration( start, stop)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
temp = fix(start)-48;
ff = temp(10)*100+temp(11)*10+temp(12);
ss = (temp(7)*10 + temp(8))*1000;
mm = (temp(4)*10 + temp(5))*60*1000;
hh = (temp(1)*10 + temp(2))*60*60*1000;

totalStart = ff+ss+mm+hh;

temp = fix(stop)-48;
ff = temp(10)*100+temp(11)*10+temp(12);
ss = (temp(7)*10 + temp(8))*1000;
mm = (temp(4)*10 + temp(5))*60*1000;
hh = (temp(1)*10 + temp(2))*60*60*1000;

totalStop = ff+ss+mm+hh;

durationMS = totalStop-totalStart;

end

