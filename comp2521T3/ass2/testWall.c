// COMP2521 25T3 - Assignment 2
// Main program for testing the Wall ADT

// !!! DO NOT MODIFY THIS FILE !!!

#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "Wall.h"
#include "wallReader.h"

#define MAX 8192

static void processArgs(int argc, char *argv[], char **wallFilename);
static void showUsage(char *progName);
static void showWelcomeMessage(void);
static bool getCommand(char *buf);
static char **tokenize(char *s, int *ntokens);
static void freeTokens(char **tokens);
static void showHelp(void);

static void runWallDimensions(Wall w, int argc, char *argv[]);
static void runWallAddRock(Wall w, int argc, char *argv[]);
static void runWallNumRocks(Wall w, int argc, char *argv[]);
static void runWallGetRockColour(Wall w, int argc, char *argv[]);
static void runWallGetAllRocks(Wall w, int argc, char *argv[]);
static void runWallGetRocksInRange(Wall w, int argc, char *argv[]);
static void runWallGetColouredRocksInRange(Wall w, int argc, char *argv[]);
static void runWallPrint(Wall w, int argc, char *argv[]);

static void showCmdHelp(void);

static void checkRocks(Wall w, struct rock *rocks, int numRocks);
static void printRocksOnWall(Wall w, struct rock *rocks, int numRocks,
                             int row, int col);
static int compareRocks(const void *ptr1, const void *ptr2);
static char *getColourCode(Colour colour);
static char *colourToStr(Colour colour);

////////////////////////////////////////////////////////////////////////

typedef struct command {
	char  *code;
	void (*fn)(Wall, int, char **);
	char  *argHint;
	char  *helpMsg;
} Command;

static Command COMMANDS[] = {
	{"d", runWallDimensions,
	 "",
	 "get the dimensions of the wall"},
	{"+", runWallAddRock,
	 "<row> <col> <colour>",
	 "add a rock to the wall"},
	{"n", runWallNumRocks,
	 "",
	 "get the number of rocks on the wall"},
	{"g", runWallGetRockColour,
	 "<row> <col>",
	 "get the colour of a rock"},
	{"a", runWallGetAllRocks,
	 "",
	 "get all the rocks on the wall"},
	{"r", runWallGetRocksInRange,
	 "<row> <col> <dist>",
	 "get all the rocks within a certain distance"},
	{"c", runWallGetColouredRocksInRange,
	 "<row> <col> <dist> <colour>",
	 "get all the rocks of a particular colour within a certain distance"},
	{"p", runWallPrint,
	 "",
	 "print out the wall"},
	// Meta-commands
	{"?", NULL, "", "show this message"},
	{"q", NULL, "", "quit"},
};

////////////////////////////////////////////////////////////////////////

static Command *currCommand = NULL;

int main(int argc, char *argv[]) {
	char *wallFilename;
	processArgs(argc, argv, &wallFilename);

	Wall w = readWall(wallFilename);

	showWelcomeMessage();

	bool done = false;
	char cmd[MAX + 1] = {0};

	while (!done && getCommand(cmd)) {
		int ntokens = 0;
		char **tokens = tokenize(cmd, &ntokens);
		if (ntokens == 0) {
			free(tokens);
			continue;
		}
		
		char *cmdName = tokens[0];

		// Meta-commands
		if (strcmp(cmdName, "?") == 0) {
			showHelp();
		} else if (strcmp(cmdName, "q") == 0) {
			done = true;
		
		// Actual commands
		} else {
			bool validCommand = false;

			int numCommands = sizeof(COMMANDS) / sizeof(Command);
			for (int i = 0; i < numCommands; i++) {
				if (strcmp(cmdName, COMMANDS[i].code) == 0) {
					validCommand = true;
					currCommand = &COMMANDS[i];
					COMMANDS[i].fn(w, ntokens, tokens);
				}
			}

			if (!validCommand) {
				printf("Unknown command '%s'\n", cmdName);
			}
		}
		freeTokens(tokens);
	}

	WallFree(w);
}

static void processArgs(int argc, char *argv[], char **wallFilename) {
	if (argc != 2) {
		showUsage(argv[0]);
		exit(EXIT_FAILURE);
	}

	*wallFilename = argv[1];
}

static void showUsage(char *progName) {
	printf("Usage: %s <wall data file>\n", progName);
}

