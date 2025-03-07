function [settlingTime_2pct,settlingTime_5pct] = fcn_settlingTime(t,y)


y_normalized = y - y(1);
info_2pct = stepinfo(y_normalized, t);
settlingTime_2pct = info_2pct.SettlingTime;
info_5pct = stepinfo(y_normalized, t, 'SettlingTimeThreshold', 0.05);
settlingTime_5pct = info_5pct.SettlingTime;


end