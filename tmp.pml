typedef MSG_HDR {
	int header;
};
typedef MSG {
	MSG_HDR header;
	int body;
};
chan c1[1] = [16] of { MSG };
chan c2[1] = [16] of { MSG };

proctype A(int id){
	int cnt;
	MSG x,y;
	cnt = 0;
	x.header.header = 5;
	/* x.body = 10; */
	do
	::cnt<16->
		c1[id]!x;
		cnt++;
		if
		::c2[id]?y->
			printf("A recv header:%d body:%d\n",y.header.header, y.body);
		::timeout->
			printf("timeout\n");
			break;
		fi
	::cnt>=16->
		break	  
	od
}
proctype B(int id){
	MSG x,y;
	y.header.header = 1;
	/* y.body = 2; */
	do
	::c1[id]?x->
		printf("B recv header:%d body:%d\n", x.header.header, x.body);
		c2[id]!y;
	::timeout->
		break;
	od
	
}
chan c = [10] of {byte};
proctype C(){
	byte x;
	do
	::c?x->skip
	od
}
init{
	
	run A(0);
	run B(0);
	run C();
}
