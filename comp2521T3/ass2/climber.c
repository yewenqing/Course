// COMP2521 25T3 - Assignment 2
// Implementation of boulder climbing algorithms

#include <assert.h>
#include <limits.h>
#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include "climber.h"
#include "Wall.h"
#include "Graph.h"

#include "VertexPq.h"
#include "StatePq.h"
#define INF 1000000
#define MAX_ENERGY_LIMIT 128




typedef struct {
    int prevRock;
    int prevEnergy;
} PrevState;


static struct path getPath(Vertex pred[], struct rock rocks[],
                           Vertex src, Vertex dest);

static int findStartRocks(Wall w, int reach, struct rock *rocks, int totalColourRocksNum, Vertex startVertexs[]);
static int findEndRocks(Wall w, int reach, struct rock *rocks, int totalColourRocksNum, Vertex endVertexs[]);

static Graph BuildGraph(int reach, struct rock *rocks, int totalColourRocksNum);
static void Dijkstra(Graph g, Vertex src, int dist[], Vertex pred[]);
static int pqInsertNeighbors(Graph g, Pq pq, Vertex v, int dist[], Vertex pred[]);
static Graph BuildGraphEnergy(int reach, struct rock *rocks, int nV, int energyCosts[NUM_COLOURS]);

static int StateDijkstra(
    Graph g,
    struct rock rocks[],
    int nRocks,
    int energyCosts[],
    int maxEnergy,
    Vertex startVertexs[],
    int startNum,
    int dist[][MAX_ENERGY_LIMIT],
    PrevState pred[][MAX_ENERGY_LIMIT],
    bool visited[][MAX_ENERGY_LIMIT]
);



struct path findShortestPath(Wall w, int reach, Colour colour) {
	int height = WallHeight(w);
	int width = WallWidth(w);
	int maxDist = height*height + width*width;	
	struct rock *rocks = malloc(sizeof(struct rock) * WallNumRocks(w));

	int totalColourRocksNum = WallGetColouredRocksInRange(w, 1, 1, maxDist, colour, rocks); 

	if (totalColourRocksNum == 0) {
		free(rocks);
		struct path empty = {0, NULL};
		return empty;
	}
	Vertex *startVertexs = malloc(sizeof(Vertex) * totalColourRocksNum);
	Vertex *endVertexs = malloc(sizeof(Vertex) * totalColourRocksNum);

	int *dist = malloc(sizeof(int) * totalColourRocksNum);
	int *pred = malloc(sizeof(Vertex) * totalColourRocksNum);
	int startNum = findStartRocks(w, reach, rocks, totalColourRocksNum, startVertexs);
	int endNum = findEndRocks(w, reach, rocks, totalColourRocksNum, endVertexs);


	struct path p = {0, NULL};

	if (startNum == 0 || endNum == 0) {
		free(startVertexs);
		free(endVertexs);
		free(rocks);
		return p;  // return empty path if not valid start or end
	}
	int minDist = INF;

	Graph g = BuildGraph(reach, rocks, totalColourRocksNum);
	for (int i = 0; i < startNum; i++) {
		Vertex sV = startVertexs[i];
		Dijkstra(g, sV, dist, pred);
		for (int j = 0; j < endNum; j++) {
			Vertex eV = endVertexs[j];
			int distance = dist[eV];
			if (distance < minDist) {
				minDist = distance;
				if (p.rocks != NULL) free(p.rocks);
				p = getPath(pred, rocks, sV, eV);
			}
		}
	
		
	}
	GraphFree(g);
	free(dist);
	free(pred);

	free(startVertexs);
	free(endVertexs);
	free(rocks);


	


	if (minDist == INF) {
		// no path
		return p;
	}
	return p;
}



struct path findMinEnergyPath(Wall w, int reach, int energyCosts[NUM_COLOURS]) {

	struct rock *rocks = malloc(sizeof(struct rock) * WallNumRocks(w));

	int nV = WallGetAllRocks(w, rocks);

	if (nV == 0) {
		free(rocks);
		struct path empty = {0, NULL};
		return empty;
	}
	Vertex *startVertexs = malloc(sizeof(Vertex) * nV);
	Vertex *endVertexs = malloc(sizeof(Vertex) * nV);

	int *dist = malloc(sizeof(int) * nV);
	int *pred = malloc(sizeof(Vertex) * nV);
	int startNum = findStartRocks(w, reach, rocks, nV, startVertexs);
	int endNum = findEndRocks(w, reach, rocks, nV, endVertexs);


