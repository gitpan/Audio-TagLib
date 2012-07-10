#!/bin/bash

for i in `ls update_template` ; do 
	/usr/bin/perl script/$i
done
