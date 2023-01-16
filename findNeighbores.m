function faceNb = findNeighbores(faces)
faceNb = cell(length(faces),1);
for nf=1:length(faces)
    tmpFace = faces{nf};
    nieghbores = [];
    for i=1:length(faces)
        if i~=nf
            itx = intersect(tmpFace,faces{i});
            if length(itx) > 1
                nieghbores = [nieghbores i];
            end
        end
    end
    faceNb{nf} = nieghbores;
end
end