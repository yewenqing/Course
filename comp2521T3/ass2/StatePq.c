#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "StatePq.h"

#define DEFAULT_CAPACITY 128

struct state_pq {
    State *items;
    int size;
    int capacity;
};

static void fixUp(StatePq pq, int i);
static void fixDown(StatePq pq, int i);
static void swap(State *items, int i, int j);

StatePq StatePqNew(void) {
    StatePq pq = malloc(sizeof(*pq));
    if (!pq) {
        fprintf(stderr, "Cannot allocate priority queue\n");
        exit(1);
    }

    pq->items = malloc((DEFAULT_CAPACITY + 1) * sizeof(State));
    if (!pq->items) {
        fprintf(stderr, "Cannot allocate PQ storage\n");
        exit(1);
    }

    pq->size = 0;
    pq->capacity = DEFAULT_CAPACITY;
    return pq;
}

void StatePqFree(StatePq pq) {
    free(pq->items);
    free(pq);
}

void StatePqInsert(StatePq pq, State s) {
    if (pq->size == pq->capacity) {
        pq->capacity *= 2;
        pq->items = realloc(pq->items,
                            (pq->capacity + 1) * sizeof(State));
        if (!pq->items) {
            fprintf(stderr, "PQ realloc failed\n");
            exit(1);
        }
    }

    pq->size++;
    pq->items[pq->size] = s;
    fixUp(pq, pq->size);
}

State StatePqExtract(StatePq pq) {
    assert(pq->size > 0);

    State min = pq->items[1];
    pq->items[1] = pq->items[pq->size];
    pq->size--;
    fixDown(pq, 1);
    return min;
}

bool StatePqIsEmpty(StatePq pq) {
    return pq->size == 0;
}

//=============================
//   heap helpers
//=============================

static void fixUp(StatePq pq, int i) {
    while (i > 1 && pq->items[i].dist < pq->items[i / 2].dist) {
        swap(pq->items, i, i / 2);
        i /= 2;
    }
}

static void fixDown(StatePq pq, int i) {
    int size = pq->size;
    while (1) {
        int left = i * 2;
        int right = left + 1;
        int smallest = i;

        if (left <= size && pq->items[left].dist < pq->items[smallest].dist) {
            smallest = left;
        }
        if (right <= size && pq->items[right].dist < pq->items[smallest].dist) {
            smallest = right;
        }
        if (smallest == i) break;

        swap(pq->items, i, smallest);
        i = smallest;
    }
}

static void swap(State *items, int i, int j) {
    State tmp = items[i];
    items[i] = items[j];
    items[j] = tmp;
}
