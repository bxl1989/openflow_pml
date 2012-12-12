chan c1 = [10] of {int};
chan c2 = [10] of {int};

proctype A(){
	int cnt;
	int x;
	int y;
	cnt = 0;
	x = 5;
	do
	::cnt<16->
		c1!x;
		cnt++;
		if
		::c2?y->
			printf();
	::else->
		
	  
	od
}
proctype B(){
	int cnt;
	int y;
	
}
proctype C(){

}
init{
	int x,y;
	int cnt;
	
}
