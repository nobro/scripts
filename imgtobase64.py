#!/usr/bin/python3

import sys
import getopt
import base64
from os import listdir
from os.path import isfile, join

onlyfiles = [files for files in listdir() if isfile(join(files))]
print("Lista fisiere din directorul curent: ", onlyfiles)


def main(argv):
    inputfile = ''
    outputfile = ''

    if len(argv) == 0:
        print('python3 imgtobase64.py -i <inputfile> -o <outputfile>')
        sys.exit(2)

    try:
        opts, args = getopt.getopt(argv, "hi:o:", ["ifile=", "ofile="])
    except getopt.GetoptError:
        print('python3 imgtobase64.py -i <inputfile> -o <outputfile>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print('python3 imgtobase64.py -i <inputfile> -o <outputfile>')
            sys.exit()
        elif opt in ("-i", "--ifile"):
            inputfile = arg
        elif opt in ("-o", "--ofile"):
            outputfile = arg

    with open(inputfile, "rb") as f:
        encodedZip = base64.b64encode(f.read())
        if len(outputfile) == 0:
            print('<img src="data:image/gif;base64, ', encodedZip.decode(), '" />')
            print('Input file is -->', inputfile)
        if len(outputfile) > 0:
            with open(outputfile, "a") as newf:
                newf.write('<img src="data:image/gif;base64, {}" />'.format(encodedZip.decode()))
                print('Input file is -->', inputfile)
                print('Output file is -->', outputfile)

if __name__ == "__main__":
    main(sys.argv[1:])
