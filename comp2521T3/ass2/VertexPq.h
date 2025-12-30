// Priority queue of edges
// Edges with smaller weight have higher priority

// !!! DO NOT MODIFY THIS FILE !!!

#ifndef VPQ_H
#define VPQ_H

#include <stdbool.h>

#include "Graph.h"

typedef struct pq *Pq;
struct vertexDist {
	Vertex v;
	int distance;
};


/**
 * Creates a new priority queue
 * Time complexity: O(1)
 */
Pq PqNew(void);

/**
 * Frees all memory associated with the given priority queue
 * Time complexity: O(1)
 */
void PqFree(Pq pq);

/**
 * Adds an vertex to the priority queue
 * Time complexity: O(log n) amortised
 */
void PqInsert(Pq pq, struct vertexDist);

/**
 * Removes and returns the vertex with the smallest distance from the
 * priority queue. If multiple vertex have the same smallest distance, one
 * of them will be removed.
 * Time complexity: O(log n)
 */
struct vertexDist PqExtract(Pq pq);

/**
 * Returns true if the given priority queue is empty, or false otherwise
 * Time complexity: O(1)
 */
bool PqIsEmpty(Pq pq);

/**
 * Prints the given priority queue to stdout for debugging purposes
 */
void PqShow(Pq pq);

#endif
