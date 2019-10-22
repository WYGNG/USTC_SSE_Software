#specify basic parameters for the simulations
set val(chan) 	Channel/WirelessChannel		;#channel type
set val(prop) 	Propagation/TwoRayGround	;#radio-propagation model
set val(netif) 	Phy/WirelessPhy			;#networks interface type
set val(mac) 	Mac/802_11			;#MAC type
set val(ifq) 	Queue/DropTail/PriQueue		;#interface queue type
set val(ll)	LL				;#link layer  type
set val(ant) 	Antenna/OmniAntenna	  	;#antenna model
set val(ifqlen) 50				;#mac packet in ifq
set val(nn) 	3				;#number of mobilenodes
set val(rp)	DSDV				;#routing protocol
set val(x)	500				;#X dimension of topography
set val(y) 	400				;#Y dimension of topography
set val(stop) 	150				;#time of simulation end

set ns [new Simulator]

#open a standard trace file for analyzing.
set tracefd		[open simple.tr w]
set namtrace		[open simwrls.nam w]
set windowVsTime2 	[open win.tr w]

$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace $val(x) $val(y)

#Set a topograhy object for ensuring the nodes move inside the Topological boundary
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

#Create a god object.
create-god $val(nn)

#nodes configuring
$ns node-config -adhocRouting $val(rp)	\
		-llType $val(ll) 	\
		-macType $val(mac) 	\
		-ifqType $val(ifq) 	\
		-ifqLen $val(ifqlen) 	\
		-antType $val(ant) 	\
		-propType $val(prop) 	\
		-phyType $val(netif) 	\
		-channelType $val(chan) \
		-topoInstance $topo 	\
		-agentTrace ON 		\
		-routerTrace ON 	\
		-macTrace OFF		\
		-movementTrace ON

for {set i 0} { $i < $val(nn) } { incr i} {
     set node_($i) [$ns node]
}

#Provide the initial locations of the nodes
$node_(0) set X_ 5.0
$node_(0) set Y_ 5.0
$node_(0) set Z_ 0.0
$node_(1) set X_ 490.0
$node_(1) set Y_ 285.0
$node_(1) set Z_ 0.0
$node_(2) set X_ 150.0
$node_(2) set Y_ 240.0
$node_(2) set Z_ 0.0
#nodes' movement
$ns at 10.0 "$node_(0) setdest 250.0 250.0 3.0"
$ns at 15.0 "$node_(1) setdest 45.0 285.0 5.0"
$ns at 110.0 "$node_(0) setdest 480.0 300.0 5.0"

#create the TCP connection and ftp application between node 0 and node 1, which will be initiated at time 10
set tcp [new Agent/TCP/Newreno]
$tcp set class_ 2
set sink [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp
$ns attach-agent $node_(1) $sink
$ns connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns at 1.0 "$ftp start"

#print window size
proc plotWindow {tcpSource file} {
global ns
set time 0.1
set now [$ns now]
set cwnd [$tcpSource set cwnd_]
puts $file "$now $cwnd"
$ns at [expr $now+$time] "plotWindow $tcpSource $file" }
$ns at 10.1 "plotWindow $tcp $windowVsTime2"

#initial node position for nam using
for {set i 0} { $i < $val(nn) } { incr i } {
	#30 defines the node size for nam
	$ns initial_node_pos $node_($i) 30
}

#end simulation condition
for {set i 0} { $i < $val(nn) } { incr i} {
	$ns at $val(stop) "$node_($i) reset";
}
#tell the simulator to call the procedures
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at 150.1 "puts \"end simulation\" ; $ns halt"
proc finish {} {
	global ns tracefd namtrace
	$ns flush-trace
	close $tracefd
	close $namtrace
        exec nam simwrls.nam &
	#Call xgraph to display the results
	exec xgraph win.tr -geometry 800x600 &
	exit 0
}

#run the simulation
$ns run
