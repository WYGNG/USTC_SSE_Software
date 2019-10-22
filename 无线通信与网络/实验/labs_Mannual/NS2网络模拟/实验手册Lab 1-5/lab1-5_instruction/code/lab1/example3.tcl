
# Create a simulator object
set ns [new Simulator]

# Define different colors for data flows(in nam)
$ns color 1 Blue
$ns color 2 Red

# Open the nam trace file
set nf [open out.nam w]
$ns namtrace-all $nf

# Define a 'finish' procedure
proc finish {} {
	global ns nf
	$ns flush-trace
	# Close the nam trace file
	close $nf
	# Execute nam on the trace file
	exec nam out.nam &
	exit 0
	}

# Nodes definition
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

# Nodes connection
$ns duplex-link $n0 $n2 1Mb 100ms DropTail
$ns duplex-link $n1 $n2 1Mb 100ms DropTail
$ns duplex-link $n3 $n2 1Mb 100ms SFQ 

# Nodes position for nam
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right

# Monitoring the queue for the link from n2 to n3
$ns duplex-link-op $n2 $n3 queuePos 0.5

# Create a UDP agent and attach it to node n0
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0

# Create a CBR traffic source and attach it to udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

# Create a UDP agent and attach it to node n1
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1

# Create a CBR traffic source and attach it to udp1
set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 500
$cbr1 set interval_ 0.005
$cbr1 attach-agent $udp1

# Marking flows
$udp0 set fid_ 1
$udp1 set fid_ 2

# Create a Null agent which acts as traffic sink and attch it to node n3 
set null0 [new Agent/Null]
$ns attach-agent $n3 $null0
$ns connect $udp0 $null0
$ns connect $udp1 $null0

$ns at 0.5 "$cbr0 start"
$ns at 1.0 "$cbr1 start"
$ns at 4.0 "$cbr1 stop"
$ns at 4.5 "$cbr0 stop" 

$ns at 5.0 "finish"

$ns run

