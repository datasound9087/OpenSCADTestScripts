$fn = 32;

genTree(512, 0);

module genTree(radius, offset)
{
    genTreeUnionImpl(radius, 0, 0, 0, offset);
}

module genTreeUnionImpl(radius, x, z, childDirection, offset)
{
    if (radius == 2)
    {
        sphereAt(x, z, radius);
    }
    else
    {
        newRadius = radius / 2;
        if (childDirection == 1)
        {
            child1Z = (z - radius - newRadius) + offset;
            child2Z = (z + radius + newRadius) - offset;
            
            union()
            { 
                sphereAt(x, z, radius);
                genTreeUnionImpl(newRadius, x, child1Z, 0, offset);
                genTreeUnionImpl(newRadius, x, child2Z, 0, offset);
            }
        }
        else
        {
            child1X = (x - radius - newRadius) + offset;
            child2X = (x + radius + newRadius) - offset;
            
            union()
            {
                sphereAt(x, z, radius);
                genTreeUnionImpl(newRadius, child1X, z, 1, offset);
                genTreeUnionImpl(newRadius, child2X, z, 1, offset);
            }
        }
    }
}

module sphereAt(x, z, radius)
{
    translate([x, 0, z])
        sphere(radius);
}