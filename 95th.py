#!/usr/bin/env python

import csv
import datetime
import numpy
import os
import sys

# Change to script directory
os.chdir(os.path.dirname(sys.argv[0]))

def pct(day_rows):
	ps = []
	first = True
	for col in day_rows:
		if first:
			p = numpy.percentile(numpy.array(col), 50)
			first = False
		else:
			p = numpy.percentile(numpy.array(col), 95)
		ps.append(round(p,3))
	outcsv.writerow(ps)

fd = open('frontpage.txt','rb')
parsed = csv.reader(fd, delimiter='\t')
date = datetime.date(1,1,1)
month = 0
outfd = open('95th.txt', 'wb')
outcsv = csv.writer(outfd, delimiter='\t')

first = True
for row in parsed:
	try:
		unixtime = float(row[0])
	except ValueError:
		outcsv.writerow(row)
		continue

	dt = datetime.datetime.utcfromtimestamp(unixtime)

	if dt.date() != date:
		if not first:
			pct(day_rows)
		first = False
		day_rows = [[],[],[],[],[]]
		date = dt.date()

	for i, val in enumerate(row):
		f = float(row[i])
		# Skip NaN
		if f > 0:
			day_rows[i].append(f)
