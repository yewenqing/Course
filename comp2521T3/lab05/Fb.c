// Implementation of the FriendBook ADT

#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "Fb.h"
#include "List.h"
#include "Map.h"
#include "Queue.h"

#define DEFAULT_CAPACITY 1 // DO NOT change this line

struct adjNode {
    int v;
    struct adjNode *next;
};

// DO NOT modify this struct
struct fb {
    int numPeople;
    int capacity;

    char **names; // the id of a person is simply the index
                  // that contains their name in this array
    
    Map nameToId; // maps names to ids

    struct adjNode **adj; // adjacency lists, kept in increasing order
};

static void increaseCapacity(Fb fb);
static int nameToId(Fb fb, char *name);

static struct adjNode *newAdjNode(int v);
static bool inAdjList(struct adjNode *l, int v);
static void freeAdjList(struct adjNode *l);
void adjAddFriend(Fb fb, int id, int friendId);
void adjUnfriend(Fb fb, int id, int friendId);

// Please ignore this line
static struct adjNode * __attribute__((unused)) newAdjNode(int v);

////////////////////////////////////////////////////////////////////////

// Creates a new instance of FriendBook
Fb FbNew(void) {
    Fb fb = malloc(sizeof(*fb));
    if (fb == NULL) {
        fprintf(stderr, "error: out of memory\n");
        exit(EXIT_FAILURE);
    }

    fb->numPeople = 0;
    fb->capacity = DEFAULT_CAPACITY;
    
    fb->names = calloc(fb->capacity, sizeof(char *));
    if (fb->names == NULL) {
        fprintf(stderr, "error: out of memory\n");
        exit(EXIT_FAILURE);
    }
    
    fb->nameToId = MapNew();

    fb->adj = calloc(fb->capacity, sizeof(struct adjNode *));
    if (fb->adj == NULL) {
        fprintf(stderr, "error: out of memory\n");
        exit(EXIT_FAILURE);
    }

    return fb;
}

void FbFree(Fb fb) {
    for (int i = 0; i < fb->capacity; i++) {
        freeAdjList(fb->adj[i]);
    }
    free(fb->adj);

    MapFree(fb->nameToId);

    for (int i = 0; i < fb->numPeople; i++) {
        free(fb->names[i]);
    }
    free(fb->names);
    
    free(fb);
}

int FbNumPeople(Fb fb) {
    return fb->numPeople;
}

bool FbAddPerson(Fb fb, char *name) {
    if (fb->numPeople == fb->capacity) {
        increaseCapacity(fb);
    }

    if (!MapContains(fb->nameToId, name)) {
        int id = fb->numPeople++;
        fb->names[id] = strdup(name);
        MapSet(fb->nameToId, name, id);
        return true;
    } else {
        return false;
    }
}

static void increaseCapacity(Fb fb) {
    int newCapacity = fb->capacity * 2;
    
    fb->names = realloc(fb->names, newCapacity * sizeof(char *));
    if (fb->names == NULL) {
        fprintf(stderr, "error: out of memory\n");
        exit(EXIT_FAILURE);
    }
    for (int i = fb->capacity; i < newCapacity; i++) {
        fb->names[i] = NULL;
    }
    
    fb->adj = realloc(fb->adj, newCapacity * sizeof(struct adjNode));
    if (fb->adj == NULL) {
        fprintf(stderr, "error: out of memory\n");
        exit(EXIT_FAILURE);
    }
    for (int i = fb->capacity; i < newCapacity; i++) {
        fb->adj[i] = NULL;
    }
    
    fb->capacity = newCapacity;
}

bool FbHasPerson(Fb fb, char *name) {
    return MapContains(fb->nameToId, name);
}

List FbGetPeople(Fb fb) {
    List l = ListNew();
    for (int id = 0; id < fb->numPeople; id++) {
        ListAppend(l, fb->names[id]);
    }
    return l;
}

bool FbIsFriend(Fb fb, char *name1, char *name2) {
    int id1 = nameToId(fb, name1);
    int id2 = nameToId(fb, name2);
    return inAdjList(fb->adj[id1], id2);
}

////////////////////////////////////////////////////////////////////////
// Your tasks

bool FbFriend(Fb fb, char *name1, char *name2) {
    int id1 = nameToId(fb, name1);
    int id2 = nameToId(fb, name2);
    if (FbIsFriend(fb,name1,name2)) {
        return false;
    }
    else {
        adjAddFriend(fb,id1,id2);
        adjAddFriend(fb,id2,id1);
        return true;
    }
}

//add friend
void adjAddFriend(Fb fb, int id, int friendId) {
    struct adjNode *newFriend = newAdjNode(friendId);
    //if target has no friend, create first adjNode
    if (fb->adj[id] == NULL) {
        fb->adj[id] = newFriend;
        return;
    }
    
    // if newfriendId is less then target's frist friend's Id, insert new friend at the first
    else if (fb->adj[id]->v > friendId) {
        newFriend->next = fb->adj[id];
        fb->adj[id] = newFriend;
        return;
    }
    
    // insert newfriend to the right place
    for (struct adjNode *n = fb->adj[id]; n != NULL; n = n->next) {
        // place new friend at last
        if (n->next == NULL) {
            n->next = newFriend;
            return;
        }
        // place new friend in mid
        else if (n->v < friendId && n->next->v >friendId) {
            newFriend->next = n->next;
            n->next = newFriend;
            return;
        }
    }
}


