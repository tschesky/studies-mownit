#include <stdio.h>
#include <math.h>

int generate(char * inPath, char* outPath, int dataRows, double(*method)(int x));
double generator1();

int main(char* argv[], int argc){

    generate("in.txt", "out.txt", 1000, &generator1);
    return 0;
}

int generate(char * inPath, char* outPath, int dataRows, double(*method)(int x)){

    FILE * output = fopen(outPath, "w");
    FILE * input = fopen(inPath, "w");
    if(output == NULL || input == NULL){
        printf("Sorry, couldn't open one of the files, terminating generation now.\n");
        return 1;
    }

    int i;
    for(i = 0; i < dataRows; i++){
        fprintf(input, "%d\n", i);
    }

    for(i = 0; i < dataRows; i++){
        fprintf(output, "%f\n", method(i));
    }

    fclose(input);
    fclose(output);

    return 0;
}

double generator1(int x){

    double result;
    double var = (double)x;

    result = (pow(var/2, 3) ) - (2* pow(var, 2)) + (pow(-1, var))*(sin(var*2) * cos(var/4)) - 10*pow(var, 1)*sin(-var) + 3*(pow(var,4)) - 0.25 * pow(var, 5) * cos(var*20);

    return result;
}