	struct path p = {0, NULL};

	if (startNum == 0 || endNum == 0) {
		free(startVertexs);
		free(endVertexs);
		free(rocks);
		return p;  // return empty path if not valid start or end
	}
	int minDist = INF;

	Graph g = BuildGraphEnergy(reach, rocks, nV, energyCosts);
	for (int i = 0; i < startNum; i++) {
		Vertex sV = startVertexs[i];
		Dijkstra(g, sV, dist, pred);
		for (int j = 0; j < endNum; j++) {
			Vertex eV = endVertexs[j];
			int distance = dist[eV];
			if (distance < minDist) {
				minDist = distance;
				if (p.rocks != NULL) free(p.rocks);
				p = getPath(pred, rocks, sV, eV);
			}
		}
	
		
	}
	GraphFree(g);
	free(dist);
	free(pred);

	free(startVertexs);
	free(endVertexs);
	free(rocks);


	


	if (minDist == INF) {
		// no path
		return p;
	}
	return p;


}


struct path findMinTurnsPath(Wall w, int reach, int energyCosts[NUM_COLOURS],
                             int maxEnergy) {

    int height = WallHeight(w);


    // 1. get all rocks
    struct rock *rocks = malloc(sizeof(struct rock) * WallNumRocks(w));
    int nRocks = WallGetAllRocks(w, rocks);
    if (nRocks == 0) {
        struct path p = {0, NULL};
        return p;
    }

    // 2. find start/end
    Vertex *startVertexs = malloc(nRocks * sizeof(Vertex));
    Vertex *endVertexs   = malloc(nRocks * sizeof(Vertex));
    int startNum = 0, endNum = 0;

    for (int i = 0; i < nRocks; i++) {
        if (rocks[i].row <= reach)
            startVertexs[startNum++] = i;
        if (rocks[i].row >= height - reach)
            endVertexs[endNum++] = i;
    }

    if (startNum == 0 || endNum == 0) {
        free(rocks);
        free(startVertexs);
        free(endVertexs);
        struct path p = {0, NULL};
        return p;
    }


    // 3. build graph
    Graph g = BuildGraph(reach, rocks, nRocks);


    // 4. creat dist / pred / visited
    int (*dist)[MAX_ENERGY_LIMIT] = malloc(nRocks * sizeof *dist);
    bool (*visited)[MAX_ENERGY_LIMIT] = malloc(nRocks * sizeof *visited);
    PrevState (*pred)[MAX_ENERGY_LIMIT] = malloc(nRocks * sizeof *pred);
    if (!dist || !visited || !pred) {
        free(dist); free(visited); free(pred);
        GraphFree(g);
        free(rocks);
        free(startVertexs);
        free(endVertexs);
        struct path p = {0, NULL};
        return p;
    }


    // 5. run stateDijkstra
    int validStart = StateDijkstra(
        g,
        rocks,
        nRocks,
        energyCosts,
        maxEnergy,
        startVertexs,
        startNum,
        dist,
        pred,
        visited
    );



    // -------------------------
    // 6. get best end rock
    //     - pick lessest dist 
    //     - if same dist pick greatest energy
    // -------------------------
    int bestRock = -1;
    int bestEnergy = -1;
    int bestDist = INF;

    for (int i = 0; i < endNum; i++) {
        int r = endVertexs[i];
        for (int e = 0; e <= maxEnergy; e++) {

            int d = dist[r][e];
            if (d < bestDist) {
                bestDist = d;
                bestRock = r;
                bestEnergy = e;
            }
            else if (d == bestDist && e > bestEnergy) {
                bestRock = r;
                bestEnergy = e;
            }
        }
    }

    // unreachable
    if (bestRock == -1) {
        free(dist);
        free(visited);
        free(pred);
        GraphFree(g);
        free(rocks);
        free(startVertexs);
        free(endVertexs);
        struct path p = {0, NULL};
        return p;
    }

    // 7. back track
    int capacity = nRocks * 2;
    Vertex *rev = malloc(capacity * sizeof(Vertex));
    int len = 0;

    int r = bestRock;
    int e = bestEnergy;

    while (r != -1) {
        rev[len++] = r;

        PrevState p = pred[r][e];
        r = p.prevRock;
        e = p.prevEnergy;
    }


    // 8. create path
    struct path ans;
    ans.numRocks = len;
    ans.rocks = malloc(len * sizeof(struct rock));

    for (int i = 0; i < len; i++) {
        ans.rocks[i] = rocks[ rev[len - 1 - i] ];
    }

    // 9. clean
    free(rev);
    GraphFree(g);
    free(rocks);
    free(startVertexs);
    free(endVertexs);
    free(dist);
    free(visited);
    free(pred);
	if (validStart == -1) {
		ans.numRocks = 0;
	}
    return ans;
}



