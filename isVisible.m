function visible = isVisible(pPlane, nPlane, pNew)
p1 = nPlane;
p2 = pNew - pPlane;
visible = p1 * p2' > 0;
end