/* Port numbering.  Physical ports are numbered starting from 1. */
enum ofp_port {
    /* Maximum number of physical switch ports. */
    OFPP_MAX = 0xff00,

    /* Fake output "ports". */
    OFPP_IN_PORT    = 0xfff8,  /* Send the packet out the input port.  This
                                  virtual port must be explicitly used
                                  in order to send back out of the input
                                  port. */
    OFPP_TABLE      = 0xfff9,  /* Perform actions in flow table.
                                  NB: This can only be the destination
                                  port for packet-out messages. */
    OFPP_NORMAL     = 0xfffa,  /* Process with normal L2/L3 switching. */
    OFPP_FLOOD      = 0xfffb,  /* All physical ports except input port and
                                  those disabled by STP. */
    OFPP_ALL        = 0xfffc,  /* All physical ports except input port. */
    OFPP_CONTROLLER = 0xfffd,  /* Send to controller. */
    OFPP_LOCAL      = 0xfffe,  /* Local openflow "port". */
    OFPP_NONE       = 0xffff   /* Not associated with a physical port. */
};
/* OFPT_HELLO.  This message has an empty body, but implementations must
 * ignore any data included in the body, to allow for future extensions. */
typedef ofp_hello {
    ofp_header header;
};

#define OFP_DEFAULT_MISS_SEND_LEN   128

/* enum ofp_config_flags */
    /* Handling of IP fragments. */
#define    OFPC_FRAG_NORMAL   0  /* No special handling for fragments. */
#define    OFPC_FRAG_DROP     1  /* Drop fragments. */
#define    OFPC_FRAG_REASM    2  /* Reassemble (only if OFPC_IP_REASM set). */
#define    OFPC_FRAG_MASK     3

/* Switch configuration. */
typedef ofp_switch_config {
    ofp_header header;
    short flags;             /* OFPC_* flags. */
    short miss_send_len;     /* Max bytes of new flow that datapath should
                                   send to the controller. */
};

/* Capabilities supported by the datapath. */
i/* enum ofp_capabilities */
#define    OFPC_FLOW_STATS     1 << 0  /* Flow statistics. */
#define    OFPC_TABLE_STATS    1 << 1  /* Table statistics. */
#define    OFPC_PORT_STATS     1 << 2  /* Port statistics. */
#define    OFPC_STP            1 << 3  /* 802.1d spanning tree. */
#define    OFPC_RESERVED       1 << 4  /* Reserved, must be zero. */
#define    OFPC_IP_REASM       1 << 5  /* Can reassemble IP fragments. */
    OFPC_QUEUE_STATS    = 1 << 6,  /* Queue statistics. */
    OFPC_ARP_MATCH_IP   = 1 << 7   /* Match IP addresses in ARP pkts. */

/* Flags to indicate behavior of the physical port.  These flags are
 * used in ofp_phy_port to describe the current configuration.  They are
 * used in the ofp_port_mod message to configure the port's behavior.
 */
enum ofp_port_config {
    OFPPC_PORT_DOWN    = 1 << 0,  /* Port is administratively down. */

    OFPPC_NO_STP       = 1 << 1,  /* Disable 802.1D spanning tree on port. */
    OFPPC_NO_RECV      = 1 << 2,  /* Drop all packets except 802.1D spanning
                                     tree packets. */
    OFPPC_NO_RECV_STP  = 1 << 3,  /* Drop received 802.1D STP packets. */
    OFPPC_NO_FLOOD     = 1 << 4,  /* Do not include this port when flooding. */
    OFPPC_NO_FWD       = 1 << 5,  /* Drop packets forwarded to port. */
    OFPPC_NO_PACKET_IN = 1 << 6   /* Do not send packet-in msgs for port. */
};

/* Current state of the physical port.  These are not configurable from
 * the controller.
 */
enum ofp_port_state {
    OFPPS_LINK_DOWN   = 1 << 0, /* No physical link present. */

    /* The OFPPS_STP_* bits have no effect on switch operation.  The
     * controller must adjust OFPPC_NO_RECV, OFPPC_NO_FWD, and
     * OFPPC_NO_PACKET_IN appropriately to fully implement an 802.1D spanning
     * tree. */
    OFPPS_STP_LISTEN  = 0 << 8, /* Not learning or relaying frames. */
    OFPPS_STP_LEARN   = 1 << 8, /* Learning but not relaying frames. */
    OFPPS_STP_FORWARD = 2 << 8, /* Learning and relaying frames. */
    OFPPS_STP_BLOCK   = 3 << 8, /* Not part of spanning tree. */
    OFPPS_STP_MASK    = 3 << 8  /* Bit mask for OFPPS_STP_* values. */
};

