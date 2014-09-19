% 2011 - CUMCM - A : Setting and Scheduling of Traffic and Patrol Police 
%                    Service Platforms : ZoneData.m
% ------------------------------------------------------------------------
% zhou lvwen: zhou.lv.wen@gmail.com
% september 12, 2011
% ------------------------------------------------------------------------

function [node,path,station,DIST] = ZoneData(Zone,v,xlsfile)

switch Zone
    case {'A','a'}; zone = 1;
    case {'B','b'}; zone = 2;
    case {'C','c'}; zone = 3;
    case {'D','d'}; zone = 4;
    case {'E','e'}; zone = 5;
    case {'F','f'}; zone = 6;
end

% read node data
NODE = xlsread(xlsfile,'Intersection Data','A2:E583');
index = find(NODE(:,4) == zone);
for i = 1:length(index)
    j = index(i);
    node(i).lab = NODE(j,1);
    node(i).position = NODE(j,2:3);
    node(i).zone = NODE(j,4);
    node(i).sin = NODE(j,5);
    node(i).adjacent = [];
end

maxnode = max(NODE(index,1));
minnode = min(NODE(index,1));

% read path data
PATH = xlsread(xlsfile,'Routes connecting intersections','A2:B929');
Start = PATH(:,1);
End = PATH(:,2);
index = find(Start >= minnode & End >= minnode & ...
    Start <= maxnode & End <= maxnode);
for i = 1:length(index)
    j = index(i);
    path(i).start = PATH(j,1);
    path(i).end = PATH(j,2);
    S = find(path(i).start==[node.lab]);
    E = find(path(i).end  ==[node.lab]);
    path(i).len = 100 * norm(node(S).position - node(E).position);
    node(S) = setfield(node(S),'adjacent',[node(S).adjacent; E, path(i).len]);
    node(E) = setfield(node(E),'adjacent',[node(E).adjacent; S, path(i).len]);
end

% read police station data
STATION = xlsread(xlsfile,'TPPSP Locations','A2:C81');
index = find(STATION(:,1) == zone);

for i = 1:length(index)
    j = index(i);
    station(i).zone = STATION(j,1);
    station(i).stalab = STATION(j,2);
    station(i).nodlab = STATION(j,3);
    station(i).node=[];
    station(i).nodDist = [];
    station(i).journey = 0;
    station(i).maxtwonodestime = 0;
    station(i).maxStaNodetime = 0;
end

%fprintf(1, 'Done reading node & station & path information/n');

DIST = AllDist(node, path);

for i = 1:length(node)
    [node(i).staDist, j] = min([DIST(node(i).lab,[station.nodlab]).dist]);
    node(i).station = j;
    station(j) = setfield(station(j), 'node', [station(j).node, i]);
    station(j) = setfield(station(j),'nodDist',[station(j).nodDist, node(i).staDist]);
end

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

% ------------------------------------------------------------------------

function DistMatrix = AllDist(node, path)

maxnode = max([node.lab]);
w = zeros(maxnode);
for k = 1:length(path)
    i = path(k).start;
    j = path(k).end;
    if i>j
        w(i,j) = path(k).len;
    else
        w(j,i) = path(k).len;
    end 
end

[i,j,v] = find(w);
DG = sparse(i,j,v,maxnode,maxnode);

for i = [node.lab]
    [dist,path,pred] = graphshortestpath(DG,i,'Directed',0);
    dist = dist; % m
    for j = [node.lab]
        DistMatrix(i, j).dist = dist(j);
        DistMatrix(i, j).path = path(j);
    end
end