static void showWelcomeMessage(void) {
	printf("Wall ADT Tester\n");
	printf("Enter ? to see the list of commands.\n");
}

static bool getCommand(char *buf) {
	printf("> ");
	if (fgets(buf, MAX, stdin) != NULL) {
		int len = strlen(buf);
		if (len > 0 && buf[len - 1] != '\n') {
			buf[len] = '\n';
			buf[len + 1] = '\0';
		}
		return true;
	} else {
		return false;
	}
}

static char **tokenize(char *s, int *ntokens) {
	char *separators = " \t\r\n";
	*ntokens = 0;

	char **tokens = calloc((strlen(s) + 1), sizeof(*tokens));
	assert(tokens != NULL);

	while (*s != '\0') {
		s += strspn(s, separators);

		if (*s == '\0') {
			break;
		}

		size_t length = strcspn(s, separators);

		char *token = strndup(s, length);
		assert(token != NULL);
		s += length;

		tokens[*ntokens] = token;
		(*ntokens)++;
	}

	tokens[*ntokens] = NULL;

	tokens = realloc(tokens, (*ntokens + 1) * sizeof(*tokens));
	assert(tokens != NULL);

	return tokens;
}

static void freeTokens(char **tokens) {
	for (int i = 0; tokens[i] != NULL; i++) {
		free(tokens[i]);
	}
	free(tokens);
}

static void showHelp(void) {
	printf("Commands:\n");
	int numCommands = sizeof(COMMANDS) / sizeof(Command);
	for (int i = 0; i < numCommands; i++) {
		printf("%5s %-30s %s\n", COMMANDS[i].code, COMMANDS[i].argHint,
		       COMMANDS[i].helpMsg);
	}
	printf("\n");
}

////////////////////////////////////////////////////////////////////////
// Commands

static void runWallDimensions(Wall w, int argc, char *argv[]) {
	if (argc != 1) {
		showCmdHelp();
		return;
	}

	int height = WallHeight(w);
	int width = WallWidth(w);
	printf("Height: %d, Width: %d\n", height, width);
}

static void runWallAddRock(Wall w, int argc, char *argv[]) {
	if (argc != 4) {
		showCmdHelp();
		return;
	}

	char s[MAX];
	snprintf(s, MAX, "%s %s %s", argv[1], argv[2], argv[3]);
	int row;
	int col;
	int colour;
	char c;
	if (sscanf(s, "%d %d %d%c", &row, &col, &colour, &c) != 3) {
		showCmdHelp();
		return;
	}
	if (row <= 0 || row >= WallHeight(w)) {
		printf("Invalid row number\n");
		return;
	}
	if (col <= 0 || col >= WallWidth(w)) {
		printf("Invalid column number\n");
		return;
	}
	if (colour < 0 || colour >= NUM_COLOURS) {
		printf("Invalid colour\n");
		return;
	}

	WallAddRock(w, row, col, colour);
	printf("Rock added!\n");
}

static void runWallNumRocks(Wall w, int argc, char *argv[]) {
	if (argc != 1) {
		showCmdHelp();
		return;
	}

	int numRocks = WallNumRocks(w);
	printf("There are %d rocks\n", numRocks);
}

static void runWallGetRockColour(Wall w, int argc, char *argv[]) {
	if (argc != 3) {
		showCmdHelp();
		return;
	}

	char s[MAX];
	snprintf(s, MAX, "%s %s", argv[1], argv[2]);
	int row;
	int col;
	char c;
	if (sscanf(s, "%d %d%c", &row, &col, &c) != 2) {
		showCmdHelp();
		return;
	}
	if (row < 0 || row > WallHeight(w)) {
		printf("Invalid row number\n");
		return;
	}
	if (col < 0 || col > WallWidth(w)) {
		printf("Invalid column number\n");
		return;
	}

	Colour colour = WallGetRockColour(w, row, col);
	if (colour == NONE) {
		printf("No rock at (%d, %d)\n", row, col);
	} else {
		printf("%s rock\n", colourToStr(colour));
	}
}

