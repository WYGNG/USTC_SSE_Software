## NS2 Lab1 网络仿真环境配置与 通信场景模拟

一．实验目的

(1)   理解网络协议栈的分层机制，指明实验1中关于各层的代码定义，运行出并能解释实验结果;
(2)   掌握信道容量的计算方法。

二．实验过程

1. 安装ns2 

（1）下载ns-allinone-2.35.tar.gz

（2）解压

（3）修改linkstate文件夹下的ls.h文件137行的erase改为this->erase。

（4）运行./install进行安装

（5）将bin加入环境变量PATH中

（6）Ns可以使用

2. 运行示例代码example1.tcl，example2.tcl，example3.tcl，lab1.tcl，效果分别如下图

![屏幕快照](/Users/xq/Desktop/屏幕快照.png)

![屏幕快照 1](/Users/xq/Desktop/屏幕快照 2.png)

![屏幕快照 3](/Users/xq/Desktop/屏幕快照 3.png)

![屏幕快照 4](/Users/xq/Desktop/屏幕快照 4.png)

三．代码理解

``` c
#The source file for NS2 Warm Up
#####################################################################
# Create a simulator object
set ns [new Simulator]

# Define colors
$ns color 1 Blue
$ns color 2 Red
$ns color 3 Green

# Open the output files for recording
# 定义文件并打开文件以写入数据
set f0 [open out0.tr w]
set f1 [open out1.tr w]
set f2 [open out2.tr w]

# Open a file for the nam trace data
# 打开out.nam文件
set nf [open out.nam w]
$ns namtrace-all $nf /

# Define the 'finish' procedure
# 定义结束程序，包括关闭输出文件，运行nam，确定xgraph窗口大小及要显示的数据集实现数据可视化
proc finish {} {
	# 全局变量声明
	global f0 f1 f2 ns nf		
	close $f0		
	close $f1
	close $f2
	close $nf
	# 效果等价于：将exec后面的命令输入到命令行执行
	exec nam out.nam &
	#Call xgraph to display the results
	exec xgraph out0.tr out1.tr out2.tr -geometry 800x600 &
	exit 0
	}

# Define the 'record' procedure
# 定义“记录”程序
proc record {} {
	global sink0 sink1 sink2 f0 f1 f2
	#Get an instance of the simulator
	set ns [Simulator instance]
	#Set the time after which the procedure should be called again
	# 定义再次发送的间隔时间		
	set time 2.0
	#How many bytes have been received by the traffic sinks?
	# 记录传输的字节数
	set bw0 [$sink0 set bytes_]
	set bw1 [$sink1 set bytes_]
	set bw2 [$sink2 set bytes_]
	#Get the current time
	#获取当前时间
	set now [$ns now]
	# Calculate the bandwidth (in MBit/s) and write it to the files
	# 计算带宽换算成MBit/s单位并写入输出文件
	puts $f0 "$now [expr $bw0/$time*8/1000000]"
	puts $f1 "$now [expr $bw1/$time*8/1000000]"
	puts $f2 "$now [expr $bw2/$time*8/1000000]"
	# Reset the bytes_ values on the traffic sinks
	# 重置接收数据
	$sink0 set bytes_ 0
	$sink1 set bytes_ 0
	$sink2 set bytes_ 0
	#Re-schedule the procedure
	$ns at [expr $now+$time] "record"
}

# Define the attach-expoo-traffic procedure
# 定义相关的传送程序
proc attach-expoo-traffic { node sink size burst idle rate color } {
	#Get an instance of the simulator
	set ns [Simulator instance]

	# Create a UDP agent and attach it to the node
	# 创建UDP（传输层）
	set source [new Agent/UDP]
	
	# 在node节点（物理层、数据链路层）上搭建source（传输层）
	$ns attach-agent $node $source
	$source set fid_ $color

	# Create an Expoo traffic agent and set its configuration parameters	
	# 创建信源（应用层）并设定相关参数
	set traffic [new Application/Traffic/Exponential]
	$traffic set packetSize_ $size
	$traffic set burst_time_ $burst
	$traffic set idle_time_ $idle
	$traffic set rate_ $rate

	# Attach traffic source to the traffic generator
	# 在传输层上搭建信源
	$traffic attach-agent $source

	#Connect the source and the sink
	$ns connect $source $sink	
	
	return $traffic
}

# Nodes definition
# 定义节点（物理层）
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

# Nodes connection
# 将节点之间连接起来，全双工，带宽1Mb，延时100ms（物理层）
$ns duplex-link $n0 $n3 1Mb 100ms DropTail
$ns duplex-link $n1 $n3 1Mb 100ms DropTail
$ns duplex-link $n2 $n3 1Mb 100ms DropTail
$ns duplex-link $n3 $n4 1Mb 100ms DropTail

# Nodes position for nam
# 定义网络的拓扑结构，即各个节点的排列位置和逻辑连接
$ns duplex-link-op $n0 $n3 orient right-down
$ns duplex-link-op $n2 $n3 orient right-up
$ns duplex-link-op $n1 $n3 orient right
$ns duplex-link-op $n3 $n4 orient right

# 这里没有3，因为3节点是个中转节点，本身没有发出数据
set sink0 [new Agent/LossMonitor]
set sink1 [new Agent/LossMonitor]
set sink2 [new Agent/LossMonitor]

# 将这些发送数据点 与 节点4 联系起来
$ns attach-agent $n4 $sink0
$ns attach-agent $n4 $sink1
$ns attach-agent $n4 $sink2

# 调用attach-expoo-traffic过程
# 输入参数（$n0 $sink0 200 2s 1s 100k 1）->（节点0，发送数据量，一个包的大小，忙碌时间，空闲时间，传输速率，颜色）
# 忙碌时间：允许使用最大速率传输的时间
# 空闲时间：允许不发包的最长时间
set source0 [attach-expoo-traffic $n0 $sink0 200 1s 30s 100k 1]
set source1 [attach-expoo-traffic $n1 $sink1 200 1s 1s 200k 2]
set source2 [attach-expoo-traffic $n2 $sink2 200 200s 1s 300k 3]

# 定义各节点开始/停止传输数据的时间
$ns at 0.0 "record"
$ns at 1.0 "$source0 start"
$ns at 2.0 "$source1 start"
$ns at 3.0 "$source2 start"
$ns at 40.0 "$source0 stop"
$ns at 45.0 "$source1 stop"
$ns at 40.0 "$source2 stop"
$ns at 120.0 "finish"

# 开始运行
$ns run


```