/* Features of physical ports available in a datapath. */
enum ofp_port_features {
    OFPPF_10MB_HD    = 1 << 0,  /* 10 Mb half-duplex rate support. */
    OFPPF_10MB_FD    = 1 << 1,  /* 10 Mb full-duplex rate support. */
    OFPPF_100MB_HD   = 1 << 2,  /* 100 Mb half-duplex rate support. */
    OFPPF_100MB_FD   = 1 << 3,  /* 100 Mb full-duplex rate support. */
    OFPPF_1GB_HD     = 1 << 4,  /* 1 Gb half-duplex rate support. */
    OFPPF_1GB_FD     = 1 << 5,  /* 1 Gb full-duplex rate support. */
    OFPPF_10GB_FD    = 1 << 6,  /* 10 Gb full-duplex rate support. */
    OFPPF_COPPER     = 1 << 7,  /* Copper medium. */
    OFPPF_FIBER      = 1 << 8,  /* Fiber medium. */
    OFPPF_AUTONEG    = 1 << 9,  /* Auto-negotiation. */
    OFPPF_PAUSE      = 1 << 10, /* Pause. */
    OFPPF_PAUSE_ASYM = 1 << 11  /* Asymmetric pause. */
};

/* Description of a physical port */
typedef ofp_phy_port {
    short port_no;
    byte hw_addr[OFP_ETH_ALEN];
    char name[OFP_MAX_PORT_NAME_LEN]; /* Null-terminated */

    int config;        /* Bitmap of OFPPC_* flags. */
    int state;         /* Bitmap of OFPPS_* flags. */

    /* Bitmaps of OFPPF_* that describe features.  All bits zeroed if
     * unsupported or unavailable. */
    int curr;          /* Current features. */
    int advertised;    /* Features being advertised by the port. */
    int supported;     /* Features supported by the port. */
    int peer;          /* Features advertised by peer. */
};

/* Switch features. */
typedef ofp_switch_features {
    typedef ofp_header header;
    uint64_t datapath_id;   /* Datapath unique ID.  The lower 48-bits are for
                               a MAC address, while the upper 16-bits are
                               implementer-defined. */

    int n_buffers;     /* Max packets buffered at once. */

    byte n_tables;       /* Number of tables supported by datapath. */
    byte pad[3];         /* Align to 64-bits. */

    /* Features. */
    int capabilities;  /* Bitmap of support "ofp_capabilities". */
    int actions;       /* Bitmap of supported "ofp_action_type"s. */

    /* Port info.*/
    typedef ofp_phy_port ports[0];  /* Port definitions.  The number of ports
                                      is inferred from the length field in
                                      the header. */
};

/* What changed about the physical port */
enum ofp_port_reason {
    OFPPR_ADD,              /* The port was added. */
    OFPPR_DELETE,           /* The port was removed. */
    OFPPR_MODIFY            /* Some attribute of the port has changed. */
};

/* A physical port has changed in the datapath */
typedef ofp_port_status {
    typedef ofp_header header;
    byte reason;          /* One of OFPPR_*. */
    byte pad[7];          /* Align to 64-bits. */
    typedef ofp_phy_port desc;
};

/* Modify behavior of the physical port */
typedef ofp_port_mod {
    typedef ofp_header header;
    short port_no;
    byte hw_addr[OFP_ETH_ALEN]; /* The hardware address is not
                                      configurable.  This is used to
                                      sanity-check the request, so it must
                                      be the same as returned in an
                                      ofp_phy_port typedef. */

    int config;        /* Bitmap of OFPPC_* flags. */
    int mask;          /* Bitmap of OFPPC_* flags to be changed. */

    int advertise;     /* Bitmap of "ofp_port_features"s.  Zero all
                               bits to prevent any action taking place. */
    byte pad[4];         /* Pad to 64-bits. */
};




/* The wildcards for ICMP type and code fields use the transport source
 * and destination port fields, respectively. */
#define OFPFW_ICMP_TYPE OFPFW_TP_SRC
#define OFPFW_ICMP_CODE OFPFW_TP_DST

/* Values below this cutoff are 802.3 packets and the two bytes
 * following MAC addresses are used as a frame length.  Otherwise, the
 * two bytes are used as the Ethernet type.
 */
#define OFP_DL_TYPE_ETH2_CUTOFF   0x0600

/* Value of dl_type to indicate that the frame does not include an
 * Ethernet type.
 */