static struct path getPath(Vertex pred[], struct rock rocks[],
                           Vertex src, Vertex dest) {
    struct path p = {0, NULL};

    // if unreachable
    if (pred[dest] == -1) {
        return p;
    }

    // Step 1：calculate path length
    int count = 0;
    Vertex v = dest;
    while (true) {
        count++;
        if (v == src) break;
        v = pred[v];
        if (v == -1) {  
            p.numRocks = 0;
            return p;
        }
    }

    // Step 2 fill p
    p.numRocks = count;
    p.rocks = malloc(sizeof(struct rock) * count);

    // Step 3：fill rocks[] from back to front
    v = dest;
    for (int i = count - 1; i >= 0; i--) {
        p.rocks[i] = rocks[v];
        if (v == src) break;
        v = pred[v];
    }

    return p;
}
//


// store all rocks can use as start in startRocks, and return the number of those rocks
static int findStartRocks(Wall w, int reach, struct rock *rocks, int nV, Vertex startVertexs[]) {
	int count = 0;
	for (int i = 0; i < nV; i++) {
		if (rocks[i].row <= reach) {
			startVertexs[count] = i;
			count++;
		}
		
	}
	return count;
}

// store all rocks can use as end in endRocks, and return the number of those rocks
static int findEndRocks(Wall w, int reach, struct rock *rocks, int nV, Vertex endVertexs[]) {
	int count = 0;
	for (int i = 0; i < nV; i++) {
		if (rocks[i].row >= WallHeight(w) - reach) {
			endVertexs[count] = i;
			count++;
		}
		
	}
	return count;
}
// calculate distance between 2 rocks
// static double calculateDist(struct rock a, struct rock b) {
// 	int drow = a.row - b.row;
// 	int dcol = a.col - b.col;
// 	return sqrt(drow*drow + dcol*dcol);
// }

// use rocks to build graph, create edge between 2 rocks if dist < reach
// build graph using rocks, add edge if distance between 2 rocks < reach
// nV = totalColourRocksNum
// weight = 1
static Graph BuildGraph(int reach, struct rock *rocks, int nV) {
    Graph g = GraphNew(nV);

    int reach2 = reach * reach;  

    // adding edges
    for (int i = 0; i < nV; i++) {
        for (int j = i + 1; j < nV; j++) {

            int dr = rocks[i].row - rocks[j].row;
            int dc = rocks[i].col - rocks[j].col;
            int dist2 = dr * dr + dc * dc;

            if (dist2 <= reach2) {

                
                struct edge e1 = {i, j, 1.0};
                GraphInsertEdge(g, e1);

                struct edge e2 = {j, i, 1.0};
                GraphInsertEdge(g, e2);
            }
        }
    }

    return g;
}
// Dijkstra's algorithm
static void Dijkstra(Graph g, Vertex src, int dist[], Vertex pred[]) {
	int nV = GraphNumVertices(g);
	bool *visited = malloc(sizeof(bool) * nV);
	// initial arrays
	for (int i = 0; i < nV; i++) {
		dist[i] = INF;
		pred[i] = -1;
		visited[i] = false;
	}
	
	dist[src] = 0;
	pred[src] = src;
	Pq pq = PqNew();
	struct vertexDist vdsrc;
	vdsrc.distance = 0;
	vdsrc.v = src;
	PqInsert(pq, vdsrc);


	while(!PqIsEmpty(pq)) {
		struct vertexDist vd = PqExtract(pq);
		Vertex v = vd.v;
		if (visited[v]) continue;
		visited[v] = true;
		pqInsertNeighbors(g, pq, v, dist, pred);
	
	}
	free(visited);
	PqFree(pq);
}

