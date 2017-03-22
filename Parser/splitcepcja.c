#define _GNU_SOURCE

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <assert.h>

#define MAXSIZE 256

char** str_split(char*, const char);
char* strdup(const char *);

int main(int argc, char const *argv[]) {
	if(argc != 2){
		printf("Niepoprawna ilosc argumentow\n");
		exit(EXIT_FAILURE);
	}

	FILE * input;
	FILE * output1;
	FILE * output2;

	if((input = fopen(argv[1],"r"))== NULL){
		printf("Nie moge otworzyc pliku\n%s\n",strerror(errno));
		exit(EXIT_FAILURE);
	}
	if((output1 = fopen("input.txt","w"))==NULL){
		printf("Nie moge otworzyc pliku\n%s\n",strerror(errno));
		exit(EXIT_FAILURE);
	}
	if((output2 = fopen("output.txt","w"))==NULL){
		printf("Nie moge otworzyc pliku\n%s\n",strerror(errno));
		exit(EXIT_FAILURE);
	}

	int n=1;
	char c;
	char *tab = (char*)malloc(sizeof(char)*MAXSIZE);
	int i;
	char ** results;
	char ** results2;
	char ** results3;
	int k;
	char* more = NULL;
	while((c = fgetc(input))!=EOF){
		for (int j = 0; j < MAXSIZE*n; j++) {
			tab[j] = 0;
		}
		i = 0;
		while(c != '\n'){
			tab[i] = c;
			c = fgetc(input);
			i++;
			if (i>MAXSIZE) {
				n++;
				more = (char*)realloc(tab,sizeof(char)*MAXSIZE*n);
				if (more!=NULL){
					tab = more;
				}
			}
		}
		//printf("%s\n",tab);

		results = str_split(tab,';');
		results2 = str_split(results[0], ',');
		results3 = str_split(results[1], ',');
        int k =0;
        printf("Splitted!\n");
        for(int i = 0; i <5 ; i++){
            printf("%s, ", results2[i]);
            fwrite(results2[i],sizeof(char),strlen(results2[i]),output1);
            fwrite("\t",sizeof(char),sizeof(char),output1);

        }
        printf("\n");
        for(int i = 0; i < 1 ; i++){
            printf("%s, ", results3[i]);
            fwrite(results3[i],sizeof(char),strlen(results3[i]),output2);
            fwrite("\t",sizeof(char),sizeof(char),output2);

        }
        printf("\n");
        printf("KUPA");

        fwrite("\n",sizeof(char),sizeof(char),output1);
		fwrite("\n",sizeof(char),sizeof(char),output2);
	}

	fclose(input);
	fclose(output1);
	fclose(output2);
	return 0;
}

char** str_split(char* a_str, const char a_delim){

    char** result    = 0;
    size_t count     = 0;
    char* tmp        = a_str;
    char* last_comma = 0;
    char delim[2];
    delim[0] = a_delim;
    delim[1] = 0;

    /* Count how many elements will be extracted. */
    while (*tmp)
    {
        if (a_delim == *tmp)
        {
            count++;
            last_comma = tmp;
        }
        tmp++;
    }

    /* Add space for trailing token. */
    count += last_comma < (a_str + strlen(a_str) - 1);

    /* Add space for terminating null string so caller
       knows where the list of returned strings ends. */
    count++;

    result = malloc(sizeof(char*) * count);

    if (result)
    {
        size_t idx  = 0;
        char* token = strtok(a_str, delim);

        while (token)
        {
            assert(idx < count);
            *(result + idx++) = strdup(token);
            token = strtok(0, delim);
        }
        assert(idx == count - 1);
        *(result + idx) = 0;
    }

    return result;
}
char *strdup(const char *str)
{
    int n = strlen(str) + 1;
    char *dup = malloc(n);
    if(dup)
    {
        strcpy(dup, str);
    }
    return dup;
}