#define OFP_DL_TYPE_NOT_ETH_TYPE  0x05ff

/* The VLAN id is 12-bits, so we can use the entire 16 bits to indicate
 * special conditions.  All ones indicates that no VLAN id was set.
 */
#define OFP_VLAN_NONE      0xffff

/* Fields to match against flows */


/* The match fields for ICMP type and code use the transport source and
 * destination port fields, respectively. */
#define icmp_type tp_src
#define icmp_code tp_dst

/* Value used in "idle_timeout" and "hard_timeout" to indicate that the entry
 * is permanent. */
#define OFP_FLOW_PERMANENT 0

/* By default, choose a priority in the middle. */

enum ofp_flow_mod_flags {
    OFPFF_SEND_FLOW_REM = 1 << 0,  /* Send flow removed message when flow
                                    * expires or is deleted. */
    OFPFF_CHECK_OVERLAP = 1 << 1,  /* Check for overlapping entries first. */
    OFPFF_EMERG         = 1 << 2   /* Remark this is for emergency. */
};

/* Flow setup and teardown (controller -> datapath). */


/* Why was this flow removed? */
enum ofp_flow_removed_reason {
    OFPRR_IDLE_TIMEOUT,         /* Flow idle time exceeded idle_timeout. */
    OFPRR_HARD_TIMEOUT,         /* Time exceeded hard_timeout. */
    OFPRR_DELETE                /* Evicted by a DELETE flow mod. */
};

/* Flow removed (datapath -> controller). */
typedef ofp_flow_removed {
    typedef ofp_header header;
    typedef ofp_match match;   /* Description of fields. */
    uint64_t cookie;          /* Opaque controller-issued identifier. */

    short priority;        /* Priority level of flow entry. */
    byte reason;           /* One of OFPRR_*. */
    byte pad[1];           /* Align to 32-bits. */

    int duration_sec;    /* Time flow was alive in seconds. */
    int duration_nsec;   /* Time flow was alive in nanoseconds beyond
                                 duration_sec. */
    short idle_timeout;    /* Idle timeout from original flow mod. */
    byte pad2[2];          /* Align to 64-bits. */
    uint64_t packet_count;
    uint64_t byte_count;
};

/* Values for 'type' in ofp_error_message.  These values are immutable: they
 * will not change in future versions of the protocol (although new values may
 * be added). */
enum ofp_error_type {
    OFPET_HELLO_FAILED,         /* Hello protocol failed. */
    OFPET_BAD_REQUEST,          /* Request was not understood. */
    OFPET_BAD_ACTION,           /* Error in action description. */
    OFPET_FLOW_MOD_FAILED,      /* Problem modifying flow entry. */
    OFPET_PORT_MOD_FAILED,      /* Port mod request failed. */
    OFPET_QUEUE_OP_FAILED       /* Queue operation failed. */
};

/* ofp_error_msg 'code' values for OFPET_HELLO_FAILED.  'data' contains an
 * ASCII text string that may give failure details. */
enum ofp_hello_failed_code {
    OFPHFC_INCOMPATIBLE,        /* No compatible version. */
    OFPHFC_EPERM                /* Permissions error. */
};

/* ofp_error_msg 'code' values for OFPET_BAD_REQUEST.  'data' contains at least
 * the first 64 bytes of the failed request. */
enum ofp_bad_request_code {
    OFPBRC_BAD_VERSION,         /* ofp_header.version not supported. */
    OFPBRC_BAD_TYPE,            /* ofp_header.type not supported. */
    OFPBRC_BAD_STAT,            /* ofp_stats_request.type not supported. */
    OFPBRC_BAD_VENDOR,          /* Vendor not supported (in ofp_vendor_header
                                 * or ofp_stats_request or ofp_stats_reply). */
    OFPBRC_BAD_SUBTYPE,         /* Vendor subtype not supported. */
    OFPBRC_EPERM,               /* Permissions error. */
    OFPBRC_BAD_LEN,             /* Wrong request length for type. */
    OFPBRC_BUFFER_EMPTY,        /* Specified buffer has already been used. */
    OFPBRC_BUFFER_UNKNOWN       /* Specified buffer does not exist. */
};

/* ofp_error_msg 'code' values for OFPET_BAD_ACTION.  'data' contains at least
 * the first 64 bytes of the failed request. */
