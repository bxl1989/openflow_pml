
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
	int src;	/* Ethernet src address */
	int dst;	/* Ethernet dst address */
/*	int type	 Ethernet frame type */
};



/* Why is this packet being sent to the controller? */
/* enum ofp_packet_in_reason */
#define    OFPR_NO_MATCH	0          /* No matching flow. */
#define    OFPR_ACTION          1	   /* Action explicitly output to controller. */

/* Packet received on port (datapath -> controller). */
typedef ofp_packet_in_header {
/*    int buffer_id;      ID assigned by datapath. */
/*    short total_length;      Full lengthgth of frame. */
    short in_port;       /* Port on which frame was received. */
/*    byte reason;          Reason packet is being sent (one of OFPR_*) */
/*    byte data[0]         Ethernet frame, halfway through 32-bit word,
                               so the IP header is 32-bit aligned.  The
                               amount of data is inferred from the lengthgth
                               field in the header.  Because of padding,
                               offsetof(typedef ofp_packet_in, data) ==
                               sizeof(typedef ofp_packet_in) - 2. */
};
typedef ofp_packet_in_t {
	ofp_packet_in_header packet_in_header;
	mac_packet_t mac_packet 
};
/* Action header that is common to all actions.  The lengthgth includes the
 * header and any padding used to make the action 64-bit aligned.
 * NB: The lengthgth of an action *must* always be a multiple of eight. */
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
    short type;                  /* One of OFPAT_*. */
/*    short length;                    Length of action, including this
                                       header.  This is the lengthgth of action,
                                       including any padding to make it
                                       64-bit aligned. */
    short arg1;			/* output:port */
/*    short arg2			 output:max_length */
};

/* Send packet (controller -> datapath). */
typedef ofp_packet_out_header {
/*    int buffer_id;            ID assigned by datapath (-1 if none). */
    short in_port;             /* Packet's input port (OFPP_NONE if none). */
/*    short actions_length;          Size of action array in bytes. */
    /* ofp_action_header actions[0];  Actions. */
    /* byte data[0]; */        /* Packet data.  The lengthgth is inferred
                                     from the lengthgth field in the header.
                                     (Only meaningful if buffer_id == -1.) */
};
typedef ofp_packet_out_t{
	ofp_packet_out_header packet_out_header;
	ofp_action_header action;
	/* ofp_action_header actions[16];  actions_length ? */
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
/*    int wildcards;         Wildcard fields. */
    short in_port;          /* Input switch port. */
    int dl_src; /* Ethernet source address. */
    int dl_dst; /* Ethernet destination address. */
/*    short dl_vlan;           Input VLAN id. */
/*    byte dl_vlan_pcp;        Input VLAN priority. */
    short dl_type;          /* Ethernet frame type. */
/*    byte nw_tos;             IP ToS (actually DSCP field, 6 bits). */
/*    byte nw_proto;           IP protocol or lower 8 bits of
                                * ARP opcode. */
/*    int nw_src;            IP source address. */
/*    int nw_dst;            IP destination address. */
/*    short tp_src;            TCP/UDP source port. */
/*    short tp_dst;            TCP/UDP destination port. */
};
#define OFP_DEFAULT_PRIORITY 0

typedef ofp_flow_mod_header {
    ofp_match match;      /* Fields to match */
    /* uint64_t cookie;              Opaque controller-issued identifier. */

    /* Flow actions. */
    short command;             /* One of OFPFC_*. */
/*    short idle_timeout;         Idle time before discarding (seconds). */
/*    short hard_timeout;         Max time before discarding (seconds). */
/*    short pri;             Priority level of flow entry. */
/*    int buffer_id;            Buffered packet to apply to (or -1).
                                     Not meaningful for OFPFC_DELETE*. */
/*    short out_port;             For OFPFC_DELETE* commands, require
                                     matching entries to include this as an
                                     output port.  A value of OFPP_NONE
                                     indicates no restriction. */
/*    short flags;                One of OFPFF_*. */
    /* ofp_action_header actions[0];  The action lengthgth is inferred
                                            from the lengthgth field in the
                                            header. */
};
typedef ofp_flow_mod_t{
	ofp_flow_mod_header flow_mod_header;
	ofp_action_header action
};

#define SWITCH_NUM 1
#define HOST_NUM 2
#define BCAST_ADDR 0


