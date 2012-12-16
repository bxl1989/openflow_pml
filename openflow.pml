
mtype = {

/* ofp_type begin */
    /* Immutable messages. */
    OFPT_HELLO,               /* Symmetric message */
    OFPT_ERROR,               /* Symmetric message */
    OFPT_ECHO_REQUEST,        /* Symmetric message */
    OFPT_ECHO_REPLY,          /* Symmetric message */
    OFPT_VENDOR,              /* Symmetric message */

    /* Switch configuration messages. */
    OFPT_FEATURES_REQUEST,    /* Controller/switch message */
    OFPT_FEATURES_REPLY,      /* Controller/switch message */
    OFPT_GET_CONFIG_REQUEST,  /* Controller/switch message */
    OFPT_GET_CONFIG_REPLY,    /* Controller/switch message */
    OFPT_SET_CONFIG,          /* Controller/switch message */

    /* Asynchronous messages. */
    OFPT_PACKET_IN,           /* Async message */
    OFPT_FLOW_REMOVED,        /* Async message */
    OFPT_PORT_STATUS,         /* Async message */

    /* Controller command messages. */
    OFPT_PACKET_OUT,          /* Controller/switch message */
    OFPT_FLOW_MOD,            /* Controller/switch message */
    OFPT_PORT_MOD,            /* Controller/switch message */

    /* Statistics messages. */
    OFPT_STATS_REQUEST,       /* Controller/switch message */
    OFPT_STATS_REPLY,         /* Controller/switch message */

    /* Barrier messages. */
    OFPT_BARRIER_REQUEST,     /* Controller/switch message */
    OFPT_BARRIER_REPLY,       /* Controller/switch message */

    /* Queue Configuration messages. */
    OFPT_QUEUE_GET_CONFIG_REQUEST,  /* Controller/switch message */
    OFPT_QUEUE_GET_CONFIG_REPLY,     /* Controller/switch message */
/* ofp_type end */

    MACPKTT
};
typedef mac_packet_t{
	byte src;	/* Ethernet src address */
	byte dst;	/* Ethernet dst address */
};

#define OFPP_FLOOD 255

/* Why is this packet being sent to the controller? */
/* enum ofp_packet_in_reason */
#define    OFPR_NO_MATCH	0          /* No matching flow. */
#define    OFPR_ACTION          1	   /* Action explicitly output to controller. */

/* Packet received on port (datapath -> controller). */
typedef ofp_packet_in_t {
	byte in_port;
	mac_packet_t mac_packet 
};
/* enum ofp_action_type { */
mtype = {
    OFPAT_OUTPUT,           /* Output to switch port. */
    OFPAT_SET_VLAN_VID,     /* Set the 802.1q VLAN id. */
    OFPAT_SET_VLAN_PCP,     /* Set the 802.1q priority. */
    OFPAT_STRIP_VLAN,       /* Strip the 802.1q header. */
    OFPAT_SET_DL_SRC,       /* Ethernet source address. */
    OFPAT_SET_DL_DST,       /* Ethernet destination address. */
    OFPAT_SET_NW_SRC,       /* IP source address. */
    OFPAT_SET_NW_DST,       /* IP destination address. */
    OFPAT_SET_NW_TOS,       /* IP ToS (DSCP field, 6 bits). */
    OFPAT_SET_TP_SRC,       /* TCP/UDP source port. */
    OFPAT_SET_TP_DST,       /* TCP/UDP destination port. */
    OFPAT_ENQUEUE,          /* Output to queue.  */
    OFPAT_VENDOR 	    /* = 0xffff */
};

typedef ofp_action_header {
    byte type;                  /* One of OFPAT_*. */
    byte arg1;			/* output:port */
};

/* Send packet (controller -> datapath). */
typedef ofp_packet_out_t{
	byte in_port;
	ofp_action_header action; 
	mac_packet_t mac_packet
};
/* enum ofp_flow_mod_command { */
mtype = {
    OFPFC_ADD,              /* New flow. */
    OFPFC_MODIFY,           /* Modify all matching flows. */
    OFPFC_MODIFY_STRICT,    /* Modify entry strictly matching wildcards */
    OFPFC_DELETE,           /* Delete all matching flows. */
    OFPFC_DELETE_STRICT    /* Strictly match wildcards and priority. */
};

