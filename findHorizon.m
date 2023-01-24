function hotizen = findHorizon(faces, points, newPoint)
% get all neighores (simulate DCEL knolage)
faceNb = findNeighbores(faces);

% get all points in the hull
vertPoints = points(unique([faces{:}]),:);

% check if the new point is inside the hull
if isPointInMesh(newPoint, points, faces)
    disp("point is inside");
    return
end

% find normal vercotrs of the faces (simulate DCEL knolage)
normalVectors = clacNormalPoints(faces, points);
% find angles (latitudes & longitudes)
normalAngles = clacAngle(normalVectors);
% init KD-tree of angles
KDtree = KDTreeSearcher(normalAngles);
% calc center
centroidPoint = mean(vertPoints);


% calc min max of the search
point2center = centroidPoint - newPoint;
maxAngle = clacAngle(point2center);
minAngle = clacAngle(-point2center);

randPoint90Deg = rand(1,2);
randPoint90Deg(3) = -(point2center(1)* randPoint90Deg(1) + point2center(2)*randPoint90Deg(2))/point2center(3);
avAngle = clacAngle(randPoint90Deg);

hotizen = [];
iters = 0;
while isempty(hotizen)
    % get closest normal (search KD-tree)
    IdxNN = knnsearch(KDtree, avAngle,'K',2);
    planeInd = IdxNN(1);
    tmpFace = faces{planeInd};

    % check if pace is visible
    visible = isVisible(points(tmpFace(1),:), normalVectors(planeInd,:), newPoint);
    
%     % plot the noramal
    drawFaceNormals(points,faces(planeInd));
    
    % search with all neighbors
    for nb=faceNb{planeInd}
        tmpFace = faces{nb};
        tmpVis = isVisible(points(tmpFace(1),:), normalVectors(nb,:), newPoint);
        % if exist neighbore with oposit visibility - the horizen is found
        if tmpVis ~= visible
            hotizen = intersect(faces{nb}, faces{planeInd});
        end
    end
    
    % keep searching (binary search)
    if ~visible
        maxAngle = avAngle;
        avAngle = mean([avAngle;minAngle]);
    else
        minAngle = avAngle;
        avAngle = mean([avAngle;maxAngle]);
    end

    if iters > 1e3
        disp("More then 1000 Iters!");
        return;
    end
    iters = iters + 1;
end

% plot the horizon as a segment
edge = createEdge3d(points(hotizen(1),:), points(hotizen(2),:));
drawEdge3d(edge, LineWidth=4)
disp(num2str(iters) + " iterations")
end