int FbNumFriends(Fb fb, char *name) {
    int id = nameToId(fb,name);
    int count = 0;
    for (struct adjNode *n = fb->adj[id]; n != NULL; n = n->next) {
        count++;
    }
    
    return count;
}

List FbMutualFriends(Fb fb, char *name1, char *name2) {
    // TODO: Complete this function
    int id1 = nameToId(fb,name1);
    int id2 = nameToId(fb,name2);
    struct adjNode *p1 = fb->adj[id1];
    struct adjNode *p2 = fb->adj[id2];
    List l = ListNew();
    // use double pointer to Find Mutual Friends 
    while (p1 != NULL && p2 != NULL) {
        if (p1->v == p2->v) {
            //insert name to result list
            ListAppend(l,fb->names[p1->v]);
            p1 = p1->next;
            p2 = p2->next;
        }
        else if (p1->v < p2->v) {
            p1 = p1->next;
        }
        else {p2 = p2->next;}
    }
    return l;
}

bool FbUnfriend(Fb fb, char *name1, char *name2) {
    // TODO: Complete this function
    int id1 = nameToId(fb,name1);
    int id2 = nameToId(fb,name2);
    if (FbIsFriend(fb,name1,name2) ) {
        adjUnfriend(fb,id1,id2);
        adjUnfriend(fb,id2,id1);
        return true;
    }
    return false;
}

//Unilateral unfriend b from a
void adjUnfriend(Fb fb, int id, int friendId) {
    // if b is the only friend of a
    if (fb->adj[id]->v == friendId) {
        // free adj list
        freeAdjList(fb->adj[id]);
        fb->adj[id] = NULL;
        return;
    }
    
    // find b in a's friend list
    for (struct adjNode *n = fb->adj[id]; n->next != NULL; n = n->next) {
        if (n->next->v == friendId) {
            // if n->next is b
            // delete n->next and connect n and n->next->next 
            struct adjNode *unFriend = n->next;
            n->next = n->next->next;
            freeAdjList(unFriend);
            return;
        }
    }
}


int FbFriendRecs1(Fb fb, char *name, struct recommendation recs[]) {
    
    int id = nameToId(fb, name);
    int numPeople = fb->numPeople;

    //mark friend and self
    bool *isFriend = calloc(numPeople, sizeof(bool));
    for (struct adjNode *n = fb->adj[id]; n != NULL; n = n->next) {
        isFriend[n->v] = true;
    }
    isFriend[id] = true;

    //mutual friends count
    int *mutualCount = calloc(numPeople, sizeof(int));
    //Traverse every friend of target
    for (struct adjNode *n = fb->adj[id]; n != NULL; n = n->next) {
        int friendId = n->v;
        //Traverse every friend's friend of target
        for (struct adjNode *fn = fb->adj[friendId]; fn != NULL; fn = fn->next) {
            // if curr is not target's friend
            if (!isFriend[fn->v]) {
                // 
                mutualCount[fn->v]++;
            }
        }
    }

    //fill recs[]
    int recNum = 0;
    for (int i = 0; i < numPeople; i++) {
        if (mutualCount[i] > 0) {
            strcpy(recs[recNum].name, fb->names[i]);
            recs[recNum].numMutualFriends = mutualCount[i];
            recNum++;
        }
    }

    //sort recs[]
    for (int i = 0; i < recNum - 1; i++) {
        for (int j = i + 1; j < recNum; j++) {
            if (recs[j].numMutualFriends > recs[i].numMutualFriends) {
                struct recommendation tmp = recs[i];
                recs[i] = recs[j];
                recs[j] = tmp;
            }
        }
    }

    free(isFriend);
    free(mutualCount);
    return recNum;
}

////////////////////////////////////////////////////////////////////////
// Optional task

List FbFriendRecs2(Fb fb, char *name) {
    // TODO: Complete this function
    List l = ListNew();
    return l;
}

////////////////////////////////////////////////////////////////////////
// Helper Functions

// Converts a name to an ID. Raises an error if the name doesn't exist.
static int nameToId(Fb fb, char *name) {
    if (!MapContains(fb->nameToId, name)) {
        fprintf(stderr, "error: person '%s' does not exist!\n", name);
        exit(EXIT_FAILURE);
    }
    return MapGet(fb->nameToId, name);
}

static struct adjNode *newAdjNode(int v) {
    struct adjNode *n = malloc(sizeof(*n));
    if (n == NULL) {
        fprintf(stderr, "error: out of memory\n");
        exit(EXIT_FAILURE);
    }

    n->v = v;
    n->next = NULL;
    return n;
}

static bool inAdjList(struct adjNode *l, int v) {
    for (struct adjNode *n = l; n != NULL && n->v <= v; n = n->next) {
        if (n->v == v) {
            return true;
        }
    }
    return false;
}

static void freeAdjList(struct adjNode *l) {
    struct adjNode *n = l;
    while (n != NULL) {
        struct adjNode *temp = n;
        n = n->next;
        free(temp);
    }
}