typedef ofp_match {
    byte in_port;          /* Input switch port. */
    byte dl_src; /* Ethernet source address. */
    byte dl_dst; /* Ethernet destination address. */
    byte dl_type;          /* Ethernet frame type. */
};
typedef ofp_flow_mod_t{
	ofp_match match;
	byte command;
	ofp_action_header action
};

#define SWITCH_NUM 1
#define HOST_NUM 2
#define BCAST_ADDR 255
#define QSIZE_SC 10
#define QSIZE_SH 10 

chan c2s_packet_out_chan[SWITCH_NUM] = [QSIZE_SC ] of {  ofp_packet_out_t }; 
		/* packet_out */
chan c2s_flow_mod_chan[SWITCH_NUM] = [QSIZE_SC ] of {  ofp_flow_mod_t }; 
		/* flow mod */
chan s2c_packet_in_chan = [QSIZE_SC ] of {  byte, ofp_packet_in_t }; 
chan h2s_chan[SWITCH_NUM] = [QSIZE_SH ] of { byte, mac_packet_t };
typedef s2h_chan_t{
	chan ports[HOST_NUM] = [QSIZE_SH ] of { mac_packet_t }
};
s2h_chan_t s2h_chan[SWITCH_NUM];
#define INTERACTION_TOTAL 4
proctype send_host(byte src; byte dst; byte switch_id; byte switch_port){	/* host source addr should be the same as its switch_port */
	mac_packet_t send_mac_packet;
	mac_packet_t recv_mac_packet;
	byte interaction_cnt;
	atomic{
	send_mac_packet.src = src;
	send_mac_packet.dst = dst;
	
	interaction_cnt = 0;
	};
	do
	::interaction_cnt < INTERACTION_TOTAL ->
	atomic{
		h2s_chan[switch_id] ! switch_port, send_mac_packet;
		interaction_cnt++;
	};
		do
		::s2h_chan[switch_id].ports[switch_port] ? recv_mac_packet->
			atomic{
			if
			::recv_mac_packet.dst == src->
				printf("Host %d receive reply successfully\n", src);
				break;
			::recv_mac_packet.dst != src->
				skip;
			fi
			};
		/* ::timeout->
			printf("Host %d not receive any reply\n", src);
			 break; */
		od
	::interaction_cnt >= INTERACTION_TOTAL->
		break
	od;
};
proctype recv_host(byte src; byte switch_id; byte switch_port){
	mac_packet_t send_mac_packet;
	mac_packet_t recv_mac_packet;
	do
	::s2h_chan[switch_id].ports[switch_port] ? recv_mac_packet ->
		if
		::recv_mac_packet.dst == src->
			send_mac_packet.src = src;
			send_mac_packet.dst = recv_mac_packet.src;
			h2s_chan[switch_id] ! switch_port, send_mac_packet;
		::recv_mac_packet.dst != src->
			skip;
		fi
	/*
	::timeout->
		break;
	*/	
	od
};
typedef flowtable_entry{
	ofp_match header_fields;
	byte counter;
	ofp_action_header action 	/* should be ofp_action_header actions[16]; 
				  	*  but in this model, application only sends output action 
				  	*  for flow mod to switch
					*/
	/* should have priority and timeout */
	  		
};
#define FLOWTABLE_ENTRY_NUM 10

typedef ports_used_ports{
	bool ports[HOST_NUM];
}
ports_used_ports ports_used[SWITCH_NUM];

