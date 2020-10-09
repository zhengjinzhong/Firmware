uint8 LINK_TYPE_GENERIC = 0
uint8 LINK_TYPE_UBIQUITY_BULLET = 1
uint8 LINK_TYPE_WIRE = 2
uint8 LINK_TYPE_USB = 3
uint8 LINK_TYPE_IRIDIUM	= 4

uint64 timestamp			# time since system start (microseconds)

telemetry_heartbeat[4] heartbeats

uint8 type				#  type of the radio hardware (LINK_TYPE_*)

uint8 mode

bool flow_control
bool forwarding
bool mavlink_v2
bool ftp

uint8 streams

uint32 data_rate                        # configured maximum data rate (Bytes/s)

float32 rate_multiplier

uint32 tx_message_count                 # total message sent count
float32 tx_rate_avg                     # transmit rate average (Bytes/s)
float32 tx_error_rate_avg               # transmit error rate average (Bytes/s)
uint32 tx_buffer_overruns               # number of TX buffer overruns

uint32 rx_message_count                 # count of total messages received
float32 rx_rate_avg                     # transmit rate average (Bytes/s)
uint32 rx_message_supported_count       # count of total messages received from supported systems and components (for loss statistics)
uint32 rx_message_lost_count
float32 rx_message_lost_rate
uint32 rx_buffer_overruns               # number of RX buffer overruns
uint32 rx_parse_errors                  # number of parse errors
uint32 rx_packet_drop_count             # number of packet drops
