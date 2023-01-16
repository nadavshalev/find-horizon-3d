function ang = clacAngle(p)
ang = [atan2(p(:,2), p(:,1)) ...
      asin(p(:,3) ./ sqrt(sum(p.^2,2)))];
end