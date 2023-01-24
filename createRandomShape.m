function [points,faces] = createRandomShape(N)
circPoints = 2*rand(N,3)-1;
points = [circPoints(:,1).*sin(2*pi*circPoints(:,2)).*cos(2*pi*circPoints(:,3)) ...
              circPoints(:,1).*sin(2*pi*circPoints(:,2)).*sin(2*pi*circPoints(:,3)) ...
              circPoints(:,1).*cos(2*pi*circPoints(:,2))];
faces = minConvexHull(points);
end