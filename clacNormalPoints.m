function normalPoints = clacNormalPoints(faces, points)
    normalPoints = zeros(length(faces),3);
    for i=1:length(faces)
        tmpFace = faces{i};
        normalPoints(i,:) = planeNormal(createPlane(points(tmpFace,:)));
    end
end