// BFS maze solver

#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include "cell.h"
#include "matrix.h"
#include "Maze.h"
#include "Queue.h"

static void cleanUp(Queue q, bool **visited, struct cell **prev, Queue path);
static void getPath(struct cell **prev, Queue path, struct cell start, struct cell end);
static void showPath(Maze m, Queue path);
static void getNeighbors(Maze m, struct cell curr, Queue q, bool **visited, struct cell **prev);



bool solve(Maze m) {
    // Complete this function
    //       Feel free to add helper functions
    int height = MazeHeight(m);
    int width = MazeWidth(m);
    struct cell **prev = createCellMatrix(height,width);
    bool **visited = createBoolMatrix(height,width);
    Queue q = QueueNew();
    Queue path = QueueNew();    
    struct cell start = MazeGetStart(m);
    MazeVisit(m, start);
    QueueEnqueue(q,start);
    visited[start.row][start.col] = true;
    struct cell curr = start;

    
    while (!QueueIsEmpty(q)) {
        curr = QueueDequeue(q); 
        if (MazeVisit(m,curr)) {          
            getPath(prev, path, start, curr);//O(n)
            showPath(m, path);//O(n)
            cleanUp(q, visited, prev, path);//O(n)
            return true;
        }
        
        getNeighbors(m, curr, q, visited, prev);//O(1)
        
        
    }
    cleanUp(q, visited, prev, path);
    return false;
}


// free memory
static void cleanUp(Queue q, bool **visited, struct cell **prev, Queue path) {//O(n)
    QueueFree(q);
    QueueFree(path); 
    freeBoolMatrix(visited); 
    freeCellMatrix(prev);    
}


// Enqueue path to a queue by read prev from end to start
static void getPath(struct cell **prev, Queue path, struct cell start, struct cell end) {//O(n)
    struct cell curr = end;
    while (curr.row != start.row || curr.col != start.col ) {
        QueueEnqueue(path, curr);
        curr = prev[curr.row][curr.col];
    }
    QueueEnqueue(path, start);
}

// show path on maze
static void showPath(Maze m, Queue path) { //O(n)
    while (!QueueIsEmpty(path)) {
        MazeMarkPath(m, QueueDequeue(path));
    }
}

// get neighbors of curr cell
static void getNeighbors(Maze m, struct cell curr, Queue q, bool **visited, struct cell **prev) {//O(1)
int dRow[] = {-1, 1, 0, 0};
int dCol[] = {0, 0, -1, 1};

// check all 8 neighbors of curr
for (int i = 0; i < 4; i++) {
    struct cell next;
    next.row = curr.row + dRow[i];
    next.col = curr.col + dCol[i];
    
    // if next in maze
    if (next.row >= 0 && next.row < MazeHeight(m) &&
        next.col >= 0 && next.col < MazeWidth(m)) {
        // if next is not wall and not visited
        if (!MazeIsWall(m, next) && !visited[next.row][next.col]) {
            // mark curr as next's prev
            prev[next.row][next.col] = curr;
            // mark next as visited
            visited[next.row][next.col] = true;            
            //euqueue next
            QueueEnqueue(q, next);
        }
    }
}    
}


