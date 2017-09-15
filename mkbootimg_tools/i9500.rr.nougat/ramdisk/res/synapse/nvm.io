#!/system/bin/sh

# Busybox 
if [ -e /su/xbin/busybox ]; then
	BB=/su/xbin/busybox;
else if [ -e /sbin/busybox ]; then
	BB=/sbin/busybox;
else
	BB=/system/xbin/busybox;
fi;
fi;

cat << CTAG
{
    name:I/O,
    elements:[
    	{ SPane:{
		title:"I/O Schedulers",
		description:"Set the active I/O elevator algorithm. The I/O Scheduler decides how to prioritize and handle I/O requests. More info: <a href='http://timos.me/tm/wiki/ioscheduler'>Wiki</a>"
    	}},
	{ SSpacer:{
		height:1
	}},
	{ SOptionList:{
		title:"Storage scheduler Internal",
		description:" ",
		default:$(cat /sys/block/mmcblk0/queue/scheduler | $BB awk 'NR>1{print $1}' RS=[ FS=]),
		action:"ioset scheduler",
		values:[`while read values; do $BB printf "%s, \n" $values | $BB tr -d '[]'; done < /sys/block/mmcblk0/queue/scheduler`],
		notify:[
			{
				on:APPLY,
				do:[ REFRESH, CANCEL ],
				to:"/sys/block/mmcblk0/queue/iosched"
			},
			{
				on:REFRESH,
				do:REFRESH,
				to:"/sys/block/mmcblk0/queue/iosched"
			}
		]
	}},
	{ SSpacer:{
		height:1
	}},
	{ SOptionList:{
		title:"Storage scheduler SD card",
		description:" ",
		default:$(cat /sys/block/mmcblk1/queue/scheduler | $BB awk 'NR>1{print $1}' RS=[ FS=]),
		action:"ioset scheduler_ext",
		values:[`while read values; do $BB printf "%s, \n" $values | $BB tr -d '[]'; done < /sys/block/mmcblk1/queue/scheduler`],
		notify:[
			{
				on:APPLY,
				do:[ REFRESH, CANCEL ],
				to:"/sys/block/mmcblk1/queue/iosched"
			},
			{
				on:REFRESH,
				do:REFRESH,
				to:"/sys/block/mmcblk1/queue/iosched"
			}
		]
	}},
	{ SSpacer:{
		height:1
	}},
	{ SSeekBar:{
		title:"Storage Read-Ahead Internal",
		description:" ",
		max:4096,
		min:64,
		unit:" KB",
		step:64,
		default:$(cat /sys/block/mmcblk0/queue/read_ahead_kb),
		action:"ioset queue read_ahead_kb"
	}},
	{ SSpacer:{
		height:1
	}},
	{ SSeekBar:{
		title:"Storage Read-Ahead SD Card",
		description:" ",
		max:4096,
		min:64,
		unit:" KB",
		step:64,
		default:$(cat /sys/block/mmcblk1/queue/read_ahead_kb),
		action:"ioset queue_ext read_ahead_kb"
	}},
	{ SSpacer:{
		height:1
	}},
	{ SPane:{
		title:"General I/O Tunables",
		description:"Set the internal storage general tunables"
	}},
	{ SSpacer:{
		height:1
	}},
	{ SOptionList:{
		title:"Add Random",
		description:"Draw entropy from spinning (rotational) storage. Default is Disabled.\n",
		default:0,
		action:"generic /sys/block/mmcblk0/queue/add_random",
		values:{
			0:"Disabled", 1:"Enabled"
		}
	}},
	{ SSpacer:{
		height:1
	}},
	{ SOptionList:{
		title:"I/O Stats",
		description:"Maintain I/O statistics for this storage device. Disabling will break I/O monitoring apps but reduce CPU overhead. Default is Disabled.\n",
		default:0,
		action:"generic /sys/block/mmcblk0/queue/iostats",
		values:{
			0:"Disabled", 1:"Enabled"
		}
	}},
	{ SSpacer:{
		height:1
	}},
	{ SOptionList:{
		title:"Rotational",
		description:"Treat device as rotational storage. Default is Disabled.\n",
		default:0,
		action:"generic /sys/block/mmcblk0/queue/rotational",
		values:{
			0:"Disabled", 1:"Enabled"
		}
	}},
	{ SSpacer:{
		height:1
	}},
	{ SOptionList:{
		title:"No Merges",
		description:"Types of merges (prioritization) the scheduler queue for this storage device allows. Default is All.\n",
		default:0,
		action:"generic /sys/block/mmcblk0/queue/nomerges",
		values:{
			0:"All", 1:"Simple Only", 2:"None"
		}
	}},
	{ SSpacer:{
		height:1
	}},
	{ SOptionList:{
		title:"RQ Affinity",
		description:"Try to have scheduler requests complete on the CPU core they were made from. Default is Aggressive.\n",
		default:2,
		action:"generic /sys/block/mmcblk0/queue/rq_affinity",
		values:{
			0:"Disabled", 1:"Enabled", 2:"Aggressive"
		}
	}},
	{ SSpacer:{
		height:1
	}},
	{ SPane:{
		title:"I/O Scheduler Tunables Internal"
	}},
	{ SSpacer:{
		height:1
	}},
	{ STreeDescriptor:{
		path:"/sys/block/mmcblk0/queue/iosched",
		generic: {
			directory: {},
			element: {
				SGeneric: { title:"@BASENAME" }
			}
		},
		exclude: [ "weights", "wr_max_time" ]
	}},
	{ SSpacer:{
		height:1
	}},
	{ SPane:{
		title:"I/O Scheduler Tunables SD Card"
	}},
	{ SSpacer:{
		height:1
	}},
	{ STreeDescriptor:{
		path:"/sys/block/mmcblk1/queue/iosched",
		generic: {
			directory: {},
			element: {
				SGeneric: { title:"@BASENAME" }
			}
		},
		exclude: [ "weights", "wr_max_time" ]
	}},
	
    ]
}
CTAG
