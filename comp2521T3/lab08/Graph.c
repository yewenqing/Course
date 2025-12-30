// Implementation of the Undirected Weighted Graph ADT
// Uses an adjacency matrix

#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include "Graph.h"
#include "Pq.h"

// DO NOT modify this struct
struct graph {
    int nV;         // #vertices
    int nE;         // #edges
    double **edges; // adjacency matrix storing positive weights
                    // 0 if nodes not adjacent
};

static bool validVertex(Graph g, Vertex v);
static void treeAddEdge(Graph g, Graph tree, int nV, Pq pq, Vertex *parent);
static int *dsCreate(int n);
static int dsFind(Vertex *parent, Vertex x); 
static void dsUnion(Vertex *parent, Vertex x, Vertex y); 
static Pq pqAddEdges(Graph g, int nV);
////////////////////////////////////////////////////////////////////////

Graph GraphNew(int nV) {
    assert(nV > 0);

    Graph g = malloc(sizeof(*g));
    if (g == NULL) {
        fprintf(stderr, "error: out of memory\n");
        exit(EXIT_FAILURE);
    }

    g->nV = nV;
    g->nE = 0;

    g->edges = malloc(nV * sizeof(double *));
    if (g->edges == NULL) {
        fprintf(stderr, "error: out of memory\n");
        exit(EXIT_FAILURE);
    }
    for (int i = 0; i < nV; i++) {
        g->edges[i] = calloc(nV, sizeof(double));
        if (g->edges[i] == NULL) {
            fprintf(stderr, "error: out of memory\n");
            exit(EXIT_FAILURE);
        }
    }

    return g;
}

void GraphFree(Graph g) {
    for (int i = 0; i < g->nV; i++) {
        free(g->edges[i]);
    }
    free(g->edges);
    free(g);
}

////////////////////////////////////////////////////////////////////////

int GraphNumVertices(Graph g) {
    return g->nV;
}

bool GraphInsertEdge(Graph g, struct edge e) {
    assert(validVertex(g, e.v));
    assert(validVertex(g, e.w));
    assert(e.v != e.w);
    assert(e.weight > 0.0);

    if (g->edges[e.v][e.w] == 0.0) {
        g->edges[e.v][e.w] = e.weight;
        g->edges[e.w][e.v] = e.weight;
        g->nE++;
        return true;
    } else {
        return false;
    }
}

bool GraphRemoveEdge(Graph g, Vertex v, Vertex w) {
    assert(validVertex(g, v));
    assert(validVertex(g, w));

    if (g->edges[v][w] != 0.0) {   // edge e in graph
        g->edges[v][w] = 0.0;
        g->edges[w][v] = 0.0;
        g->nE--;
        return true;
    } else {
        return false;
    }
}

double GraphIsAdjacent(Graph g, Vertex v, Vertex w) {
    assert(validVertex(g, v));
    assert(validVertex(g, w));
    
    return g->edges[v][w];
}

void GraphShow(Graph g) {
    printf("Number of vertices: %d\n", g->nV);
    printf("Number of edges: %d\n", g->nE);
    for (int v = 0; v < g->nV; v++) {
        for (int w = v + 1; w < g->nV; w++) {
            if (g->edges[v][w] != 0.0) {
                printf("Edge %d - %d: %lf\n", v, w, g->edges[v][w]);
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////
// Your task

//Kruskal's algorithm
Graph GraphMst(Graph g) {
    int nV = GraphNumVertices(g);
    int *parent = dsCreate(nV);
    Pq pq = pqAddEdges(g, nV);
    Graph tree = GraphNew(nV);
    while (!PqIsEmpty(pq)) {
        treeAddEdge(g, tree, nV, pq, parent);
    }
    free(parent);
    PqFree(pq);
    return tree;
}

////////////////////////////////////////////////////////////////////////

static bool validVertex(Graph g, Vertex v) {
    return v >= 0 && v < g->nV;
}

// Add edge to tree if its two vertices are in different sets 
static void treeAddEdge(Graph g, Graph tree, int nV, Pq pq, Vertex *parent) {
    struct edge e = PqExtract(pq);
    if (dsFind(parent, e.v) != dsFind(parent, e.w)) {
        dsUnion(parent, e.v, e.w);
        GraphInsertEdge(tree, e);
    }
}


//create a Disjoint-set 
static int *dsCreate(int n) {
    Vertex *parent = malloc(n * sizeof(Vertex));
    for (Vertex i = 0; i < n; i++) parent[i] = i;
    return parent;
}

//find which set vertex is in
static int dsFind(Vertex *parent, Vertex x) {
    if (parent[x] != x) parent[x] = dsFind(parent, parent[x]);
    return parent[x];
}

//union sets when add a edge link 2 vertex
static void dsUnion(Vertex *parent, Vertex x, Vertex y) {
    Vertex rootX = dsFind(parent, x);
    Vertex rootY = dsFind(parent, y);
    if (rootX != rootY) parent[rootY] = rootX;
}


//add edge into pq
static Pq pqAddEdges(Graph g, int nV) {
    Pq pq = PqNew();
    for (Vertex v = 0; v < nV; v++) {
        for (Vertex w = v + 1; w < nV; w++) {
            double weight = GraphIsAdjacent(g, v, w);
            if (weight > 0.0) {
                struct edge e = {v, w, weight};
                PqInsert(pq, e);
            }
        }
    }
    return pq;
}