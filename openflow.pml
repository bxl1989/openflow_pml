#define qsize_sc 256
#define qsize_sh 256 

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

/* Header on all OpenFlow packets. */
typedef ofp_header {
    byte version;    /* OFP_VERSION. */
    byte type;       /* One of the OFPT_ constants. */
    short length;    /* Length including this ofp_header. */
    int xid        /* Transaction id associated with this packet.
                           Replies use the same id as was in the request
                           to facilitate pairing. */
};


/* Why is this packet being sent to the controller? */
/* enum ofp_packet_in_reason */
#define    OFPR_NO_MATCH	0          /* No matching flow. */
#define    OFPR_ACTION          1	   /* Action explicitly output to controller. */

/* Packet received on port (datapath -> controller). */
typedef ofp_packet_in_header {
    ofp_header header;
    int buffer_id;     /* ID assigned by datapath. */
    short total_len;     /* Full length of frame. */
    short in_port;       /* Port on which frame was received. */
    byte reason;         /* Reason packet is being sent (one of OFPR_*) */
/*    byte data[0]         Ethernet frame, halfway through 32-bit word,
                               so the IP header is 32-bit aligned.  The
                               amount of data is inferred from the length
                               field in the header.  Because of padding,
                               offsetof(typedef ofp_packet_in, data) ==
                               sizeof(typedef ofp_packet_in) - 2. */
};
typedef ofp_packet_in_t {
	ofp_packet_in_header packet_in_header;
	mac_packet_t mac_packet 
};
/* Action header that is common to all actions.  The length includes the
 * header and any padding used to make the action 64-bit aligned.
 * NB: The length of an action *must* always be a multiple of eight. */
enum ofp_action_type {
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
    OFPAT_VENDOR = 0xffff
};

/* Action typedefure for OFPAT_OUTPUT, which sends packets out 'port'.
 * When the 'port' is the OFPP_CONTROLLER, 'max_len' indicates the max
 * number of bytes to send.  A 'max_len' of zero means no bytes of the
 * packet should be sent.*/
typedef ofp_action_output {
    short type;                  /* OFPAT_OUTPUT. */
    short len;                   /* Length is 8. */
    short port;                  /* Output port. */
    short max_len;               /* Max length to send to controller. */
};

/* The VLAN id is 12 bits, so we can use the entire 16 bits to indicate
 * special conditions.  All ones is used to match that no VLAN id was
 * set. */
#define OFP_VLAN_NONE      0xffff

/* Action typedefure for OFPAT_SET_VLAN_VID. */
typedef ofp_action_vlan_vid {
    short type;                  /* OFPAT_SET_VLAN_VID. */
    short len;                   /* Length is 8. */
    short vlan_vid;              /* VLAN id. */
};

/* Action typedefure for OFPAT_SET_VLAN_PCP. */
typedef ofp_action_vlan_pcp {
    short type;                  /* OFPAT_SET_VLAN_PCP. */
    short len;                   /* Length is 8. */
    byte vlan_pcp;               /* VLAN priority. */
};

/* Action typedefure for OFPAT_SET_DL_SRC/DST. */
typedef ofp_action_dl_addr {
    short type;                  /* OFPAT_SET_DL_SRC/DST. */
    short len;                   /* Length is 16. */
    byte dl_addr[OFP_ETH_ALEN];  /* Ethernet address. */
};

/* Action typedefure for OFPAT_SET_NW_SRC/DST. */
typedef ofp_action_nw_addr {
    short type;                  /* OFPAT_SET_TW_SRC/DST. */
    short len;                   /* Length is 8. */
    int nw_addr;               /* IP address. */
};

/* Action typedefure for OFPAT_SET_TP_SRC/DST. */
typedef ofp_action_tp_port {
    short type;                  /* OFPAT_SET_TP_SRC/DST. */
    short len;                   /* Length is 8. */
    short tp_port;               /* TCP/UDP port. */
};

/* Action typedefure for OFPAT_SET_NW_TOS. */
typedef ofp_action_nw_tos {
    short type;                  /* OFPAT_SET_TW_SRC/DST. */
    short len;                   /* Length is 8. */
    byte nw_tos;                 /* IP ToS (DSCP field, 6 bits). */
};

/* Action header for OFPAT_VENDOR. The rest of the body is vendor-defined. */
typedef ofp_action_vendor_header {
    short type;                  /* OFPAT_VENDOR. */
    short len;                   /* Length is a multiple of 8. */
    int vendor;                /* Vendor ID, which takes the same form
                                       as in "typedef ofp_vendor_header". */
};
typedef ofp_action_header {
    short type;                  /* One of OFPAT_*. */
    short len;                   /* Length of action, including this
                                       header.  This is the length of action,
                                       including any padding to make it
                                       64-bit aligned. */
};

