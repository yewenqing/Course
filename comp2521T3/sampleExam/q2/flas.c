
#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include "list.h"


struct node *flas(struct node *l) {
    if (l == NULL) return listNew();   // 返回空链表

    struct node *result;
    struct node *start = l;

    int maxLen = 0;
    int count = 1;            // tmp 的长度
    int pre = l->value;


    struct node *curr = l->next;

    // 特殊：单元素也算长度 1，但题目似乎要求“至少两个节点才算递增”？
    // 如果需要单节点不算，可以把这段逻辑去掉

    while (curr) {

        if (pre < curr->value) {
            // continue chain
            count++;

        } else {
            // break the chain
            start = curr;
            count = 1;
        }

        if (count > maxLen) {
            maxLen = count;
            result = start;
        }

        pre = curr->value;
        curr = curr->next;
    }


    // 如果 maxLen < 2，则不存在递增子串，返回空链表
    if (maxLen < 2) {
        return NULL;
    }

    return result;
}

