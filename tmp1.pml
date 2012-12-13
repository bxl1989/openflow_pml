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
			printf("%d\n",y);
		::timeout->
			printf("timeout\n");
		fi
	::cnt>=16->
		break	  
	od
}
proctype B(){
	int cnt;
	int y;
	int x;
	cnt = 0;
	y = 10;
	do
	::cnt<16->
		c2!y;
		cnt++;
		if
		::c1?x->
			printf("%d\n",x);
		::timeout->
			printf("timeout\n");
		fi
	::cnt>=16->
		break	  
	od
	
}

init{
	run A();	
	run B();
}
