// Implements a dictionary's functionality

#include <stdbool.h>

#include "dictionary.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <ctype.h>

// Represents a node in a hash table
typedef struct node
{
    char word[LENGTH + 1];
    struct node *next;
}
node;

// Number of buckets in hash table
const unsigned int N = 10000; // original default is 1

// Hash table
node *table[N];

// to count the number of words in dict
unsigned int word_count = 0;

// Returns true if word is in dictionary, else false
bool check(const char *word)
{
    // TODO
    int hash_value = hash(word);
    // cursor points to the head of linked list
    node *cursor = table[hash_value];

    // traverse the whole linked list, find is there the same word inside it.
    // return true if found, else return false
    while (cursor != NULL)
    {
        if (strcasecmp(cursor->word, word) == 0)
        {
            return true;
        }
        // if not yet found the word in dict, go to the next
        cursor = cursor->next;
    }
    return false;
}

// Hashes word to a number
unsigned int hash(const char *word)
{
    // TODO
    // Function should take a string and return an index
    // This hash function adds the ASCII values of all characters in     the word together
    long sum = 0;
    for (int i = 0; i < strlen(word); i++)
    {
        sum += tolower(word[i]);
    }
    return sum % N;
}

// open the dictionary file, read names and store them in hashtable
// return true if all loaded successful, else false
bool load(const char *dictionary)
{
    // TODO
    FILE *file = fopen(dictionary, "r");
    // return false if failed to open file
    if (file == NULL)
    {
        return false;
    }

    // the maximum length for each word
    char s[LENGTH + 1];
    while (fscanf(file, "%s", s) != EOF)
    {
        // create new node
        node *n = malloc(sizeof(node));
        if (n == NULL)
        {
            return false;
        }

        // copy string into (*n).word
        strcpy(n->word, s);
        n->next = NULL;
        int hash_value = hash(n->word);
        n->next = table[hash_value];
        table[hash_value] = n;
        word_count++;
    }
    fclose(file);
    return true;
}

// Returns number of words in dictionary if loaded, else 0 if not yet loaded
unsigned int size(void)
{
    // TODO
    if (word_count > 0)
    {
        return word_count;
    }
    return 0;
}

// Unloads dictionary from memory, returning true if successful, else false
bool unload(void)
{
    // TODO
    // traverse the hash table (N is the size of hashtable)
    for (int i = 0; i < N; i++)
    {
        //
        node *cursor = table[i];
        while (cursor != NULL)
        {
            node *tmp = cursor;
            cursor = cursor->next;
            free(tmp);
        }

        // this condition return true when cursor is on the last element in linked
        // list as well as the hash table
        // which means succefully unloaded all
        if (cursor == NULL && i == (N - 1))
        {
            return true;
        }
    }
    return false;
}

/* Attention:
don't need to declare head note in load function this time.
table[hash_value] represents the head node of every linked list in the hastable
by this way, we have every head node from different linked list in the table
when i use head = table[hash_value], this causes an error
because by this way, this head couldn't track all the linked list in the table */