typedef dp_ofp_packet_in_t{
	int dpid;
	ofp_packet_in_t packet_in
};
typedef dp_ofp_packet_out_t{
	int dpid;
	ofp_packet_out_t packet_out
};
typedef dp_ofp_flow_mod_t{
	int dpid;
	ofp_flow_mod_t flow_mod
};
typedef dp_ofp_port_flood_t{
	int dpid;
	/* ofp_port_flood_t port_flood */
};
typedef prt_mac_packet_t{
	int port;
	mac_packet_t mac_packet
};

#define QSIZE_SC 10
#define QSIZE_SH 10 

chan c2s_packet_out_chan[SWITCH_NUM] = [QSIZE_SC ] of { /* mtype, */ dp_ofp_packet_out_t /* ofpacket */}; 
		/* packet_out */
chan c2s_flow_mod_chan[SWITCH_NUM] = [QSIZE_SC ] of { /* mtype, */ dp_ofp_flow_mod_t /* ofpacket */ }; 
		/* flow mod */
chan c2s_port_flood_chan[SWITCH_NUM] = [QSIZE_SC ] of { /* mtype, */ dp_ofp_port_flood_t /* ofpacket */ }; 
		/* OFPP_FLOOD */
chan s2c_packet_in_chan = [QSIZE_SC ] of { /* mtype, */ dp_ofp_packet_in_t }; 
/* chan s2c_packet_in_chan[SWITCH_NUM] = [SWITCH_NUM * QSIZE_SC ] of {int, ofp_packet_in, mac_packet; */
		/* only packet_in is delivered in this application */
chan h2s_chan[SWITCH_NUM] = [QSIZE_SH ] of { /* mtype, */ prt_mac_packet_t };
typedef s2h_chan_t{
	chan hosts[HOST_NUM] = [QSIZE_SH ] of { /* mtype, */ mac_packet_t }
};
s2h_chan_t s2h_chan[SWITCH_NUM];
#define INTERACTION_TOTAL 4
proctype normal_host(int src; int dst; int switch_id; int switch_port){	/* host source addr should be the same as its switch_port */
	prt_mac_packet_t prt_mac_packet;
	mac_packet_t recv_mac_packet;
	int interaction_cnt;
	prt_mac_packet.port = switch_port;
	prt_mac_packet.mac_packet.src = src;
	prt_mac_packet.mac_packet.dst = dst;
	
	interaction_cnt = 0;
	do
	::interaction_cnt < INTERACTION_TOTAL ->
		h2s_chan[switch_id] ! /* MACPKTT, */ prt_mac_packet;
		interaction_cnt++;
		if
		::s2h_chan[switch_id].hosts[switch_port] ? /* MACPKTT, */ recv_mac_packet->
			if
			::recv_mac_packet.dst == src->
				printf("Host %d receive reply successfully\n", src);
			fi
		::timeout->
			printf("Host %d not receive any reply\n", src);
			break;
		fi
	::interaction_cnt >= INTERACTION_TOTAL->
		break
	od;
};

