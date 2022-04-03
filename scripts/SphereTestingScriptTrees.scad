$fn = 32;

// As a rule radius is always specified in powers of 2
// This allows correct sphere scaling in oder to make a correct tree with no overlaps
// This also means that total sphere count is always radius - 1
// eg for a root radius of 512 -> 511 spheres generated

// overlap between 0 and 1 (higher values can cause difference levels to overlap)
// Scaled per level so that we always get an even amount of overlap regardless of sphere size
// 1 == 50% overlap
// 0.5 == 25% overlap
// 0.25 == 12.5% overlap
// 0 == 0% overlap (touching)

//genTreeUnion(512, 0.25);
//genTreeDiff(4, 0.25);
genTreeInt2(16, 0.25);

module genTreeUnion(radius, overlap)
{
    genTreeUnionImpl(radius, 0, 0, 0, overlap);
}

module genTreeDiff(radius, overlap)
{
    genTreeDifferenceImpl(radius, 0, 0, 0, overlap);
}

module genTreeInt(radius, overlap)
{
    genTreeIntersectionImpl(radius, 0, 0, 0, overlap);
}

module genTreeInt2(radius, overlap)
{
    genTreeIntersectionImpl2(radius, 0, 0, 0, overlap);
}

module genTreeUnionImpl(radius, x, z, childDirection, overlap)
{
    if (radius == 2)
    {
        sphereAt(x, z, radius);
    }
    else
    {
        newRadius = radius / 2;
        scaledoverlap = overlap * newRadius;
        if (childDirection == 1)
        {
            child1Z = (z - radius - newRadius) + scaledoverlap;
            child2Z = (z + radius + newRadius) - scaledoverlap;
            
            union()
            { 
                sphereAt(x, z, radius);
                genTreeUnionImpl(newRadius, x, child1Z, 0
                , overlap);
                genTreeUnionImpl(newRadius, x, child2Z, 0, overlap);
            }
        }
        else
        {
            child1X = (x - radius - newRadius) + scaledoverlap;
            child2X = (x + radius + newRadius) - scaledoverlap;
            
            union()
            {
                sphereAt(x, z, radius);
                genTreeUnionImpl(newRadius, child1X, z, 1, overlap);
                genTreeUnionImpl(newRadius, child2X, z, 1, overlap);
            }
        }
    }
}

module genTreeDifferenceImpl(radius, x, z, childDirection, overlap)
{
    if (radius == 2)
    {
        sphereAt(x, z, radius);
    }
    else
    {
        newRadius = radius / 2;
        scaledoverlap = overlap * newRadius;
        if (childDirection == 1)
        {
            child1Z = (z - radius - newRadius) + scaledoverlap;
            child2Z = (z + radius + newRadius) - scaledoverlap;
            
            difference()
            { 
                sphereAt(x, z, radius);
                genTreeDifferenceImpl(newRadius, x, child1Z, 0, overlap);
                genTreeDifferenceImpl(newRadius, x, child2Z, 0, overlap);
            }
        }
        else
        {
            child1X = (x - radius - newRadius) + scaledoverlap;
            child2X = (x + radius + newRadius) - scaledoverlap;
            
            difference()
            {
                sphereAt(x, z, radius);
                genTreeDifferenceImpl(newRadius, child1X, z, 1, overlap);
                genTreeDifferenceImpl(newRadius, child2X, z, 1, overlap);
            }
        }
    }
}

module genTreeIntersectionImpl(radius, x, z, childDirection, overlap)
{
    if (radius == 2)
    {
        sphereAt(x, z, radius);
    }
    else
    {
        newRadius = radius / 2;
        scaledoverlap = overlap * newRadius;
        if (childDirection == 1)
        {
            child1Z = (z - radius - newRadius) + scaledoverlap;
            child2Z = (z + radius + newRadius) - scaledoverlap;
            
            intersection()
            { 
                sphereAt(x, z, radius);
                genTreeIntersectionImpl(newRadius, x, child1Z, 0, overlap);
            }
            
            intersection()
            {
                sphereAt(x, z, radius);
                genTreeIntersectionImpl(newRadius, x, child2Z, 0, overlap);
            }
        }
        else
        {
            child1X = (x - radius - newRadius) + scaledoverlap;
            child2X = (x + radius + newRadius) - scaledoverlap;
            
            intersection()
            {
                sphereAt(x, z, radius);
                genTreeIntersectionImpl(newRadius, child1X, z, 1, overlap);
            }
            
            intersection()
            {
                sphereAt(x, z, radius);
                genTreeIntersectionImpl(newRadius, child2X, z, 1, overlap);
            }
        }
    }
}

module genTreeIntersectionImpl2(radius, x, z, childDirection, overlap)
{
    if (radius == 4)
    {
        newRadius = radius / 2;
        scaledoverlap = overlap * newRadius;
        if (childDirection == 1)
        {
            child1Z = (z - radius - newRadius) + scaledoverlap;
            child2Z = (z + radius + newRadius) - scaledoverlap;
            
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
            child1X = (x - radius - newRadius) + scaledoverlap;
            child2X = (x + radius + newRadius) - scaledoverlap;
            
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
        scaledoverlap = overlap * newRadius;
        if (childDirection == 1)
        {
            child1Z = (z - radius - newRadius) + scaledoverlap;
            child2Z = (z + radius + newRadius) - scaledoverlap;
            
            union()
            { 
                sphereAt(x, z, radius);
                genTreeIntersectionImpl2(newRadius, x, child1Z, 0, overlap);
                genTreeIntersectionImpl2(newRadius, x, child2Z, 0, overlap);
            }
        }
        else
        {
            child1X = (x - radius - newRadius) + scaledoverlap;
            child2X = (x + radius + newRadius) - scaledoverlap;
            
            union()
            {
                sphereAt(x, z, radius);
                genTreeIntersectionImpl2(newRadius, child1X, z, 1, overlap);
                genTreeIntersectionImpl2(newRadius, child2X, z, 1, overlap);
            }
        }
    }
}

module sphereAt(x, z, radius)
{
    translate([x, 0, z])
        sphere(radius);
}