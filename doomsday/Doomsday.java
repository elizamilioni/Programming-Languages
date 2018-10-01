import java.util.*; 	
import java.io.*;

class Info {
	public char sign;
	public int x, y, time;

	Info(char s, int xi, int yi, int t) {
		sign = s;
		x = xi;
		y = yi;
		time = t;
	}
}

public class Doomsday {
	public static int M, N;
	public static char[][] myarr = new char[1001][1001];
	public static int[][] flag = new int[1001][1001];
	public static Queue<Info> myqueue = new LinkedList<Info>();
	public static int ans;
	
	public static void main(String[] args) throws IOException {
		int  i = 1 , j;
		try {
			BufferedReader input = new BufferedReader(new FileReader(args[0]));
			String s = input.readLine();
			M = s.length();
			myarr[0] = s.toCharArray();
			while((s = input.readLine()) != null && s.length() != 0) 
				myarr[i++] = s.toCharArray();	
			N = i;
			//System.out.println(N);
			for(i = 0; i < N; i++){
				for(j = 0; j < M; j++){
					flag[i][j] = 0;
					if(myarr[i][j] == '+' || myarr[i][j] == '-') {
						Info newInf = new Info(myarr[i][j], i, j, 0);
						myqueue.add(newInf);		
					}
				}
			}
			Info tmp = myqueue.poll();
			int ch=0;
			while(tmp != null){
				ch = check(tmp);
				if(ch == 1) break;
				tmp = myqueue.poll();
			}
			if(ans != 0) 
				System.out.println(ans+1);
			else 
				System.out.println("the world is saved");
			//BufferedWriter out = new BufferedWriter(new FileWriter("test.txt"));
			for(i = 0; i < N; i++){
				for(j = 0; j < M; j++)
					System.out.print(myarr[i][j]);	
					//out.write(myarr[i][j]);
				//out.write("\n");
				System.out.println();
			}
			System.out.println();
		
		} catch (FileNotFoundException e) {e.printStackTrace(); }
	}
	
	public static int check(Info inf) {
		char nots;
		if(inf.sign == '+') nots = '-';
		else nots = '+';
		// N = grammes (X) kai M = sthles (Y)
		if(inf.x < N && inf.y < M){
			if(inf.time > ans && ans != 0)
				return 1;

			if((inf.x-1) >= 0 && myarr[inf.x-1][inf.y] == nots) {
				//System.out.println("Mphka X-1");
				myarr[inf.x-1][inf.y] = '*';
				//System.out.println(myarr[inf.x-1][inf.y]);
				flag[inf.x-1][inf.y] = 1;
				flag[inf.x][inf.y] = 1;
				ans = inf.time;
			}
			if((inf.x+1) < N && myarr[inf.x+1][inf.y] == nots) {
				myarr[inf.x+1][inf.y] = '*';
				flag[inf.x+1][inf.y] = 1;
				flag[inf.x][inf.y] = 1;
				ans = inf.time;
			}
			if((inf.y-1) >= 0 && myarr[inf.x][inf.y-1] == nots) {
				myarr[inf.x][inf.y-1] = '*';
				flag[inf.x][inf.y-1] = 1;
				flag[inf.x][inf.y] = 1;
				ans = inf.time;
			}
			if((inf.y+1) < M && myarr[inf.x][inf.y+1] == nots) {
				myarr[inf.x][inf.y+1] = '*';
				flag[inf.x][inf.y+1] = 1;
				flag[inf.x][inf.y] = 1;
				ans = inf.time;
			}

			//an einai teleia push gia thn epomenh xronikh stigmh
			if((inf.x-1) >= 0 && myarr[inf.x-1][inf.y] == '.') {
				myarr[inf.x-1][inf.y] = inf.sign;
				//System.out.println("Mphka X-1");
				//System.out.println("ela" + myarr[inf.x-1][inf.y]);
				flag[inf.x-1][inf.y] = 1;
				Info infi = new Info(inf.sign, inf.x-1, inf.y, inf.time+1);
				myqueue.add(infi);		
			}
			if((inf.x+1) < N && myarr[inf.x+1][inf.y] == '.') {
				myarr[inf.x+1][inf.y] = inf.sign;
				flag[inf.x+1][inf.y] = 1;
				Info infi = new Info(inf.sign, inf.x+1, inf.y, inf.time+1);
				myqueue.add(infi);		
			}
			if((inf.y-1) >= 0 && myarr[inf.x][inf.y-1] == '.'){
				myarr[inf.x][inf.y-1] = inf.sign;
				//System.out.println("Mphka y-1");
				//System.out.println("ela" + myarr[inf.x][inf.y-1]);
				flag[inf.x][inf.y-1] = 1;
				Info infi = new Info(inf.sign, inf.x, inf.y-1, inf.time+1);
				myqueue.add(infi);		
			}
			if((inf.y+1) < M && myarr[inf.x][inf.y+1] == '.'){
				myarr[inf.x][inf.y+1] = inf.sign;
				flag[inf.x][inf.y+1] = 1;
				Info infi = new Info(inf.sign, inf.x, inf.y+1, inf.time+1);
				myqueue.add(infi);		
			}
			return 0;
		}
		return -1;
	}
}

