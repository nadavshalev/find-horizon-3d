
N = 700;
shapeType = 1;

% create shape
if shapeType == 1 % random shape
    [points, faces] = createRandomShape(N);
elseif shapeType == 2 % soccer ball
    [points, ~, faces] = createSoccerBall();
elseif shapeType == 3 % cube
    [points, faces] = createCube();
    faces = mat2cell(faces,ones(6,1),4);
end

% find random point outside
isInside = true;
while isInside
    newPoint = 0.9*(2*rand(1,3)-1);
    isInside = isPointInMesh(newPoint, points, faces);
end

% plot shape
fg(1);drawMesh(points,faces);
drawPoint3d(newPoint, 'g*')
light; view(3); grid on;

% run func
findHorizon(faces,points,newPoint);