/* Send packet (controller -> datapath). */
typedef ofp_packet_out_header {
    ofp_header header;
    int buffer_id;           /* ID assigned by datapath (-1 if none). */
    short in_port;             /* Packet's input port (OFPP_NONE if none). */
    short actions_len;         /* Size of action array in bytes. */
    /* ofp_action_header actions[0];  Actions. */
    /* byte data[0]; */        /* Packet data.  The length is inferred
                                     from the length field in the header.
                                     (Only meaningful if buffer_id == -1.) */
};
typedef ofp_packet_out_t{
	ofp_packet_out_header packet_out_header;
	ofp_action_header actions[16];  /* actions_len ? */
	mac_packet_t mac_packet
}
/* enum ofp_flow_mod_command { */
#define    OFPFC_ADD,              /* New flow. */
#define    OFPFC_MODIFY,           /* Modify all matching flows. */
#define    OFPFC_MODIFY_STRICT,    /* Modify entry strictly matching wildcards */
#define    OFPFC_DELETE,           /* Delete all matching flows. */
#define    OFPFC_DELETE_STRICT    /* Strictly match wildcards and priority. */
/* enum ofp_flow_mod_flags { */
#define    OFPFF_SEND_FLOW_REM = 1 << 0,  /* Send flow removed message when flow
      		                              * expires or is deleted. */
#define    OFPFF_CHECK_OVERLAP = 1 << 1,  /* Check for overlapping entries first. */
#define    OFPFF_EMERG         = 1 << 2   /* Remark this is for emergency. */


/* Flow wildcards. */
/* enum ofp_flow_wildcards { */
#define    OFPFW_IN_PORT   1 << 0,  /* Switch input port. */
#define    OFPFW_DL_VLAN   1 << 1,  /* VLAN id. */
#define    OFPFW_DL_SRC    1 << 2,  /* Ethernet source address. */
#define    OFPFW_DL_DST    1 << 3,  /* Ethernet destination address. */
#define    OFPFW_DL_TYPE   1 << 4,  /* Ethernet frame type. */
#define    OFPFW_NW_PROTO  1 << 5,  /* IP protocol. */
#define    OFPFW_TP_SRC    1 << 6,  /* TCP/UDP source port. */
#define    OFPFW_TP_DST    1 << 7,  /* TCP/UDP destination port. */

    /* IP source address wildcard bit count.  0 is exact match, 1 ignores the
     * LSB, 2 ignores the 2 least-significant bits, ..., 32 and higher wildcard
     * the entire field.  This is the *opposite* of the usual convention where
     * e.g. /24 indicates that 8 bits (not 24 bits) are wildcarded. */
#define    OFPFW_NW_SRC_SHIFT  8,
#define    OFPFW_NW_SRC_BITS  6,
#define    OFPFW_NW_SRC_MASK  ((1 << OFPFW_NW_SRC_BITS) - 1) << OFPFW_NW_SRC_SHIFT,
#define    OFPFW_NW_SRC_ALL  32 << OFPFW_NW_SRC_SHIFT,

    /* IP destination address wildcard bit count.  Same format as source. */
#define    OFPFW_NW_DST_SHIFT  14,
#define    OFPFW_NW_DST_BITS  6,
#define    OFPFW_NW_DST_MASK  ((1 << OFPFW_NW_DST_BITS) - 1) << OFPFW_NW_DST_SHIFT,
#define    OFPFW_NW_DST_ALL  32 << OFPFW_NW_DST_SHIFT,

#define    OFPFW_DL_VLAN_PCP  1 << 20,  /* VLAN priority. */
#define    OFPFW_NW_TOS  1 << 21,  /* IP ToS (DSCP field, 6 bits). */

    /* Wildcard all fields. */
#define    OFPFW_ALL  ((1 << 22) - 1)

typedef ofp_match {
    int wildcards;        /* Wildcard fields. */
    short in_port;          /* Input switch port. */
    byte dl_src[OFP_ETH_ALEN]; /* Ethernet source address. */
    byte dl_dst[OFP_ETH_ALEN]; /* Ethernet destination address. */
    short dl_vlan;          /* Input VLAN id. */
    byte dl_vlan_pcp;       /* Input VLAN priority. */
    short dl_type;          /* Ethernet frame type. */
    byte nw_tos;            /* IP ToS (actually DSCP field, 6 bits). */
    byte nw_proto;          /* IP protocol or lower 8 bits of
                                * ARP opcode. */
    int nw_src;           /* IP source address. */
    int nw_dst;           /* IP destination address. */
    short tp_src;           /* TCP/UDP source port. */
    short tp_dst;           /* TCP/UDP destination port. */
};

typedef ofp_flow_mod_header {
    ofp_header header;
    ofp_match match;      /* Fields to match */
    uint64_t cookie;             /* Opaque controller-issued identifier. */

    /* Flow actions. */
    short command;             /* One of OFPFC_*. */
    short idle_timeout;        /* Idle time before discarding (seconds). */
    short hard_timeout;        /* Max time before discarding (seconds). */
    short priority;            /* Priority level of flow entry. */
    int buffer_id;           /* Buffered packet to apply to (or -1).
                                     Not meaningful for OFPFC_DELETE*. */
    short out_port;            /* For OFPFC_DELETE* commands, require
                                     matching entries to include this as an
                                     output port.  A value of OFPP_NONE
                                     indicates no restriction. */
    short flags;               /* One of OFPFF_*. */
    /* ofp_action_header actions[0];  The action length is inferred
                                            from the length field in the
                                            header. */
}
typedef ofp_flow_mod_t{
	ofp_flow_mod_header flow_mod_header;
	ofp_action_header actions
};

