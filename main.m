% 2011 - CUMCM - A : Setting and Scheduling of Traffic and Patrol Police 
%                    Service Platforms : main.m
% ------------------------------------------------------------------------
% zhou lvwen: zhou.lv.wen@gmail.com
% september 12, 2011
% ------------------------------------------------------------------------

Zone = 'A';
v = 60e3/60;   % m/min
timelimit = 3; % min
distlimit = v * timelimit;
xlsfile = './problem/en_cumcm2011B_Appendix_2_Data.xls';
[node,path,station,DIST] = ZoneData(Zone,v,xlsfile);

% plot Voronoi Graph and Path Graph
figure
VoronoiGraph(node,station,path);

figure
[node, station,path] = PathGraph(node, station, path, DIST, v);

% write results to a xls file
xlswrite(strcat(Zone,'.xls'),{'num','station','journey',...
                  'max n-n time','max s-n time'},'sheet1','A1:E1')
xlswrite(strcat(Zone,'.xls'),[station.stalab]','sheet1','A2')
xlswrite(strcat(Zone,'.xls'),[station.nodlab]','sheet1','B2')
xlswrite(strcat(Zone,'.xls'),[station.journey]','sheet1','C2')
xlswrite(strcat(Zone,'.xls'),[station.maxtwonodestime]','sheet1','D2')
xlswrite(strcat(Zone,'.xls'),[station.maxStaNodetime]','sheet1','E2')