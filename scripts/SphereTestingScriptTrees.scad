$fn = 32;

genTreeUnion(512, 0);

module genTreeUnion(radius, offset)
{
    genTreeUnionImpl(radius, 0, 0, 0, offset);
}

module genTreeDiff(radius, offset)
{
    genTreeDifferenceImpl(radius, 0, 0, 0, offset);
}

module genTreeInt(radius, offset)
{
    genTreeIntersectionImpl(radius, 0, 0, 0, offset);
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

module genTreeDifferenceImpl(radius, x, z, childDirection, offset)
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
            
            difference()
            { 
                sphereAt(x, z, radius);
                genTreeDifferenceImpl(newRadius, x, child1Z, 0, offset);
                genTreeDifferenceImpl(newRadius, x, child2Z, 0, offset);
            }
        }
        else
        {
            child1X = (x - radius - newRadius) + offset;
            child2X = (x + radius + newRadius) - offset;
            
            difference()
            {
                sphereAt(x, z, radius);
                genTreeDifferenceImpl(newRadius, child1X, z, 1, offset);
                genTreeDifferenceImpl(newRadius, child2X, z, 1, offset);
            }
        }
    }
}

module genTreeIntersectionImpl(radius, x, z, childDirection, offset)
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
            
            intersection()
            { 
                sphereAt(x, z, radius);
                genTreeIntersectionImpl(newRadius, x, child1Z, 0, offset);
                genTreeIntersectionImpl(newRadius, x, child2Z, 0, offset);
            }
        }
        else
        {
            child1X = (x - radius - newRadius) + offset;
            child2X = (x + radius + newRadius) - offset;
            
            intersection()
            {
                sphereAt(x, z, radius);
                genTreeIntersectionImpl(newRadius, child1X, z, 1, offset);
                genTreeIntersectionImpl(newRadius, child2X, z, 1, offset);
            }
        }
    }
}

module sphereAt(x, z, radius)
{
    translate([x, 0, z])
        sphere(radius);
}