typedef flowtable_entry{
	ofp_match header_fields;
	int counter;
	ofp_action_header action 	/* should be ofp_action_header actions[16]; 
				  	*  but in this model, application only sends output action 
				  	*  for flow mod to switch
					*/
	/* should have priority and timeout */
	  		
};
#define FLOWTABLE_ENTRY_NUM 10
proctype switch(int switch_id){
prt_mac_packet_t  prt_mac_packet;
dp_ofp_packet_out_t dp_ofp_packet_out;
dp_ofp_flow_mod_t dp_ofp_flow_mod;
dp_ofp_port_flood_t dp_ofp_port_flood;
int flowtable_entry_total = 0;
int flowtable_entry_cnt = 0;
chan action_exchange_chan = [1] of {ofp_action_header};
chan header_fields_exchange_chan = [1] of {ofp_match};
flowtable_entry flowtable[FLOWTABLE_ENTRY_NUM];
dp_ofp_packet_in_t dp_ofp_packet_in;
do

	::h2s_chan[switch_id] ? /* MACPKTT,*/ prt_mac_packet ->
process_pkt:
		flowtable_entry_cnt = 0; 
		do
		::flowtable_entry_cnt < flowtable_entry_total ->
			if
			/* ::flowtable[flowtable_entry_cnt].wilcards 
			*	goto apply_actions */
			::prt_mac_packet.port == flowtable[flowtable_entry_cnt].header_fields.in_port &&
				prt_mac_packet.mac_packet.src == flowtable[flowtable_entry_cnt].header_fields.dl_src &&
				prt_mac_packet.mac_packet.dst == flowtable[flowtable_entry_cnt].header_fields.dl_dst ->
apply_actions:
				flowtable[flowtable_entry_cnt].counter++;
				if
				::flowtable[flowtable_entry_cnt].action.type == OFPAT_OUTPUT->
					s2h_chan[switch_id].hosts[flowtable[flowtable_entry_cnt].action.arg1] ! /*MACPKTT,*/ prt_mac_packet.mac_packet
				  	
				fi;
				break;
			::else->
				flowtable_entry_cnt++;
			fi;

		::flowtable_entry_cnt>=flowtable_entry_total ->		/* not found in flowtable */
			dp_ofp_packet_in.dpid = switch_id;	/* use switch_id to indicate datapath id */
								/*  this means switch_cnt in controller */
			/* dp_ofp_packet_in.packet_in.mac_packet = prt_mac_packet.mac_packet; */
			dp_ofp_packet_in.packet_in.mac_packet.src = prt_mac_packet.mac_packet.src;
			dp_ofp_packet_in.packet_in.mac_packet.dst = prt_mac_packet.mac_packet.dst;
			dp_ofp_packet_in.packet_in.mac_packet.type = prt_mac_packet.mac_packet.type;
			dp_ofp_packet_in.packet_in.packet_in_header.in_port = prt_mac_packet.port;
		        dp_ofp_packet_in.packet_in.packet_in_header.reason = OFPR_NO_MATCH;
			s2c_packet_in_chan ! /* OFPT_PACKET_IN, */ dp_ofp_packet_in;
			break;
		 od; 

	::c2s_packet_out_chan[switch_id]? /*OFPT_PACKET_OUT,*/ dp_ofp_packet_out->
process_of_packet_out:
		if
		::dp_ofp_packet_out.packet_out.action.type ==  OFPAT_OUTPUT->
			s2h_chan[switch_id].hosts[dp_ofp_packet_out.packet_out.action.arg1] ! /* MACPKTT,*/ dp_ofp_packet_out.packet_out.mac_packet
			
		fi	

	::c2s_flow_mod_chan[switch_id] ? /*OFPT_FLOW_MOD,*/ dp_ofp_flow_mod ->
		if
		:: dp_ofp_flow_mod.flow_mod.flow_mod_header.command==OFPFC_ADD ->
process_of_flow_mod:
			flowtable[flowtable_entry_total].counter = 0;

			action_exchange_chan ! dp_ofp_flow_mod.flow_mod.action;
			action_exchange_chan ? flowtable[flowtable_entry_total].action;
			header_fields_exchange_chan ! dp_ofp_flow_mod.flow_mod.flow_mod_header.match;
			header_fields_exchange_chan ? flowtable[flowtable_entry_total].header_fields; 
			flowtable_entry_total++
		fi
/*
	::c2s_port_flood_chan[switch_id]?OFPT_PORT_FLOOD, dp_ofp_port_flood -> 
		skip
*/
od
};

