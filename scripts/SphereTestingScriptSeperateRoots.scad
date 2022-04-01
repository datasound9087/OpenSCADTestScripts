$fn = 50;

sphereCubeIntersection(10, 2.5);

module sphereCubeIntersection(radius, intersectAmount)
{
    numberOfSets = 25;
    coords = [for (i = 0; i < (numberOfSets * radius * 2); i = i + radius * 2) i];
    
    for (x = coords)
        genIntersectSphere(x, radius, intersectAmount);


}

module sphereCubeDifference(radius, overlapAmount)
{   
    numberOfSets = 25;
    coords = [for (i = 0; i < (numberOfSets * radius * 2); i = i + radius * 2) i];
    
    for (x = coords)
        genDiffSphere(x, radius, overlapAmount);
}

module sphereCubeUnion(numberPerSide, radius, offset)
{
    coords = [for (i = 0; i < (numberPerSide * (radius + offset) * 2); i = i + (radius * 2) + offset) i];
    for (z = coords)
        for (x = coords)
            for (y = coords)
                sphereAt(x, y, z, radius);
}

module genIntersectSphere(x, radius, intersectAmount)
{
    translate([x, 0, 0])
    {
        intersection()
        {
            sphere(radius);
            translate([intersectAmount, 0, 0])
                sphere(radius);
            translate([-intersectAmount, 0, 0])
                sphere(radius);
            translate([0, intersectAmount, 0])
                sphere(radius);
            translate([0, -intersectAmount, 0])
                sphere(radius);
        }
    }
}

module genDiffSphere(x, radius, overlapAmount)
{
    translate([x, 0, 0])
    {
        difference()
        {
            sphere(radius);
            translate([overlapAmount, 0, 0])
                sphere(radius);
            translate([-overlapAmount, 0, 0])
                sphere(radius);
            translate([0, overlapAmount, 0])
                sphere(radius);
            translate([0, -overlapAmount, 0])
                sphere(radius);
        }
    }
}


module sphereAt(x, y, z, radius)
{
    translate([x, y, z])
        sphere(radius);
}