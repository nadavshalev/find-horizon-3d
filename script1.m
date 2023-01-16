% extract vertices, edges, and faces of soccerball polyhedron
[vertices edges faces] = createSoccerBall;

% prepare figure
figure(1); clf; hold on;
axis equal;
view(3);

% draw the polyhedron as basis
drawPolyhedron(vertices, faces);

%%
x = [0 10 20 0 -10 -20 -10 -10 0];
y = [0 0 10 10 20 10 10 0 -10];

p = polyshape([x',y']);
fg;plot(p)
fg; drawPolygon([x',y'])

%%
% generate random data
rng(42); 
pts = randn([100 2]) * 15 + 50;

% compute derived shapes
centro = centroid(pts); 
bbox = boundingBox(pts);
elli = equivalentEllipse(pts); 
hull = convexHull(pts);

% display shapes
figure; hold on; axis([0 100 0 100]);
drawPoint(pts, 'color', 'k', 'marker', 'o', 'linewidth', 2);
drawPoint(centro, 'color', 'b', 'marker', '*', 'linewidth', 2, 'MarkerSize', 10);
drawBox(bbox, 'color', [0 0 .7], 'linewidth', 2);
drawEllipse(elli, 'color', [.7 0 0], 'linewidth', 2);
drawPolygon(hull, 'color', [0 .7 0], 'linewidth', 2);
legend({'Points', 'Centroid', 'BoundingBox', 'Equiv. Ellipse', 'Conv. Hull'}, 'Location', 'NorthEast');

%%

figure(1); clf;
[v f] = createCube;
drawMesh(v, f);
view(3); axis('vis3d'); axis off;
title('Cube');

%%

v = [1 2 3;
     1 4 6;
     2 1 10;
     5 2 1];
f = [1 2 3;
    2 3 4;
    3 4 1;
    1 3 4];
drawMesh(v,f)

%%
N = 100;
K = 32;
v = rand(N,3);

v4 = v(1:K,:);
c4 = centroid(v4);
f = minConvexHull(v4);

pf = cell2mat(f');
normals = planeNormal(createPlane(v4(pf(:,1),:), v4(pf(:,2),:), v4(pf(:,3),:)));
pz = clacAngle(normals);

kdt = KDTreeSearcher(pz);

% new point
v5 = v(K+1,:);

% check if inside the hull
if isPointInMesh(v5, pf, f)
    disp("point is inside");
    return
end

% calc angle to center
v5diff = c4-v5;
pnew = clacAngle(v5diff);

% find oposit plane
IdxNN = knnsearch(kdt, pnew,'K',2);
planeInd1 = IdxNN(1)

% get 90 deg vect
p90 = rand(1,2);
p90(3) = -(v5diff(1)* p90(1) + v5diff(2)*p90(2))/v5diff(3);
p90ang = clacAngle(p90)

% find 90 plane
IdxNN = knnsearch(kdt, p90ang,'K',2);
planeInd2 = IdxNN(1)

% get 45 deg vect
pminv5diff = clacAngle(-v5diff);
p45ang = mean([p90ang;pminv5diff]);

% find 45 plane
IdxNN = knnsearch(kdt, p45ang,'K',2);
planeInd3 = IdxNN(1)


fg(1);drawMesh(v4,f);
drawFaceNormals(v4,f([planeInd1  ]));
drawFaceNormals(v4,f([ planeInd2 ]));
drawFaceNormals(v4,f([planeInd3]));
drawPoint3d(v5)
% drawEdge3d(seg5)
light; view(3); grid on


%%
% createPlane(v4(pf(planeInd1,1),:), normals(planeInd1))

pPlane = v4(pf(planeInd1,1),:);
nPlane = normals(planeInd1,:);
pNew = v5;

pPlane = [2 2 2];
nPlane = [1 1 0];
pNew = [3 1 3];

p1 = nPlane;
p2 = pNew - pPlane;
visible = p1 * p2'

% visible = isVisible(pPlane, nPlane, pNew)

%%
N = 200;
circPoints = 2*rand(N,3)-1;
points = [circPoints(:,1).*sin(circPoints(:,2)).*cos(circPoints(:,3)) ...
              circPoints(:,1).*sin(circPoints(:,2)).*sin(circPoints(:,3)) ...
              circPoints(:,1).*cos(circPoints(:,2))];
newPoint = 0.99*(2*rand(1,3)-1);


[points edges faces] = createSoccerBall;

% [points faces] = createCube;
% faces = mat2cell(faces,ones(6,1),4);


faces = minConvexHull(points);

fg(1);drawMesh(points,faces);
drawPoint3d(newPoint, 'g*')
light; view(3); grid on;

findHorizon(faces,points,newPoint);




