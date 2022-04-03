$fn = 32;

// As a rule radius is always specified in powers of 2
// This allows correct sphere scaling in oder to make a correct tree with no overlaps
// This also means that total sphere count is always radius - 1
// eg for a root radius of 512 -> 511 spheres generated

// offset between 0 and 1 (higher values can cause difference levels to overlap)
// Scaled per level so that we always get an even amount of overlap regardless of sphere size
// 1 == 50% overlap
// 0.5 == 25% overlap
// 0.25 == 12.5% overlap
// 0 == 0% overlap (touching)

//genTreeUnion(512, 0.25);
//genTreeDiff(4, 0.25);
genTreeInt2(16, 0.25);

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

module genTreeInt2(radius, offset)
{
    genTreeIntersectionImpl2(radius, 0, 0, 0, offset);
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
        scaledOffset = offset * newRadius;
        if (childDirection == 1)
        {
            child1Z = (z - radius - newRadius) + scaledOffset;
            child2Z = (z + radius + newRadius) - scaledOffset;
            
            union()
            { 
                sphereAt(x, z, radius);
                genTreeUnionImpl(newRadius, x, child1Z, 0
                , offset);
                genTreeUnionImpl(newRadius, x, child2Z, 0, offset);
            }
        }
        else
        {
            child1X = (x - radius - newRadius) + scaledOffset;
            child2X = (x + radius + newRadius) - scaledOffset;
            
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
        scaledOffset = offset * newRadius;
        if (childDirection == 1)
        {
            child1Z = (z - radius - newRadius) + scaledOffset;
            child2Z = (z + radius + newRadius) - scaledOffset;
            
            difference()
            { 
                sphereAt(x, z, radius);
                genTreeDifferenceImpl(newRadius, x, child1Z, 0, offset);
                genTreeDifferenceImpl(newRadius, x, child2Z, 0, offset);
            }
        }
        else
        {
            child1X = (x - radius - newRadius) + scaledOffset;
            child2X = (x + radius + newRadius) - scaledOffset;
            
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
        scaledOffset = offset * newRadius;
        if (childDirection == 1)
        {
            child1Z = (z - radius - newRadius) + scaledOffset;
            child2Z = (z + radius + newRadius) - scaledOffset;
            
            intersection()
            { 
                sphereAt(x, z, radius);
                genTreeIntersectionImpl(newRadius, x, child1Z, 0, offset);
            }
            
            intersection()
            {
                sphereAt(x, z, radius);
                genTreeIntersectionImpl(newRadius, x, child2Z, 0, offset);
            }
        }
        else
        {
            child1X = (x - radius - newRadius) + scaledOffset;
            child2X = (x + radius + newRadius) - scaledOffset;
            
            intersection()
            {
                sphereAt(x, z, radius);
                genTreeIntersectionImpl(newRadius, child1X, z, 1, offset);
            }
            
            intersection()
            {
                sphereAt(x, z, radius);
                genTreeIntersectionImpl(newRadius, child2X, z, 1, offset);
            }
        }
    }
}

module genTreeIntersectionImpl2(radius, x, z, childDirection, offset)
{
    if (radius == 4)
    {
        newRadius = radius / 2;
        scaledOffset = offset * newRadius;
        if (childDirection == 1)
        {
            child1Z = (z - radius - newRadius) + scaledOffset;
            child2Z = (z + radius + newRadius) - scaledOffset;
            
            intersection()
            { 
                sphereAt(x, z, radius);
                sphereAt(x, child1Z, newRadius);
            }
            
            intersection()
            {
                sphereAt(x, z, radius);
                sphereAt(x, child2Z, newRadius);
            }
        }
        else 
        {
            child1X = (x - radius - newRadius) + scaledOffset;
            child2X = (x + radius + newRadius) - scaledOffset;
            
            intersection()
            {
                sphereAt(x, z, radius);
                sphereAt(child1X, z, newRadius);
            }
            
            intersection()
            {
                sphereAt(x, z, radius);
                sphereAt(child2X, z, newRadius);
            }
        }
    }
    else
    {
        newRadius = radius / 2;
        scaledOffset = offset * newRadius;
        if (childDirection == 1)
        {
            child1Z = (z - radius - newRadius) + scaledOffset;
            child2Z = (z + radius + newRadius) - scaledOffset;
            
            union()
            { 
                sphereAt(x, z, radius);
                genTreeIntersectionImpl2(newRadius, x, child1Z, 0, offset);
                genTreeIntersectionImpl2(newRadius, x, child2Z, 0, offset);
            }
        }
        else
        {
            child1X = (x - radius - newRadius) + scaledOffset;
            child2X = (x + radius + newRadius) - scaledOffset;
            
            union()
            {
                sphereAt(x, z, radius);
                genTreeIntersectionImpl2(newRadius, child1X, z, 1, offset);
                genTreeIntersectionImpl2(newRadius, child2X, z, 1, offset);
            }
        }
    }
}

module sphereAt(x, z, radius)
{
    translate([x, 0, z])
        sphere(radius);
}