// insert neighbors of v into pq and return the number of neighbors
static int pqInsertNeighbors(Graph g, Pq pq, Vertex v, int dist[], Vertex pred[]) {
	int count = 0;
	int nV = GraphNumVertices(g);
	for (Vertex w = 0; w < nV; w++) {
		double weight = GraphIsAdjacent(g, v, w);
		if (weight > 0.0) {
    		//double weight = 1.0;  
			int distance = dist[v] + (int)weight;
			if (distance < dist[w]) {
				dist[w] = distance;
				pred[w] = v;
				struct vertexDist vd;
				vd.v = w;
				vd.distance = dist[w];
				PqInsert(pq, vd);
				count++;	
			}	
		}

	}
	return count;
	
}



// use rocks to build graph, create edge between 2 rocks if dist < reach
// build graph using rocks, add edge if distance between 2 rocks < reach
// nV = totalColourRocksNum
// weight = rock energyCost
static Graph BuildGraphEnergy(int reach, struct rock *rocks, int nV, int energyCosts[NUM_COLOURS]) {
    Graph g = GraphNew(nV);

    int reach2 = reach * reach;  // 

    // adding edges
    for (int i = 0; i < nV; i++) {
        for (int j = i + 1; j < nV; j++) {

            int dr = rocks[i].row - rocks[j].row;
            int dc = rocks[i].col - rocks[j].col;
            int dist2 = dr * dr + dc * dc;

            if (dist2 <= reach2) {

                
                struct edge e1 = {i, j, (double)energyCosts[rocks[j].colour]};
                GraphInsertEdge(g, e1);

                struct edge e2 = {j, i, (double)energyCosts[rocks[i].colour]};
                GraphInsertEdge(g, e2);
            }
        }
    }

    return g;
}





static int StateDijkstra(
    Graph g,
    struct rock rocks[],
    int nRocks,
    int energyCosts[],
    int maxEnergy,
    Vertex startVertexs[],
    int startNum,
    
    int dist[][MAX_ENERGY_LIMIT],     // turn 
    PrevState pred[][MAX_ENERGY_LIMIT],
    bool visited[][MAX_ENERGY_LIMIT]
) {
    StatePq pq = StatePqNew();

	bool validStart = false;
    // initial
    for (int r = 0; r < nRocks; r++) {
        for (int e = 0; e <= maxEnergy; e++) {
            dist[r][e] = INF;
            visited[r][e] = false;
            pred[r][e].prevRock = -1;
            pred[r][e].prevEnergy = -1;
        }
    }

    // start rocks →  (rock, maxEnergy - cost)
    for (int i = 0; i < startNum; i++) {
		int r = startVertexs[i];
		int cost = energyCosts[rocks[r].colour];

		if (cost <= maxEnergy) {
			int newE = maxEnergy - cost;
			if (newE < 0) continue;
			dist[r][newE] = 1;     // climb，turn=1

			State s = { r, newE, 1 };
			StatePqInsert(pq, s);
			validStart = true;
		}
    }

 
    //     Dijkstra
    while (!StatePqIsEmpty(pq)) {
        State s = StatePqExtract(pq);
        int rock = s.rock;
        int energy = s.energy;
        int distance = s.dist;

        if (visited[rock][energy]) continue;
        visited[rock][energy] = true;


        // try to climb to next rock w

        for (int w = 0; w < nRocks; w++) {
            if (GraphIsAdjacent(g, rock, w) > 0.0) {

                // cost energy to climb to w
                int cost = energyCosts[ rocks[w].colour ];

                // climb when have enough energy
                if (energy >= cost) {
                    int newE = energy - cost;
                    int newDist = distance + 1;

                    if (newDist < dist[w][newE]) {
                        dist[w][newE] = newDist;
                        pred[w][newE].prevRock = rock;
                        pred[w][newE].prevEnergy = energy;

                        State nxt = { w, newE, newDist };
                        StatePqInsert(pq, nxt);
                    }
                }
            }
        }


        // (2) rest, energy = maxenergy turn += 1
        if (energy < maxEnergy) {
            int newE = maxEnergy;
            int newDist = distance + 1;

            if (newDist < dist[rock][newE]) {
                dist[rock][newE] = newDist;
                pred[rock][newE].prevRock = rock;
                pred[rock][newE].prevEnergy = energy;

                State nxt = { rock, newE, newDist };
                StatePqInsert(pq, nxt);
            }
        }
    }

    StatePqFree(pq);
	if (!validStart) return -1;
	return 0;
}
