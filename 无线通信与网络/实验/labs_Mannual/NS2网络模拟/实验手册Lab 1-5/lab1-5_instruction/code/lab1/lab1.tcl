#The source file for NS2 Warm Up
#################################################################################
# Create a simulator object
set ns [new Simulator]

# Define colors
$ns color 1 Blue
$ns color 2 Red
$ns color 3 Green

# Open the output files for recording
set f0 [open out0.tr w]
set f1 [open out1.tr w]
set f2 [open out2.tr w]

# Open a file for the nam trace data
set nf [open out.nam w]
$ns namtrace-all $nf

# Define the 'finish' procedure
proc finish {} {
	global f0 f1 f2 ns nf
	#Close the output files
	close $f0
	close $f1
	close $f2
	close $nf
	exec nam out.nam &
	#Call xgraph to display the results
	exec xgraph out0.tr out1.tr out2.tr -geometry 800x600 &
	exit 0
	}

# Define the 'record' procedure
proc record {} {
	global sink0 sink1 sink2 f0 f1 f2
	#Get an instance of the simulator
	set ns [Simulator instance]
	#Set the time after which the procedure should be called again
	set time 2.0
	#How many bytes have been received by the traffic sinks?
	set bw0 [$sink0 set bytes_]
	set bw1 [$sink1 set bytes_]
	set bw2 [$sink2 set bytes_]
	#Get the current time
	set now [$ns now]
	#Calculate the bandwidth (in MBit/s) and write it to the files
	puts $f0 "$now [expr $bw0/$time*8/1000000]"
	puts $f1 "$now [expr $bw1/$time*8/1000000]"
	puts $f2 "$now [expr $bw2/$time*8/1000000]"
	#Reset the bytes_ values on the traffic sinks
	$sink0 set bytes_ 0
	$sink1 set bytes_ 0
	$sink2 set bytes_ 0
	#Re-schedule the procedure
	$ns at [expr $now+$time] "record"
}

# Define the attach-expoo-traffic procedure
proc attach-expoo-traffic { node sink size burst idle rate color } {
	#Get an instance of the simulator
	set ns [Simulator instance]

	#Create a UDP agent and attach it to the node
	set source [new Agent/UDP]
	$ns attach-agent $node $source
	$source set fid_ $color

	#Create an Expoo traffic agent and set its configuration parameters
	set traffic [new Application/Traffic/Exponential]
	$traffic set packetSize_ $size
	$traffic set burst_time_ $burst
	$traffic set idle_time_ $idle
	$traffic set rate_ $rate

	#Attach traffic source to the traffic generator
	$traffic attach-agent $source

	#Connect the source and the sink
	$ns connect $source $sink
	
	return $traffic
}

# Nodes definition
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

# Nodes connection
$ns duplex-link $n0 $n3 1Mb 100ms DropTail
$ns duplex-link $n1 $n3 1Mb 100ms DropTail
$ns duplex-link $n2 $n3 1Mb 100ms DropTail
$ns duplex-link $n3 $n4 1Mb 100ms DropTail

# Nodes position for nam
$ns duplex-link-op $n0 $n3 orient right-down
$ns duplex-link-op $n2 $n3 orient right-up
$ns duplex-link-op $n1 $n3 orient right
$ns duplex-link-op $n3 $n4 orient right

set sink0 [new Agent/LossMonitor]
set sink1 [new Agent/LossMonitor]
set sink2 [new Agent/LossMonitor]
$ns attach-agent $n4 $sink0
$ns attach-agent $n4 $sink1
$ns attach-agent $n4 $sink2

set source0 [attach-expoo-traffic $n0 $sink0 200 2s 1s 100k 1]
set source1 [attach-expoo-traffic $n1 $sink1 200 2s 1s 200k 2]
set source2 [attach-expoo-traffic $n2 $sink2 200 2s 1s 300k 3]

$ns at 0.0 "record"
$ns at 10.0 "$source0 start"
$ns at 10.0 "$source1 start"
$ns at 10.0 "$source2 start"
$ns at 50.0 "$source0 stop"
$ns at 50.0 "$source1 stop"
$ns at 50.0 "$source2 stop"
$ns at 60.0 "finish"


$ns run

