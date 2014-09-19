% 2011 - CUMCM - A : Setting and Scheduling of Traffic and Patrol Police 
%                    Service Platforms : main.m
% ------------------------------------------------------------------------
% zhou lvwen: zhou.lv.wen@gmail.com
% september 12, 2011
% ------------------------------------------------------------------------

function [node, station, path] = PathGraph(node, station, path, DIST, v)

for i = 1:length(node)
    x(i) = node(i).position(1);
    y(i) = node(i).position(2);
end

color = [0.8*rand(length(station),3)];
for k = 1:length(path)
    i = find(path(k).start == [node.lab]);
    j = find(path(k).end == [node.lab]);
    I = node(i).station;
    J = node(j).station;
    if  I~=J 
        if node(i).staDist > node(j).staDist
            path(k).station = J;
            station(J) = setfield(station(J), 'node', [station(J).node, i]);
        else
            path(k).station = I;
            station(I) = setfield(station(I), 'node', [station(J).node, j]);
        end
    else
        path(k).station = I;
    end
    h = plot([node(i).position(1), node(j).position(1)],...
             [node(i).position(2), node(j).position(2)],'linewidth',4);
    set(h,'color',color(path(k).station,:));
    hold on
end

for i = 1:length(station)
    snlab = station(i).nodlab;
    j = find(snlab==[node.lab]);
    k = find(snlab==[node.lab]);
    plot(x(j),y(k),'or','markersize',8,'linewidth',2)
    
end

for i = 1:length(path)
    j = find(path(i).start==[node.lab]);
    k = find(path(i).end==[node.lab]);
    plot(x([j,k]),y([j,k]),'.k-','markersize',15)
end

axis([min(x)-5,max(x)+5, min(y)-5,max(y)+5])

for i = [station.stalab]
    staNode = station(i).node;
    nodLab = [node(staNode).lab];
    station(i).maxtwonodestime = max([DIST(nodLab,nodLab).dist])/v;
    if length(staNode) > 2
        for j = staNode
            Path = DIST(station(i).nodlab,node(j).lab).path{:};
            if length(Path) >2
               staNode = setdiff(staNode, Path(2:end-1)); 
            end
        end
    end 
    staNode(1) = [];
    station(i).outnode = staNode;
    station(i).outdist = [DIST(station(i).nodlab,[node(staNode).lab]).dist];
    station(i).journey = sum([station(i).outdist]);
    
    if ~isempty([station(i).outdist])
       station(i).maxStaNodetime = max([station(i).outdist])/v;
    end
end
