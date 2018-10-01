#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <stdint.h>
#include <inttypes.h>

int64_t gcd(int64_t a, int64_t b) {
    if (a == 0) return b;
    return gcd(b%a, a);
}

int64_t lcmofnumbers(int64_t a, int64_t b) {	
    return (a/gcd(a,b))*b;
}

int main(int argc, char const *argv[]) {
    int64_t min,temp;
    int i,position = 0,N;
    min = INT_MAX;
    FILE *myFile;
    myFile = fopen(argv[1], "r");
    if (myFile == NULL) {
        perror("Error opening file");
        return(-1);
    }
    //read first integer
    fscanf(myFile, "%d", &N);

    //give the dynamic size at the necessary array.
    int*  days  = (int*) malloc(N* sizeof(int));
    int64_t* lcm_min_max = (int64_t*) malloc(N* sizeof(int64_t));
    int64_t* lcm_max_min = (int64_t*) malloc(N* sizeof(int64_t));

    //read the rest integers
    for (i=0; i<N; i++) 
        fscanf(myFile, "%d", &days[i]);	
    
    lcm_min_max[0] = days[0];
    for (i=1; i<N; i++)
        lcm_min_max[i] = lcmofnumbers(lcm_min_max[i-1], days[i]);	
    
    lcm_max_min[N-1] = days[N-1];
    for(i=(N-2); i>=0; i--)
        lcm_max_min[i] = lcmofnumbers(lcm_max_min[i+1], days[i]);
    
    for(i=0; i<N; i++){
        if ( i==0 )
            temp = lcm_max_min[1];
        if ( i == (N-1) )
            temp = lcm_min_max[N-2];
        if (i!=0 && i!=(N-1))
 			temp = lcmofnumbers(lcm_min_max[i-1], lcm_max_min[i+1]);
        if (temp < min){
            min = temp;
            position = i+1;
        }
    }
    printf("%" PRId64, min);
    if(lcmofnumbers(lcm_max_min[1],days[0]) == min)
        printf(" 0 \n");
    else
        printf(" %d \n", position);
    fclose(myFile);
    return 0;
}