enum ofp_bad_action_code {
    OFPBAC_BAD_TYPE,           /* Unknown action type. */
    OFPBAC_BAD_LEN,            /* Length problem in actions. */
    OFPBAC_BAD_VENDOR,         /* Unknown vendor id specified. */
    OFPBAC_BAD_VENDOR_TYPE,    /* Unknown action type for vendor id. */
    OFPBAC_BAD_OUT_PORT,       /* Problem validating output action. */
    OFPBAC_BAD_ARGUMENT,       /* Bad action argument. */
    OFPBAC_EPERM,              /* Permissions error. */
    OFPBAC_TOO_MANY,           /* Can't handle this many actions. */
    OFPBAC_BAD_QUEUE           /* Problem validating output queue. */
};

/* ofp_error_msg 'code' values for OFPET_FLOW_MOD_FAILED.  'data' contains
 * at least the first 64 bytes of the failed request. */
enum ofp_flow_mod_failed_code {
    OFPFMFC_ALL_TABLES_FULL,    /* Flow not added because of full tables. */
    OFPFMFC_OVERLAP,            /* Attempted to add overlapping flow with
                                 * CHECK_OVERLAP flag set. */
    OFPFMFC_EPERM,              /* Permissions error. */
    OFPFMFC_BAD_EMERG_TIMEOUT,  /* Flow not added because of non-zero idle/hard
                                 * timeout. */
    OFPFMFC_BAD_COMMAND,        /* Unknown command. */
    OFPFMFC_UNSUPPORTED         /* Unsupported action list - cannot process in
                                 * the order specified. */
};

/* ofp_error_msg 'code' values for OFPET_PORT_MOD_FAILED.  'data' contains
 * at least the first 64 bytes of the failed request. */
enum ofp_port_mod_failed_code {
    OFPPMFC_BAD_PORT,            /* Specified port does not exist. */
    OFPPMFC_BAD_HW_ADDR,         /* Specified hardware address is wrong. */
};

/* ofp_error msg 'code' values for OFPET_QUEUE_OP_FAILED. 'data' contains
 * at least the first 64 bytes of the failed request */
enum ofp_queue_op_failed_code {
    OFPQOFC_BAD_PORT,           /* Invalid port (or port does not exist). */
    OFPQOFC_BAD_QUEUE,          /* Queue does not exist. */
    OFPQOFC_EPERM               /* Permissions error. */
};

/* OFPT_ERROR: Error message (datapath -> controller). */
typedef ofp_error_msg {
    typedef ofp_header header;

    short type;
    short code;
    byte data[0];          /* Variable-length data.  Interpreted based
                                 on the type and code. */
};

enum ofp_stats_types {
    /* Description of this OpenFlow switch.
     * The request body is empty.
     * The reply body is typedef ofp_desc_stats. */
    OFPST_DESC,

    /* Individual flow statistics.
     * The request body is typedef ofp_flow_stats_request.
     * The reply body is an array of typedef ofp_flow_stats. */
    OFPST_FLOW,

    /* Aggregate flow statistics.
     * The request body is typedef ofp_aggregate_stats_request.
     * The reply body is typedef ofp_aggregate_stats_reply. */
    OFPST_AGGREGATE,

    /* Flow table statistics.
     * The request body is empty.
     * The reply body is an array of typedef ofp_table_stats. */
    OFPST_TABLE,

    /* Physical port statistics.
     * The request body is typedef ofp_port_stats_request.
     * The reply body is an array of typedef ofp_port_stats. */
    OFPST_PORT,

    /* Queue statistics for a port
     * The request body defines the port
     * The reply body is an array of typedef ofp_queue_stats */
    OFPST_QUEUE,

    /* Vendor extension.
     * The request and reply bodies begin with a 32-bit vendor ID, which takes
     * the same form as in "typedef ofp_vendor_header".  The request and reply
     * bodies are otherwise vendor-defined. */
    OFPST_VENDOR = 0xffff
};

typedef ofp_stats_request {
    typedef ofp_header header;
    short type;              /* One of the OFPST_* constants. */
    short flags;             /* OFPSF_REQ_* flags (none yet defined). */
    byte body[0];            /* Body of the request. */
};

enum ofp_stats_reply_flags {
    OFPSF_REPLY_MORE  = 1 << 0  /* More replies to follow. */
};

typedef ofp_stats_reply {
    typedef ofp_header header;
    short type;              /* One of the OFPST_* constants. */
    short flags;             /* OFPSF_REPLY_* flags. */
    byte body[0];            /* Body of the reply. */
};

#define DESC_STR_LEN   256
#define SERIAL_NUM_LEN 32
/* Body of reply to OFPST_DESC request.  Each entry is a NULL-terminated
 * ASCII string. */