static void runWallGetAllRocks(Wall w, int argc, char *argv[]) {
	if (argc != 1) {
		showCmdHelp();
		return;
	}

	int totalRocks = WallNumRocks(w);
	struct rock *rocks = malloc(totalRocks * sizeof(struct rock));
	assert(rocks != NULL);
	int numRocks = WallGetAllRocks(w, rocks);

	checkRocks(w, rocks, numRocks);

	printf("All rocks:\n\n");
	printRocksOnWall(w, rocks, numRocks, -1, -1);
	free(rocks);
}

static void runWallGetRocksInRange(Wall w, int argc, char *argv[]) {
	if (argc != 4) {
		showCmdHelp();
		return;
	}

	char s[MAX];
	snprintf(s, MAX, "%s %s %s", argv[1], argv[2], argv[3]);
	int row;
	int col;
	int dist;
	char c;
	if (sscanf(s, "%d %d %d%c", &row, &col, &dist, &c) != 3) {
		showCmdHelp();
		return;
	}
	if (row < 0 || row > WallHeight(w)) {
		printf("Invalid row number\n");
		return;
	}
	if (col < 0 || col > WallWidth(w)) {
		printf("Invalid column number\n");
		return;
	}
	if (dist < 0) {
		printf("Invalid dist\n");
		return;
	}

	int totalRocks = WallNumRocks(w);
	struct rock *rocks = malloc(totalRocks * sizeof(struct rock));
	assert(rocks != NULL);
	int numRocks = WallGetRocksInRange(w, row, col, dist, rocks);

	checkRocks(w, rocks, numRocks);

	printf("Rocks within %d units of (%d, %d):\n\n", dist, row, col);
	printRocksOnWall(w, rocks, numRocks, row, col);
	free(rocks);
}

static void runWallGetColouredRocksInRange(Wall w, int argc, char *argv[]) {
	if (argc != 5) {
		showCmdHelp();
		return;
	}

	char s[MAX];
	snprintf(s, MAX, "%s %s %s %s", argv[1], argv[2], argv[3], argv[4]);
	int row;
	int col;
	int dist;
	int colour;
	char c;
	if (sscanf(s, "%d %d %d %d%c", &row, &col, &dist, &colour, &c) != 4) {
		showCmdHelp();
		return;
	}
	if (row < 0 || row > WallHeight(w)) {
		printf("Invalid row number\n");
		return;
	}
	if (col < 0 || col > WallWidth(w)) {
		printf("Invalid column number\n");
		return;
	}
	if (dist < 0) {
		printf("Invalid dist\n");
		return;
	}
	if (colour < 0 || colour >= NUM_COLOURS) {
		printf("Invalid colour\n");
		return;
	}

	int totalRocks = WallNumRocks(w);
	struct rock *rocks = malloc(totalRocks * sizeof(struct rock));
	assert(rocks != NULL);
	int numRocks = WallGetColouredRocksInRange(w, row, col, dist,
	                                           colour, rocks);

	checkRocks(w, rocks, numRocks);

	printf("%s rocks within %d units of (%d, %d):\n\n",
	       colourToStr(colour), dist, row, col);
	printRocksOnWall(w, rocks, numRocks, row, col);
	free(rocks);
}

static void runWallPrint(Wall w, int argc, char *argv[]) {
	if (argc != 1) {
		showCmdHelp();
		return;
	}

	WallPrint(w);
}

static void showCmdHelp(void) {
	printf("Usage: %s %s\n", currCommand->code, currCommand->argHint);
}

////////////////////////////////////////////////////////////////////////

static void checkRocks(Wall w, struct rock *rocks, int numRocks) {
	int height = WallHeight(w);
	int width = WallWidth(w);
	for (int i = 0; i < numRocks; i++) {
		struct rock rock = rocks[i];
		if (rock.row <= 0 || rock.row >= height || rock.col <= 0 ||
				rock.col >= width) {
			printf("Error: rock at (%d, %d) is out of bounds\n", rock.row,
			       rock.col);
		}
	}
}

static void printRocksOnWall(Wall w, struct rock *rocks, int numRocks,
                             int row, int col) {
	int height = WallHeight(w);
	int width = WallWidth(w);
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

static char *colourToStr(Colour colour) {
	switch (colour) {
		case GREEN: return "Green";
		case TEAL:  return "Teal";
		case PINK:  return "Pink";
		case RED:   return "Red";
		default:    return "Unknown";
	}
}

////////////////////////////////////////////////////////////////////////

