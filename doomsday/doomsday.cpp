#include<iostream>
#include<fstream>
#include<queue>
#include<cstdlib>

using namespace std;
int myarr[1001][1001];
int N,M;
queue<int> myqueue;
int sin=int('+');
int plin=int('-');
int teleia=int('.');
int emp=int('X');
int ast=int('*');
int nots,flag[1001][1001], ans=0,flagaki=0;

void pushnew(int s, int x, int y, int t) {
	myarr[x][y]=s;
	myqueue.push(s);
	myqueue.push(x);
	myqueue.push(y);
	myqueue.push(t);
}

int check(int s,int x,int y,int t){
	if(s==sin)
		nots=plin;
	else
		nots=sin;
	if(x<=N && y<=M){ 
		//an exei hdh erthei h sunteleia eksuphretw stoixeio apo epomenh xronikh stigmh 
		if(t==ans) flagaki=1;
		
		if(t>ans && ans!=0) return 1;
		//an einai antitheto prosimo irthe i sunteleia
		if(myarr[x-1][y] == nots && (x-1)>=0 ) {
			myarr[x-1][y]=ast;
			flag[x-1][y]=1;
			flag[x][y]=1;
			ans=t;
		}
		if(myarr[x+1][y] ==nots && (x+1)<=N) {
			myarr[x+1][y]=ast;
            flag[x+1][y]=1;
			flag[x][y]=1;
			ans=t;
		} 
		if(myarr[x][y-1] == nots  && (y-1)>=0) {
			myarr[x][y-1]=ast;
            flag[x][y-1]=1;
			flag[x][y]=1;
            ans=t;
		}
		if (myarr[x][y+1] == nots && (y+1)<=M) {
			myarr[x][y+1]=ast;
            flag[x][y+1]=1;
			flag[x][y]=1;
            ans=t;
		}
		//an einai teleia push gia thn epomenh xronikh stigmh
        if(myarr[x-1][y] == teleia && (x-1)>=0 ) {
            flag[x-1][y]=1; 
			pushnew(s,x-1,y,t+1);
		}
        if( myarr[x+1][y] ==teleia && (x+1)<=N ){
            flag[x+1][y]=1;
			pushnew(s,x+1,y,t+1);
		}
        if( myarr[x][y-1] == teleia  && (y-1)>=0){
			flag[x][y-1]=1;
            pushnew(s,x,y-1,t+1);
        }
		if( myarr[x][y+1] == teleia && (y+1)<=M ){
            flag[x][y+1]=1;
			pushnew(s,x,y+1,t+1);
		}
		return 0;
	}
	return -1;
}

int main(int argc, char **argv) {
	ifstream myfile(argv[1]);
	int i=0,j=0,stoixeio;
	
	stoixeio=myfile.get();
	myarr[i][j]=stoixeio;
	while (stoixeio!= EOF) {	
		M=j;
		flag[i][j]=0;
		if (myarr[i][j] != teleia && myarr[i][j] != emp  && myarr[i][j] != sin && myarr[i][j] != plin) {
			i++; 
			j=-1;
		}
		if(myarr[i][j]==sin || myarr[i][j]==plin) {
			myqueue.push(myarr[i][j]);
			myqueue.push(i);
			myqueue.push(j);
			myqueue.push(0);	
		}
		j++;	
		stoixeio=myfile.get();
		myarr[i][j] = stoixeio;
	}
	N=i;
	int ch;
	while(!myqueue.empty()) {
		int sgn = myqueue.front();
		myqueue.pop();
		int tetm=myqueue.front();
		myqueue.pop();
		int tetag=myqueue.front();
		myqueue.pop();
		int t=myqueue.front();
		myqueue.pop();
		ch=check(sgn,tetm,tetag,t);
		if(ch==1)
			break;
	}
	
	if(flagaki && ans!=0 ) 	cout<<ans+1<<endl;
	else cout << "the world is saved" <<endl;
	for (i=0;i<N;i++){
                for(j=0;j<M;j++)
			        cout<< char(myarr[i][j]);
                cout<<endl;
	}
	cout<<endl;
}

