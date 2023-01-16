newPoint = 0.99*(2*rand(1,3)-1);
[points, edges, faces] = createSoccerBall;
horizon = findHorizon(faces,points,newPoint);