proctype switch(byte switch_id){
mac_packet_t  in_mac_packet;
byte in_port;
ofp_packet_out_t ofp_packet_out;
ofp_flow_mod_t ofp_flow_mod;
byte flowtable_entry_total = 0;
byte flowtable_entry_cnt = 0;
chan action_exchange_chan = [1] of { ofp_action_header };
chan header_fields_exchange_chan = [1] of { ofp_match };
flowtable_entry flowtable[FLOWTABLE_ENTRY_NUM];
ofp_packet_in_t ofp_packet_in;
byte flood_port_cnt = 0;
do

	::h2s_chan[switch_id] ?  in_port, in_mac_packet ->
process_pkt:
		atomic{
		flowtable_entry_cnt = 0;
		do
		::flowtable_entry_cnt < flowtable_entry_total ->
			if
			::in_port == flowtable[flowtable_entry_cnt].header_fields.in_port &&
				in_mac_packet.src == flowtable[flowtable_entry_cnt].header_fields.dl_src &&
				in_mac_packet.dst == flowtable[flowtable_entry_cnt].header_fields.dl_dst ->
apply_actions:
				flowtable[flowtable_entry_cnt].counter++;
				if
				::flowtable[flowtable_entry_cnt].action.type == OFPAT_OUTPUT->
					s2h_chan[switch_id].ports[flowtable[flowtable_entry_cnt].action.arg1] !  in_mac_packet
					break
				::else->
					skip	
				fi;
				break;
			::else->
				flowtable_entry_cnt++;
			fi;

		::flowtable_entry_cnt>=flowtable_entry_total ->		/* not found in flowtable */
			ofp_packet_in.mac_packet.src = in_mac_packet.src;
			ofp_packet_in.mac_packet.dst = in_mac_packet.dst;
			ofp_packet_in.in_port = in_port;
			s2c_packet_in_chan !  switch_id, ofp_packet_in;
			break;
		 od; 
		 };
	::c2s_packet_out_chan[switch_id]? ofp_packet_out->
process_of_packet_out:
		atomic{
		if
		::ofp_packet_out.action.type ==  OFPAT_OUTPUT ->
			if
			::ofp_packet_out.action.arg1 != OFPP_FLOOD ->
				s2h_chan[switch_id].ports[ofp_packet_out.action.arg1] ! ofp_packet_out.mac_packet;
			::ofp_packet_out.action.arg1 == OFPP_FLOOD ->
				do
				:: flood_port_cnt < HOST_NUM ->
					if
					::ports_used[switch_id].ports[flood_port_cnt]==true && flood_port_cnt != ofp_packet_out.in_port ->
						s2h_chan[switch_id].ports[flood_port_cnt] ! ofp_packet_out.mac_packet;
					::else->
						skip;
					fi;
					flood_port_cnt++;
				:: flood_port_cnt >= HOST_NUM ->
					break;
				od
				
			fi
		::else->
			skip		
		fi
		};	

	::c2s_flow_mod_chan[switch_id] ? /*OFPT_FLOW_MOD,*/ ofp_flow_mod ->
		atomic{
		if
		:: ofp_flow_mod.command==OFPFC_ADD ->
process_of_flow_mod:
			flowtable[flowtable_entry_total].counter = 0;
			action_exchange_chan ! ofp_flow_mod.action;
			action_exchange_chan ? flowtable[flowtable_entry_total].action;
			header_fields_exchange_chan ! ofp_flow_mod.match;
			header_fields_exchange_chan ? flowtable[flowtable_entry_total].header_fields; 
			flowtable_entry_total++;
		::else->
			skip
		fi
		};

od
};