typedef ofp_desc_stats {
    char mfr_desc[DESC_STR_LEN];       /* Manufacturer description. */
    char hw_desc[DESC_STR_LEN];        /* Hardware description. */
    char sw_desc[DESC_STR_LEN];        /* Software description. */
    char serial_num[SERIAL_NUM_LEN  /* Serial number. */
    char dp_desc[DESC_STR_LEN];        /* Human readable description of datapath. */
};

/* Body for ofp_stats_request of type OFPST_FLOW. */
typedef ofp_flow_stats_request {
    typedef ofp_match match;   /* Fields to match. */
    byte table_id;         /* ID of table to read (from ofp_table_stats),
                                 0xff for all tables or 0xfe for emergency. */
    byte pad;              /* Align to 32 bits. */
    short out_port;        /* Require matching entries to include this
                                 as an output port.  A value of OFPP_NONE
                                 indicates no restriction. */
};

/* Body of reply to OFPST_FLOW request. */
typedef ofp_flow_stats {
    short length;          /* Length of this entry. */
    byte table_id;         /* ID of table flow came from. */
    byte pad;
    typedef ofp_match match;   /* Description of fields. */
    int duration_sec;    /* Time flow has been alive in seconds. */
    int duration_nsec;   /* Time flow has been alive in nanoseconds beyond
                                 duration_sec. */
    short priority;        /* Priority of the entry. Only meaningful
                                 when this is not an exact-match entry. */
    short idle_timeout;    /* Number of seconds idle before expiration. */
    short hard_timeout;    /* Number of seconds before expiration. */
    byte pad2[6];          /* Align to 64-bits. */
    uint64_t cookie;          /* Opaque controller-issued identifier. */
    uint64_t packet_count;    /* Number of packets in flow. */
    uint64_t byte_count;      /* Number of bytes in flow. */
    typedef ofp_action_header actions[0]; /* Actions. */
};

/* Body for ofp_stats_request of type OFPST_AGGREGATE. */
typedef ofp_aggregate_stats_request {
    typedef ofp_match match;   /* Fields to match. */
    byte table_id;         /* ID of table to read (from ofp_table_stats)
                                 0xff for all tables or 0xfe for emergency. */
    byte pad;              /* Align to 32 bits. */
    short out_port;        /* Require matching entries to include this
                                 as an output port.  A value of OFPP_NONE
                                 indicates no restriction. */
};

/* Body of reply to OFPST_AGGREGATE request. */
typedef ofp_aggregate_stats_reply {
    uint64_t packet_count;    /* Number of packets in flows. */
    uint64_t byte_count;      /* Number of bytes in flows. */
    int flow_count;      /* Number of flows. */
    byte pad[4];           /* Align to 64 bits. */
};

/* Body of reply to OFPST_TABLE request. */
typedef ofp_table_stats {
    byte table_id;        /* Identifier of table.  Lower numbered tables
                                are consulted first. */
    byte pad[3];          /* Align to 32-bits. */
    char name[OFP_MAX_TABLE_NAME_LEN];
    int wildcards;      /* Bitmap of OFPFW_* wildcards that are
                                supported by the table. */
    int max_entries;    /* Max number of entries supported. */
    int active_count;   /* Number of active entries. */
    uint64_t lookup_count;   /* Number of packets looked up in table. */
    uint64_t matched_count;  /* Number of packets that hit table. */
};

/* Body for ofp_stats_request of type OFPST_PORT. */
typedef ofp_port_stats_request {
    short port_no;        /* OFPST_PORT message must request statistics
                              * either for a single port (specified in
                              * port_no) or for all ports (if port_no ==
                              * OFPP_NONE). */
    byte pad[6];
};

/* Body of reply to OFPST_PORT request. If a counter is unsupported, set
 * the field to all ones. */
typedef ofp_port_stats {
    short port_no;
    byte pad[6];          /* Align to 64-bits. */
    uint64_t rx_packets;     /* Number of received packets. */
    uint64_t tx_packets;     /* Number of transmitted packets. */
    uint64_t rx_bytes;       /* Number of received bytes. */
    uint64_t tx_bytes;       /* Number of transmitted bytes. */
    uint64_t rx_dropped;     /* Number of packets dropped by RX. */
    uint64_t tx_dropped;     /* Number of packets dropped by TX. */
    uint64_t rx_errors;      /* Number of receive errors.  This is a super-set
                                of more specific receive errors and should be
                                greater than or equal to the sum of all
                                rx_*_err values. */
    uint64_t tx_errors;      /* Number of transmit errors.  This is a super-set
                                of more specific transmit errors and should be
                                greater than or equal to the sum of all
                                tx_*_err values (none currently defined.) */
    uint64_t rx_frame_err;   /* Number of frame alignment errors. */
    uint64_t rx_over_err;    /* Number of packets with RX overrun. */
    uint64_t rx_crc_err;     /* Number of CRC errors. */
    uint64_t collisions;     /* Number of collisions. */
};

/* Vendor extension. */
typedef ofp_vendor_header {
    typedef ofp_header header;   /* Type OFPT_VENDOR. */
    int vendor;            /* Vendor ID:
                                 * - MSB 0: low-order bytes are IEEE OUI.
                                 * - MSB != 0: defined by OpenFlow
                                 *   consortium. */
    /* Vendor-defined arbitrary additional data. */
};

/* All ones is used to indicate all queues in a port (for stats retrieval). */
#define OFPQ_ALL      0xffffffff

/* Min rate > 1000 means not configured. */
#define OFPQ_MIN_RATE_UNCFG      0xffff

enum ofp_queue_properties {
    OFPQT_NONE = 0,       /* No property defined for queue (default). */
    OFPQT_MIN_RATE,       /* Minimum datarate guaranteed. */
                          /* Other types should be added here
                           * (i.e. max rate, precedence, etc). */
};

/* Common description for a queue. */
typedef ofp_queue_prop_header {
    short property;    /* One of OFPQT_. */
    short len;         /* Length of property, including this header. */
    byte pad[4];       /* 64-bit alignemnt. */
};

/* Min-Rate queue property description. */
typedef ofp_queue_prop_min_rate {
    typedef ofp_queue_prop_header prop_header; /* prop: OFPQT_MIN, len: 16. */
    short rate;        /* In 1/10 of a percent; >1000 -> disabled. */
    byte pad[6];       /* 64-bit alignment */
};

/* Full description for a queue. */
typedef ofp_packet_queue {
    int queue_id;     /* id for the specific queue. */
    short len;          /* Length in bytes of this queue desc. */
    byte pad[2];        /* 64-bit alignment. */
    typedef ofp_queue_prop_header properties[0]; /* List of properties. */
};

/* Query for port queue configuration. */
typedef ofp_queue_get_config_request {
    typedef ofp_header header;
    short port;         /* Port to be queried. Should refer
                              to a valid physical port (i.e. < OFPP_MAX) */
    byte pad[2];        /* 32-bit alignment. */
};

/* Queue configuration for a given port. */
typedef ofp_queue_get_config_reply {
    typedef ofp_header header;
    short port;
    byte pad[6];
    typedef ofp_packet_queue queues[0]; /* List of configured queues. */
};

/* OFPAT_ENQUEUE action typedef: send packets to given queue on port. */
typedef ofp_action_enqueue {
    short type;            /* OFPAT_ENQUEUE. */
    short len;             /* Len is 16. */
    short port;            /* Port that queue belongs. Should
                                 refer to a valid physical port
                                 (i.e. < OFPP_MAX) or OFPP_IN_PORT. */
    byte pad[6];           /* Pad for 64-bit alignment. */
    int queue_id;        /* Where to enqueue the packets. */
};

typedef ofp_queue_stats_request {
    short port_no;        /* All ports if OFPT_ALL. */
    byte pad[2];          /* Align to 32-bits. */
    int queue_id;       /* All queues if OFPQ_ALL. */
};

typedef ofp_queue_stats {
    short port_no;
    byte pad[2];          /* Align to 32-bits. */
    int queue_id;       /* Queue i.d */
    uint64_t tx_bytes;       /* Number of transmitted bytes. */
    uint64_t tx_packets;     /* Number of transmitted packets. */
    uint64_t tx_errors;      /* Number of packets dropped due to overrun. */
};



/******** used but discarded *****************/
/* Header on all OpenFlow packets. */
typedef ofp_header {
    byte version;    /* OFP_VERSION. */
    byte type;       /* One of the OFPT_ constants. */
    short lengthgth;    /* Length including this ofp_header. */
    int xid        /* Transaction id associated with this packet.
                           Replies use the same id as was in the request
                           to facilitate pairing. */
};
/* Action typedefure for OFPAT_OUTPUT, which sends packets out 'port'.
 * When the 'port' is the OFPP_CONTROLLER, 'max_length' indicates the max
 * number of bytes to send.  A 'max_length' of zero means no bytes of the
 * packet should be sent.*/
typedef ofp_action_output {
    short type;                  /* OFPAT_OUTPUT. */
    short length;                   /* Length is 8. */
    short port;                  /* Output port. */
    short max_length;               /* Max lengthgth to send to controller. */
};

/* The VLAN id is 12 bits, so we can use the entire 16 bits to indicate
 * special conditions.  All ones is used to match that no VLAN id was
 * set. */
#define OFP_VLAN_NONE      0xffff

/* Action typedefure for OFPAT_SET_VLAN_VID. */
typedef ofp_action_vlan_vid {
    short type;                  /* OFPAT_SET_VLAN_VID. */
    short length;                   /* Length is 8. */
    short vlan_vid;              /* VLAN id. */
};

/* Action typedefure for OFPAT_SET_VLAN_PCP. */
typedef ofp_action_vlan_pcp {
    short type;                  /* OFPAT_SET_VLAN_PCP. */
    short length;                   /* Length is 8. */
    byte vlan_pcp;               /* VLAN priority. */
};

/* Action typedefure for OFPAT_SET_DL_SRC/DST. */
typedef ofp_action_dl_addr {
    short type;                  /* OFPAT_SET_DL_SRC/DST. */
    short length;                   /* Length is 16. */
    int dl_addr  /* Ethernet address. */
};

/* Action typedefure for OFPAT_SET_NW_SRC/DST. */
typedef ofp_action_nw_addr {
    short type;                  /* OFPAT_SET_TW_SRC/DST. */
    short length;                   /* Length is 8. */
    int nw_addr;               /* IP address. */
};

/* Action typedefure for OFPAT_SET_TP_SRC/DST. */
typedef ofp_action_tp_port {
    short type;                  /* OFPAT_SET_TP_SRC/DST. */
    short length;                   /* Length is 8. */
    short tp_port;               /* TCP/UDP port. */
};

/* Action typedefure for OFPAT_SET_NW_TOS. */
typedef ofp_action_nw_tos {
    short type;                  /* OFPAT_SET_TW_SRC/DST. */
    short length;                   /* Length is 8. */
    byte nw_tos;                 /* IP ToS (DSCP field, 6 bits). */
};

/* Action header for OFPAT_VENDOR. The rest of the body is vendor-defined. */
typedef ofp_action_vendor_header {
    short type;                  /* OFPAT_VENDOR. */
    short length;                   /* Length is a multiple of 8. */
    int vendor;                /* Vendor ID, which takes the same form
                                       as in "typedef ofp_vendor_header". */
};
/* enum ofp_flow_mod_flags { */
#define    OFPFF_SEND_FLOW_REM = 1 << 0  /* Send flow removed message when flow
      		                              * expires or is deleted. */
#define    OFPFF_CHECK_OVERLAP = 1 << 1  /* Check for overlapping entries first. */
#define    OFPFF_EMERG         = 1 << 2   /* Remark this is for emergency. */


/* Flow wildcards. */
/* enum ofp_flow_wildcards { */
#define    OFPFW_IN_PORT   1 << 0  /* Switch input port. */
#define    OFPFW_DL_VLAN   1 << 1  /* VLAN id. */
#define    OFPFW_DL_SRC    1 << 2  /* Ethernet source address. */
#define    OFPFW_DL_DST    1 << 3  /* Ethernet destination address. */
#define    OFPFW_DL_TYPE   1 << 4  /* Ethernet frame type. */
#define    OFPFW_NW_PROTO  1 << 5  /* IP protocol. */
#define    OFPFW_TP_SRC    1 << 6  /* TCP/UDP source port. */
#define    OFPFW_TP_DST    1 << 7  /* TCP/UDP destination port. */

    /* IP source address wildcard bit count.  0 is exact match, 1 ignores the
     * LSB, 2 ignores the 2 least-significant bits, ..., 32 and higher wildcard
     * the entire field.  This is the *opposite* of the usual convention where
     * e.g. /24 indicates that 8 bits (not 24 bits) are wildcarded. */
#define    OFPFW_NW_SRC_SHIFT  8
#define    OFPFW_NW_SRC_BITS  6
#define    OFPFW_NW_SRC_MASK  ((1 << OFPFW_NW_SRC_BITS) - 1) << OFPFW_NW_SRC_SHIFT
#define    OFPFW_NW_SRC_ALL  32 << OFPFW_NW_SRC_SHIFT

    /* IP destination address wildcard bit count.  Same format as source. */
#define    OFPFW_NW_DST_SHIFT  14
#define    OFPFW_NW_DST_BITS  6
#define    OFPFW_NW_DST_MASK  ((1 << OFPFW_NW_DST_BITS) - 1) << OFPFW_NW_DST_SHIFT,
#define    OFPFW_NW_DST_ALL  32 << OFPFW_NW_DST_SHIFT,

#define    OFPFW_DL_VLAN_PCP  1 << 20  /* VLAN priority. */
#define    OFPFW_NW_TOS  1 << 21  /* IP ToS (DSCP field, 6 bits). */

    /* Wildcard all fields. */
#define    OFPFW_ALL  ((1 << 22) - 1)


typedef dp_ofp_packet_in_t{
	byte dpid;
	ofp_packet_in_t packet_in
};
typedef dp_ofp_packet_out_t{
	byte dpid;
	ofp_packet_out_t packet_out
};
typedef dp_ofp_flow_mod_t{
	byte dpid;
	ofp_flow_mod_t flow_mod
};
typedef dp_ofp_port_flood_t{
	byte dpid;
	/* ofp_port_flood_t port_flood */
};
typedef prt_mac_packet_t{
	byte port;
	mac_packet_t mac_packet
};

#define OFP_DEFAULT_PRIORITY 0

typedef ofp_flow_mod_header {
    ofp_match match;      /* Fields to match */
    /* uint64_t cookie;              Opaque controller-issued identifier. */

    /* Flow actions. */
    byte command;             /* One of OFPFC_*. */
/*    byte idle_timeout;         Idle time before discarding (seconds). */
/*    byte hard_timeout;         Max time before discarding (seconds). */
/*    byte pri;             Priority level of flow entry. */
/*    byte buffer_id;            Buffered packet to apply to (or -1).
                                     Not meaningful for OFPFC_DELETE*. */
/*    byte out_port;             For OFPFC_DELETE* commands, require
                                     matching entries to include this as an
                                     output port.  A value of OFPP_NONE
                                     indicates no restriction. */
/*    byte flags;                One of OFPFF_*. */
    /* ofp_action_header actions[0];  The action lengthgth is inferred
                                            from the lengthgth field in the
                                            header. */
};
typedef ofp_match {
/*    byte wildcards;         Wildcard fields. */
    byte in_port;          /* Input switch port. */
    byte dl_src; /* Ethernet source address. */
    byte dl_dst; /* Ethernet destination address. */
/*    byte dl_vlan;           Input VLAN id. */
/*    byte dl_vlan_pcp;        Input VLAN priority. */
    byte dl_type;          /* Ethernet frame type. */
/*    byte nw_tos;             IP ToS (actually DSCP field, 6 bits). */
/*    byte nw_proto;           IP protocol or lower 8 bits of
                                * ARP opcode. */
/*    byte nw_src;            IP source address. */
/*    byte nw_dst;            IP destination address. */
/*    byte tp_src;            TCP/UDP source port. */
/*    byte tp_dst;            TCP/UDP destination port. */
};
typedef ofp_packet_out_header {
/*    byte buffer_id;            ID assigned by datapath (-1 if none). */
    byte in_port;             /* Packet's input port (OFPP_NONE if none). */
/*    byte actions_length;          Size of action array in bytes. */
    /* ofp_action_header actions[0];  Actions. */
    /* byte data[0]; */        /* Packet data.  The lengthgth is inferred
                                     from the lengthgth field in the header.
                                     (Only meaningful if buffer_id == -1.) */
};
typedef ofp_action_header {
    byte type;                  /* One of OFPAT_*. */
/*    byte length;                    Length of action, including this
                                       header.  This is the lengthgth of action,
                                       including any padding to make it
                                       64-bit aligned. */
    byte arg1;			/* output:port */
/*    byte arg2			 output:max_length */
};
/* Action header that is common to all actions.  The lengthgth includes the
 * header and any padding used to make the action 64-bit aligned.
 * NB: The lengthgth of an action *must* always be a multiple of eight. */
typedef ofp_packet_in_header {
/*    byte buffer_id;      ID assigned by datapath. */
/*    byte total_length;      Full lengthgth of frame. */
    byte in_port;       /* Port on which frame was received. */
/*    byte reason;          Reason packet is being sent (one of OFPR_*) */
/*    byte data[0]         Ethernet frame, halfway through 32-bit word,
                               so the IP header is 32-bit aligned.  The
                               amount of data is inferred from the lengthgth
                               field in the header.  Because of padding,
                               offsetof(typedef ofp_packet_in, data) ==
                               sizeof(typedef ofp_packet_in) - 2. */
};

