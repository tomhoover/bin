#!/usr/bin/env python
# -*- coding: utf-8 -*-
# exclude_duplicates.py
"""
from http://unix.stackexchange.com/questions/34366/is-there-a-way-of-deleting-duplicates-more-refined-than-fdupes-rdn

Example usage:

	sudo fdupes -Sr Desktop/ Dropbox/ Pictures/ /Volumes/Raid320/hoover/Pictures/ |sed -e '/^$/d' -e "s/^[0-9]/#&/" > duple_list
	python /Users/tom/bin/exclude_duplicates.py -f /Users/tom/duple_list --delimiter='#' --keep=Pictures/,/full/path/to/protected/directory2\ with\ spaces\ in\ path >remove-duplicate-files-keep-protected.sh

THE SCRIPT DOESN'T DELETE ANYTHING, IT ONLY GENERATES TEXT OUTPUT.
Provided a list of duplicates, such as fdupes or fslint output,
generate a bash script that will have all duplicates in protected
directories commented out. If none of the protected duplicates are
found in a set of the same files, select a random unprotected
duplicate for preserving.
Each path to a file will be transformed to an `rm "path"` string which
will be printed to standard output.     
"""

from optparse import OptionParser
parser = OptionParser()
parser.add_option("-k", "--keep", dest="keep",
    help="""List of directories which you want to keep, separated by commas. \
        EXAMPLE: exclude_duplicates.py --keep /path/to/directory1,/path/to/directory\ with\ space\ in\ path2""",
    metavar="keep"
)
parser.add_option("-d", "--delimiter", dest="delimiter",
    help="Delimiter of duplicate file groups", metavar="delimiter"
)
parser.add_option("-f", "--file", dest="file",
    help="List of duplicate file groups, separated by delimiter, for example, fdupes or fslint output.", metavar="file"
)

(options, args) = parser.parse_args()
directories_to_keep = options.keep.split(',')
file = options.file
delimiter = options.delimiter

pretty_line = '\n#' + '-' * 35
print '#/bin/bash'
print '#I will protect files in these directories:\n'
for d in directories_to_keep:
    print '# ' + d
print pretty_line

protected_set = set()
group_set = set()

def clean_set(group_set, protected_set, delimiter_line):
    not_protected_set = group_set - protected_set
    while not_protected_set:
        if len(not_protected_set) == 1 and len(protected_set) == 0:
            print '#randomly selected duplicate to keep:\n#rm "%s"' % not_protected_set.pop().strip('\n')
        else:
            print 'rm "%s"' % not_protected_set.pop().strip('\n')
    for i in protected_set: print '#excluded file in protected directory:\n#rm "%s"' % i.strip('\n')
    print '\n#%s' % delimiter_line
file = open(file, 'r')
for line in file.readlines():
    if line.startswith(delimiter):
        clean_set(group_set, protected_set, line)
        group_set, protected_set = set(), set()
    else:
        group_set = group_set|{line}
        for d in directories_to_keep:
            if line.startswith(d): protected_set = protected_set|{line}
else:
    if line: clean_set(group_set, protected_set, line)