#define SWITCH_NUM 1
#define HOST_NUM 2
#define BCAST_ADDR -1
typedef mac_packet_t{
	int src;
	
};
typedef mactable_entry{
	bool used;
	byte inport;
	int time;
	mac_packet packet	
};


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
	ofp_port_flood_t port_flood
};
typedef prt_mac_packet_t{
	int port;
	mac_packet_t packet
};

chan c2s_packet_out_chan[SWITCH_NUM] = [qsize_sc] of { mtype, dp_ofp_packet_out_t /* ofpacket */}; 
		/* packet_out */
chan c2s_flow_mod_chan[SWITCH_NUM] = [qsize_sc] of { mtype, dp_ofp_flow_mod_t /* ofpacket */ }; 
		/* flow mod */
chan c2s_port_flood_chan[SWITCH_NUM] = [qsize_sc] of { mtype, dp_ofp_port_flood_t /* ofpacket */ }; 
		/* OFPP_FLOOD */
chan s2c_packet_in_chan = [SWITCH_NUM * qsize_sc] of { mtype, dp_ofp_packet_in_t }; 
/* chan s2c_packet_in_chan[SWITCH_NUM] = [SWITCH_NUM * qsize_sc] of {int, ofp_packet_in, mac_packet}; */
		/* only packet_in is delivered in this application */
chan h2s_chan = [qsize_sh] of { mtype, mac_packet} 
chan s2h_chan = [qsize_sh] of { mtype, mac_packet}



typedef flowtable_entry{
	ofp_match header_fields;
	int counter;
	  		
};
flowtable_entry flowtable[];


proctype host(){

}
proctype switch(int switch_id){
prt_mac_packet_t  prt_mac_packet;
dp_ofp_packet_out_t dp_ofp_packet_out;
dp_ofp_flow_mod_t dp_ofp_flow_mod;
dp_ofp_port_flood_t dp_ofp_port_flood;
do

process_pkt:
	::h2s_chan?MACPKTT, prt_mac_packet ->
		
process_of:
	::c2s_packet_out_chan[switch_id]?OFPT_PACKET_OUT, dp_ofp_packet_out->
	::c2s_flow_mod_chan[switch_id]?OFPT_FLOW_MOD, dp_ofp_flow_mod ->
	::c2s_port_flood_chan[switch_id]?OFPT_PORT_FLOOD, dp_ofp_port_flood ->
od
}


proctype controller(){
dp_ofp_packet_in_t dp_ofp_packet_in;
mactable_entry mactable[SWITCH_NUM][HOST_NUM]; 
mactable_entry new_entry;
int srcaddr, dstaddr;
int switch_cnt;
packet_in:
	do
	:: s2c_packet_in_chan ? OFPT_PACKET_IN, dp_ofp_packet_in->
do_l2_learning:
		srcaddr = dp_ofp_packet_in.packet_in.mac_packet.src;
		switch_cnt = dp_ofp_packet_in.dpid;
		if
		::srcaddr != BCAST_ADDR -> 
			if
			/* mactable has an entry of srcaddr */
			::mactable[switch_cnt][srcaddr].used == true->
				if
				::mactable[switch_cnt][srcaddr].inport!=dp_ofp_packet_in.packet_in.packet_in_header.in_port-> 
				/* MAC has moved! */
					new_entry.inport = dp_ofp_packet_in.packet_in.packet_in_header.in_port;
					/* new_entry.time =    timestamp ? */
					new_entry.packet = dp_ofp_packet_in.packet_in.mac_packet;
					mactable[switch_cnt][srcaddr] = new_entry;
				        goto forward_l2_packet	
					
				fi
			/* mactable has no entry of srcaddr */
			::mactable[switch_cnt][srcaddr].used == false->
				new_entry.inport = dp_ofp_packet_in.packet_in.packet_in_header.in_port;
				/* new_entry.time =    timestamp ? */
				new_entry.packet = dp_ofp_packet_in.packet_in.mac_packet;
				mactable[switch_cnt][srcaddr] = new_entry;
				goto forward_l2_packet	
			fi
		fi;
forward_l2_packet:
		dstaddr = dp_ofp_packet_in.packet_in.mac_packet.dst;
		if
		::dstaddr != BCAST_ADDR && mactable[switch_cnt][dstaddr].used == true ->
			prt = mactable[switch_cnt][dstaddr].inport ->
			if
			:: port == packet_in_hdr.inport ->
				c2s_port_flood_chan[switch_cnt] ! port
			:: port != packet_in_hdr.inport ->
				/* flow */
				
		       		/* actions */
				/* install_flow */	
			fi
		fi

			
	od;
datapath_leave:
datapath_join:
timer:
}

init{

}