typedef mactable_entry {
	bool used;
	byte inport;
	int time;
	mac_packet_t mac_packet	
};
typedef mactable_row {
	mactable_entry column[HOST_NUM]
};
proctype controller(){
dp_ofp_packet_in_t dp_ofp_packet_in;
mactable_row mactable[SWITCH_NUM]; 
mactable_entry new_entry;
chan mactable_entry_exchange_chan = [1] of { mactable_entry };
int srcaddr, dstaddr;
int switch_cnt;
mac_packet_t mac_packet;
chan mac_packet_exchange_chan = [1] of { mac_packet_t };
ofp_packet_in_header packet_in_header;
chan ofp_packet_in_header_chan = [1] of { ofp_packet_in_header };
int prt; 
ofp_match match;
ofp_action_header action;
chan ofp_action_header_exchange_chan = [1] of { ofp_action_header  };
dp_ofp_flow_mod_t dp_ofp_flow_mod;
dp_ofp_packet_out_t dp_ofp_packet_out;
packet_in:
	do
	:: s2c_packet_in_chan ? /* OFPT_PACKET_IN, */ dp_ofp_packet_in->
do_l2_learning:
		mac_packet_exchange_chan ! dp_ofp_packet_in.packet_in.mac_packet;
		mac_packet_exchange_chan ? mac_packet;
		ofp_packet_in_header_chan ! dp_ofp_packet_in.packet_in.packet_in_header;
		ofp_packet_in_header_chan ? packet_in_header;
		srcaddr = dp_ofp_packet_in.packet_in.mac_packet.src;
		switch_cnt = dp_ofp_packet_in.dpid;
		if
		::srcaddr != BCAST_ADDR -> 
			if
			/* mactable has an entry of srcaddr */
			::mactable[switch_cnt].column[srcaddr].used == true->
				if
				::mactable[switch_cnt].column[srcaddr].inport!=dp_ofp_packet_in.packet_in.packet_in_header.in_port-> 
				/* MAC has moved! */
					new_entry.inport = dp_ofp_packet_in.packet_in.packet_in_header.in_port;
					/* new_entry.time =    timestamp ? */
					mac_packet_exchange_chan ! dp_ofp_packet_in.packet_in.mac_packet;
					mac_packet_exchange_chan ? new_entry.mac_packet;
					mactable_entry_exchange_chan ! new_entry;
					mactable_entry_exchange_chan ? mactable[switch_cnt].column[srcaddr];
				        goto forward_l2_packet	
					
				fi
			/* mactable has no entry of srcaddr */
			::mactable[switch_cnt].column[srcaddr].used == false->
				new_entry.inport = dp_ofp_packet_in.packet_in.packet_in_header.in_port;
				/* new_entry.time =    timestamp ? */
				mac_packet_exchange_chan ! dp_ofp_packet_in.packet_in.mac_packet;
				mac_packet_exchange_chan ? new_entry.mac_packet;
				mactable_entry_exchange_chan ! new_entry;
				mactable_entry_exchange_chan ? mactable[switch_cnt].column[srcaddr];
				goto forward_l2_packet	
			fi
		fi;
forward_l2_packet:
		dstaddr = dp_ofp_packet_in.packet_in.mac_packet.dst;
		if
		::dstaddr != BCAST_ADDR && mactable[switch_cnt].column[dstaddr].used == true ->
			prt = mactable[switch_cnt].column[dstaddr].inport ->
			if
			:: prt == dp_ofp_packet_in.packet_in.packet_in_header.in_port ->
				goto send_openflow_OFPP_FLOOD; /* c2s_port_flood_chan[switch_cnt] ! port */
			:: prt != dp_ofp_packet_in.packet_in.packet_in_header.in_port ->
install_datapath_flow:
				/* flow */
				match.dl_src = mac_packet.src;
				match.dl_dst = mac_packet.dst;
				match.dl_type = mac_packet.type;
				match.in_port =  packet_in_header.in_port;
		       		/* actions */
				action.type = OFPAT_OUTPUT;
				action.length = 8;
				action.arg1 = prt;
				action.arg2 = 0;
				/* install_flow */
				dp_ofp_flow_mod.dpid = switch_cnt;	/* dpid */
				dp_ofp_flow_mod.flow_mod.flow_mod_header.command = OFPFC_ADD;
				dp_ofp_flow_mod.flow_mod.flow_mod_header.pri = OFP_DEFAULT_PRIORITY;
				
				ofp_action_header_exchange_chan	! action;
				ofp_action_header_exchange_chan ? dp_ofp_flow_mod.flow_mod.action;
send_flow_command:
				c2s_flow_mod_chan[switch_cnt] ! /* OFPT_FLOW_MOD,*/ dp_ofp_flow_mod;
send_openflow_packet:
send_openflow_packet_out:
				dp_ofp_packet_out.dpid = switch_cnt;

				mac_packet_exchange_chan ! mac_packet;
				mac_packet_exchange_chan ? dp_ofp_packet_out.packet_out.mac_packet;

				ofp_action_header_exchange_chan	! action;
				ofp_action_header_exchange_chan	? dp_ofp_packet_out.packet_out.action;
				dp_ofp_packet_out.packet_out.packet_out_header.in_port = packet_in_header.in_port;

				c2s_packet_out_chan[switch_cnt] ! /* OFPT_PACKET_OUT,*/ dp_ofp_packet_out;					
			fi;
		::else->
send_openflow_OFPP_FLOOD:
			skip		
		fi

			
	od;
datapath_leave:
datapath_join:
timer:
}

init{
	run controller();
	run switch(0);
	run normal_host(0, 1, 0, 0);
	run normal_host(1, 0, 0, 1);
}
