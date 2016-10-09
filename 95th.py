#!/usr/bin/env python

import csv
import datetime
import numpy

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
day = 0
day_rows_empty=[[],[],[],[],[]]
outfd = open('95th.txt', 'wb')
outcsv = csv.writer(outfd, delimiter='\t')

for row in parsed:
	try:
		unixtime = float(row[0])
	except ValueError:
		outcsv.writerow(row)
		continue

	dt = datetime.datetime.utcfromtimestamp(unixtime)

	if dt.day != day:
		if day > 0:
			pct(day_rows)
		day_rows = day_rows_empty
		day = dt.day

	for i, val in enumerate(row):
		f = float(row[i])
		if f > 0:
			day_rows[i].append(f)
