#!/bin/sh
free | sed -n '2,3p' | awk '{if (NR==1) print "total:"$2 " used:"$3 " free:"$4 " buffers:"$6 " cached:"$7; else print " app_used:"$3 " app_avaliable:"$4}'|tr -d '\n'
