// Algorithms to design electrical grids

#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#include "Graph.h"
#include "place.h"
#include "Pq.h"

////////////////////////////////////////////////////////////////////////
// Your task
static struct edge createEdge(struct place p1, struct place p2, Vertex v, Vertex w);
static Graph createGraph(struct place cities[], int numCities,
              struct place powerPlant,
              struct powerLine powerLines[]);
/**
 * Designs  a minimal cost electrical grid that will deliver electricity
 * from a power plant to all the given cities. Power lines must be built
 * between cities or between a city and a power plant.  Cost is directly
 * proportional to the total length of power lines used.
 * Assumes  that  numCities  is at least 1 (numCities is the size of the
 * cities array).
 * Stores the power lines that need to be built in the given  powerLines
 * array, and returns the number of power lines stored. Assumes that the
 * powerLines array is large enough to store all required power lines.
 */

int planGrid1(struct place cities[], int numCities,
              struct place powerPlant,
              struct powerLine powerLines[]) {
    Graph g = createGraph(cities, numCities, powerPlant, powerLines);
    Graph tree = GraphMst(g);
    
    int count = 0;
    for (Vertex v = 0; v < numCities + 1; v++) {
        for (Vertex w = v + 1; w < numCities + 1; w++) {
            if (GraphIsAdjacent(tree, v, w)) {
                struct powerLine pL;
                pL.p1 = (v == numCities) ? powerPlant : cities[v];
                pL.p2 = (w == numCities) ? powerPlant : cities[w];
                powerLines[count++] = pL;
            }
        }
    }

    GraphFree(g);
    GraphFree(tree);
    return count;
}



//create a graph with numcities+1 vertex by cities and powerplant, powerplant as the last vertex 
static Graph createGraph(struct place cities[], int numCities,
                         struct place powerPlant,
                         struct powerLine powerLines[]) {
    Graph g = GraphNew(numCities + 1); // +1 for power plant at index numCities

    // Add edges between powerPlant and each city
    for (Vertex v = 0; v < numCities; v++) {
        struct edge e = createEdge(powerPlant, cities[v], numCities, v);
        GraphInsertEdge(g, e);
    }

    // Add edges between all pairs of cities
    for (Vertex v = 0; v < numCities; v++) {
        for (Vertex w = v + 1; w < numCities; w++) {
            struct edge e = createEdge(cities[v], cities[w], v, w);
            GraphInsertEdge(g, e);
        }
    }

    return g;
}

//calculas distance between 2 city and create edge
static struct edge createEdge(struct place p1, struct place p2, Vertex v, Vertex w) {
    double dx = p1.x - p2.x;
    double dy = p1.y - p2.y;
    double weight = sqrt(dx * dx + dy * dy);
    
    struct edge e;
    e.v = v;
    e.w = w;
    e.weight = weight;
    return e;
}

////////////////////////////////////////////////////////////////////////
// Optional task

/**
 * Designs  a minimal cost electrical grid that will deliver electricity
 * to all the given cities.  Power lines must be built between cities or
 * between a city and a power plant.  Cost is directly  proportional  to
 * the  total  length of power lines used.  Assume that each power plant
 * generates enough electricity to supply all cities, so not  all  power
 * plants need to be used.
 * Assumes  that  numCities and numPowerPlants are at least 1 (numCities
 * and numPowerPlants are the sizes of the cities and powerPlants arrays
 * respectively).
 * Stores the power lines that need to be built in the given  powerLines
 * array, and returns the number of power lines stored. Assumes that the
 * powerLines array is large enough to store all required power lines.
 */
int planGrid2(struct place cities[], int numCities,
              struct place powerPlants[], int numPowerPlants,
              struct powerLine powerLines[]) {
    // TODO: Complete this function
    return 0;
}
