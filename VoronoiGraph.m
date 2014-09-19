% 2011 - CUMCM - A : Setting and Scheduling of Traffic and Patrol Police 
%                    Service Platforms : VoronoiGraph.m
% ------------------------------------------------------------------------
% zhou lvwen: zhou.lv.wen@gmail.com
% september 12, 2011
% ------------------------------------------------------------------------

function VoronoiGraph(node,station,path)

for i = 1:length(node)
    x(i) = node(i).position(1);
    y(i) = node(i).position(2);
end

voronoi(x,y)
hold on
[v,c] = voronoin([x' y' ; -100, -100; -100, 1000; 1000, -100; 1000,1000]);
color = [0.3+0.7*rand(length(station),3)];

for i = 1:length(c)-4  
    patch(v(c{i},1),v(c{i},2),color(node(i).station,:));
end
axis equal

for i = 1:length(station)
    j = find(station(i).nodlab==[node.lab]);
    k = find(station(i).nodlab==[node.lab]);
    plot(x(j),y(k),'or','markersize',8,'linewidth',2)
end

for i = 1:length(path)
    j = find(path(i).start==[node.lab]);
    k = find(path(i).end==[node.lab]);
    plot(x([j,k]),y([j,k]),'.k-','markersize',15,'linewidth',2)
end
axis([min(x)-5,max(x)+5, min(y)-5,max(y)+5])