typedef mactable_entry {
	bool used;
	byte in_port;
	mac_packet_t mac_packet	
};
typedef mactable_row {
	mactable_entry column[HOST_NUM]
};
proctype controller(){
byte dpid;
ofp_packet_in_t ofp_packet_in;

mactable_row mactable[SWITCH_NUM]; 
mactable_entry new_entry;
chan mactable_entry_exchange_chan = [1] of { mactable_entry };

byte srcaddr, dstaddr;

mac_packet_t mac_packet;
chan mac_packet_exchange_chan = [1] of { mac_packet_t };
byte prt; 
ofp_match match;
ofp_action_header action;
chan ofp_action_header_exchange_chan = [1] of { ofp_action_header  };
ofp_flow_mod_t ofp_flow_mod;
ofp_packet_out_t ofp_packet_out;

packet_in:
	do
	:: s2c_packet_in_chan ? /* OFPT_PACKET_IN, */ dpid, ofp_packet_in->
do_l2_learning:
		atomic{
		mac_packet_exchange_chan ! ofp_packet_in.mac_packet;
		mac_packet_exchange_chan ? mac_packet;
		srcaddr = mac_packet.src;
		
		if
		::srcaddr != BCAST_ADDR -> 
			if
			/* mactable has an entry of srcaddr */
			::mactable[dpid].column[srcaddr].used == true->
				if
				::mactable[dpid].column[srcaddr].in_port!=ofp_packet_in.in_port-> 
				/* MAC has moved! */
					mactable[dpid].column[srcaddr].in_port = ofp_packet_in.in_port;
					/* new_entry.time =    timestamp ? */
					mac_packet_exchange_chan ! mac_packet;
					mac_packet_exchange_chan ? mactable[dpid].column[srcaddr].mac_packet;
				        goto forward_l2_packet	
				::else->
				        goto forward_l2_packet	
				fi
			/* mactable has no entry of srcaddr */
			::mactable[dpid].column[srcaddr].used == false->
				new_entry.used = true;
				new_entry.in_port = ofp_packet_in.in_port;
				/* new_entry.time =    timestamp ? */
				mac_packet_exchange_chan ! mac_packet;
				mac_packet_exchange_chan ? new_entry.mac_packet;
				mactable_entry_exchange_chan ! new_entry;
				mactable_entry_exchange_chan ? mactable[dpid].column[srcaddr];
				goto forward_l2_packet	
			fi
		::else->
			break
		fi;
forward_l2_packet:
		dstaddr = ofp_packet_in.mac_packet.dst;
		if
		::dstaddr != BCAST_ADDR && mactable[dpid].column[dstaddr].used == true ->
			prt = mactable[dpid].column[dstaddr].in_port ->
			if
			:: prt == ofp_packet_in.in_port ->
				goto send_openflow_OFPP_FLOOD; /* c2s_port_flood_chan[dpid] ! port */
			:: prt != ofp_packet_in.in_port ->
install_datapath_flow:
				/* flow */
				match.dl_src = mac_packet.src;
				match.dl_dst = mac_packet.dst;
				match.in_port =  ofp_packet_in.in_port;
		       		/* actions */
				action.type = OFPAT_OUTPUT;
				action.arg1 = prt;
				/* install_flow */
				ofp_flow_mod.command = OFPFC_ADD;
				
				ofp_action_header_exchange_chan	! action;
				ofp_action_header_exchange_chan ? ofp_flow_mod.action;
send_flow_command:
				c2s_flow_mod_chan[dpid] ! /* OFPT_FLOW_MOD,*/ ofp_flow_mod;
send_openflow_packet:
send_openflow_packet_out:

				mac_packet_exchange_chan ! mac_packet;
				mac_packet_exchange_chan ? ofp_packet_out.mac_packet;

				ofp_action_header_exchange_chan	! action;
				ofp_action_header_exchange_chan	? ofp_packet_out.action;
				ofp_packet_out.in_port = ofp_packet_in.in_port;

				c2s_packet_out_chan[dpid] ! /* OFPT_PACKET_OUT,*/ ofp_packet_out;					
			fi;
		::else->
send_openflow_OFPP_FLOOD:
			action.type = OFPAT_OUTPUT;
			action.arg1 = OFPP_FLOOD;
			mac_packet_exchange_chan ! mac_packet;
			mac_packet_exchange_chan ? ofp_packet_out.mac_packet;
			ofp_action_header_exchange_chan	! action;
			ofp_action_header_exchange_chan	? ofp_packet_out.action;
			ofp_packet_out.in_port = ofp_packet_in.in_port;
			c2s_packet_out_chan[dpid] ! /* OFPT_PACKET_OUT,*/ ofp_packet_out;					

		fi
		};		
	od;
datapath_leave:
datapath_join:
timer:
}

init{
	ports_used[0].ports[0] = true;
	ports_used[0].ports[1] = true;
	run controller();
	run switch(0);
	run send_host(0, 1, 0, 0);
	run recv_host(1, 0, 1);
}
