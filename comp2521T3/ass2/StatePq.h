// Priority Queue for Task 4 (Min-Heap based on dist)
//
// Store states: (rock, energy, dist)
// dist = number of turns (priority)

#ifndef STATE_PQ_H
#define STATE_PQ_H

#include <stdbool.h>

typedef struct state {
    int rock;     // which rock
    int energy;   // remaining energy
    int dist;     // number of turns used (priority)
} State;

typedef struct state_pq *StatePq;

StatePq StatePqNew(void);
void StatePqFree(StatePq pq);

void StatePqInsert(StatePq pq, State s);
State StatePqExtract(StatePq pq);  // extract min dist
bool StatePqIsEmpty(StatePq pq);

#endif
