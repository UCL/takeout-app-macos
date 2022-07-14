//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

struct stemmer;

extern struct stemmer * create_stemmer(void);
extern void free_stemmer(struct stemmer * z);

extern int stem(struct stemmer * z, char * b, int k);
