// DFS maze solver

#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include "cell.h"
#include "matrix.h"
#include "Maze.h"
#include "Stack.h"



static void cleanUp(Stack s, bool **visited, struct cell **prev, Stack path);
static void getPath(struct cell **prev, Stack path, struct cell start, struct cell end);
static void showPath(Maze m, Stack path);
static void getNeighbors(Maze m, struct cell curr, Stack s, bool **visited, struct cell **prev);

bool solve(Maze m) {
    // TODO: Complete this function
    //       Feel free to add helper functions
    int height = MazeHeight(m);
    int width = MazeWidth(m);
    struct cell **prev = createCellMatrix(height,width);
    bool **visited = createBoolMatrix(height,width);
    Stack s = StackNew();
    Stack path = StackNew();    
    struct cell start = MazeGetStart(m);
    MazeVisit(m, start);
    StackPush(s, start);
    visited[start.row][start.col] = true;
    struct cell curr = start;

    
    while (!StackIsEmpty(s)) {
        curr = StackPop(s);
        // move mark visited to here
        visited[curr.row][curr.col] = true;
        if (MazeVisit(m,curr)) {          
            getPath(prev, path, start, curr);
            showPath(m, path);
            cleanUp(s, visited, prev, path);
            return true;
        }
        
        getNeighbors(m, curr, s, visited, prev);
    }
    cleanUp(s, visited, prev, path);
    return false;
}



static void cleanUp(Stack s, bool **visited, struct cell **prev, Stack path) {
    StackFree(s);
    StackFree(path);
    freeBoolMatrix(visited);
    freeCellMatrix(prev);    
}



static void getPath(struct cell **prev, Stack path, struct cell start, struct cell end) {
    struct cell curr = end;
    while (curr.row != start.row || curr.col != start.col ) {
        StackPush(path, curr);
        curr = prev[curr.row][curr.col];
    }
    StackPush(path, start);
}


static void showPath(Maze m, Stack path) {
    while (!StackIsEmpty(path)) {
        MazeMarkPath(m, StackPop(path));
    }
}


static void getNeighbors(Maze m, struct cell curr, Stack s, bool **visited, struct cell **prev) {
int dRow[] = {-1, 1, 0, 0};
int dCol[] = {0, 0, -1, 1};

    for (int i = 0; i < 4; i++) {
        struct cell next;
        next.row = curr.row + dRow[i];
        next.col = curr.col + dCol[i];
        
        if (next.row >= 0 && next.row < MazeHeight(m) &&
            next.col >= 0 && next.col < MazeWidth(m)) {
            
            if (!MazeIsWall(m, next) && !visited[next.row][next.col]) {
                prev[next.row][next.col] = curr;
                
                StackPush(s, next);        
            }
        }
    }    
}



