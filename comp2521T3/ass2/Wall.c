// COMP2521 25T3 - Assignment 2
// Implementation of the Wall ADT

#include <assert.h>
#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include "Wall.h"

struct wall {
	// TODO
	int height;
	int width;
	Colour **rocks;
	int numRocks;
};

static int compareRocks(const void *ptr1, const void *ptr2);
static char *getColourCode(Colour colour);

/**
 * Creates a new blank wall with the given dimensions
 */
Wall WallNew(int height, int width) {
    // 在堆上分配 Wall 结构体
    Wall w = malloc(sizeof(*w));
    if (w == NULL) {
		fprintf(stderr, "error: failed to allocate Wall\n");
        exit(EXIT_FAILURE);
	};

    w->height = height;
    w->width = width;
	w->numRocks = 0;

    // 分配每一行的指针
    w->rocks = malloc(height * sizeof(Colour *));
    if (w->rocks == NULL) {
        fprintf(stderr, "error: failed to allocate rocks\n");
        exit(EXIT_FAILURE);
    }

    // 为每一行分配 width 个 int，并初始化为 -1
    for (int i = 0; i < height; i++) {
        w->rocks[i] = malloc(width * sizeof(Colour));
        if (w->rocks[i] == NULL) {
            for (int j = 0; j < i; j++) free(w->rocks[j]);
            free(w->rocks);
            free(w);
            return NULL;
        }

        for (int j = 0; j < width; j++) {
            w->rocks[i][j] = -1;  // 表示没有岩石
        }
    }

    return w;
}

/**
 * Frees all memory allocated to the wall 
 */
void WallFree(Wall w) {
	for (int i = 0; i < w->height; i++) {
		free(w->rocks[i]);
	}
	free(w->rocks);
	free(w);
}

/**
 * Returns the height of the wall
 */
int WallHeight(Wall w) {
	// TODO
	return w->height;
}

/**
 * Returns the width of the wall
 */
int WallWidth(Wall w) {
	// TODO
	return w->width;
}

/**
 * Adds a rock to the wall
 * If there is already a rock at the given coordinates, replaces it
 * Assumes that the given row is between 1 and H - 1 (inclusive) and the
 * given column is between 1 and W - 1 (inclusive)
 */
void WallAddRock(Wall w, int row, int col, Colour colour) {
	// TODO
	w->rocks[row][col] = colour;
	w->numRocks++;
}

/**
 * Returns the number of rocks on the wall
 */
int WallNumRocks(Wall w) {
	// TODO
	return w->numRocks;
}

/**
 * Returns the colour of the rock at the given coordinates, or NONE if
 * there is no rock at those coordinates.
 */
Colour WallGetRockColour(Wall w, int row, int col) {
	// TODO
	return w->rocks[row][col];
}

/**
 * Stores all rocks on the wall in the given `rocks` array and returns
 * the number of rocks stored. Assumes that the array is at least as
 * large as the number of rocks on the wall.
 */
int WallGetAllRocks(Wall w, struct rock rocks[]) {
	// TODO
	int count = 0;
	for (int i = 0; i < w->height; i++) {
		for (int j = 0; j < w->width; j++) {
			if (w->rocks[i][j] != NONE) {
				rocks[count].row = i;
				rocks[count].col = j;
				rocks[count].colour = w->rocks[i][j];
				count++;
			}
			
		}
		 
	}
	
	return w->numRocks;
}

/**
 * Stores all rocks that are within a distance of `dist` from the given
 * coordinates in the given `rocks` array and returns the number of rocks
 * stored. Assumes that the array is at least as large as the number of
 * rocks on the wall.
 */
int WallGetRocksInRange(Wall w, int row, int col, int dist,
                        struct rock rocks[]) {
	// TODO
	int count = 0;
	for (int drow = -dist; drow < dist; drow++) {
		for (int dcol = -dist; dcol < dist; dcol++) {
			if (row + drow > 0 && row + drow < w->height 
			&& col + dcol > 0 && col + dcol < w->width 
			&& drow*drow + dcol*dcol <= dist && w->rocks[row+drow][col+dcol] != NONE) {
				rocks[count].row = row+drow;
				rocks[count].col = col+dcol;
				rocks[count].colour = w->rocks[row+drow][col+dcol];
				count++;
			}
		}
		
	}
	
	return count;
}

/**
 * Stores all rocks with the colour `colour` that are within a distance
 * of `dist` from the given coordinates in the given `rocks` array and
 * returns the number of rocks stored. Assumes that the array is at
 * least as large as the number of rocks on the wall.
 */
int WallGetColouredRocksInRange(Wall w, int row, int col, int dist,
                                Colour colour, struct rock rocks[]) {
	// TODO
	int count = 0;
	for (int drow = -dist; drow < dist; drow++) {
		for (int dcol = -dist; dcol < dist; dcol++) {
			if (row + drow > 0 && row + drow < w->height 
			&& col + dcol > 0 && col + dcol < w->width 
			&& drow*drow + dcol*dcol <= dist && w->rocks[row+drow][col+dcol] == colour) {
				rocks[count].row = row+drow;
				rocks[count].col = col+dcol;
				rocks[count].colour = w->rocks[row+drow][col+dcol];
				count++;
			}
		}
		
	}
	
	return count;
}

////////////////////////////////////////////////////////////////////////

/**
 * Prints the wall
 * NOTE: DO NOT MODIFY THIS FUNCTION! This function will work once
 *       WallGetAllRocks and all the functions above it work.
 */
void WallPrint(Wall w) {
	int height = WallHeight(w);
	int width = WallWidth(w);
	int numRocks = WallNumRocks(w);
	struct rock *rocks = malloc(numRocks * sizeof(struct rock));
	WallGetAllRocks(w, rocks);
	qsort(rocks, numRocks, sizeof(struct rock), compareRocks);

	int i = 0;
	for (int y = height; y >= 0; y--) {
		for (int x = 0; x <= width; x++) {
			if ((y == 0 || y == height) && (x == 0 || x % 5 == 0)) {
				printf("+ ");
			} else if ((x == 0 || x == width) && (y == 0 || y % 5 == 0)) {
				printf("+ ");
			} else if (y == 0 || y == height) {
				printf("- ");
			} else if (x == 0 || x == width) {
				printf("| ");
			} else if (i < numRocks && y == rocks[i].row && x == rocks[i].col) {
				char *colourCode = getColourCode(rocks[i].colour);
				printf("%so %s", colourCode, RESET);
				i++;
			} else {
				printf("\u00B7 ");
			}
		}
		printf("\n");
	}

	free(rocks);
}

static int compareRocks(const void *ptr1, const void *ptr2) {
	struct rock *r1 = (struct rock *)ptr1;
	struct rock *r2 = (struct rock *)ptr2;
	if (r1->row != r2->row) {
		return r2->row - r1->row;
	} else {
		return r1->col - r2->col;
	}
}

static char *getColourCode(Colour colour) {
	switch (colour) {
		case GREEN: return "\x1B[32m";
		case TEAL:  return "\x1B[96m";
		case PINK:  return "\x1B[95m";
		case RED:   return "\x1B[91m";
		default:    return "\x1B[0m";
	}
}

