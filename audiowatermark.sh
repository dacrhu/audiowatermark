#!/bin/bash

##################################################################################
# Very simple analog audio watermark script.                                     #
# Writen by David Horvath <dacr@dacr.hu>                                         #
##################################################################################

##################################################################################
# MIT License                                                                    #
#                                                                                #
# Copyright (c) 2023 David Horvath <dacr@dacr.hu>                                #
#                                                                                #
# Permission is hereby granted, free of charge, to any person obtaining a copy   #
# of this software and associated documentation files (the "Software"), to deal  #
# in the Software without restriction, including without limitation the rights   #
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell      #
# copies of the Software, and to permit persons to whom the Software is          #
# furnished to do so, subject to the following conditions:                       #
#                                                                                #
# The above copyright notice and this permission notice shall be included in all #
# copies or substantial portions of the Software.                                #
#                                                                                #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR     #
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,       #
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE    #
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER         #
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  #
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  #
# SOFTWARE.                                                                      #
##################################################################################

INPUT=$1
OUTPUT=$2
WMRATE=$3

if [ "$WMRATE" == "" ]; then
        echo "###########################################################"
        echo "Usage: $0 input.wav output.wav rate_of_watermark_in_seconds"
        echo ""
        echo "Example:"
        echo "  $0 mymusic.wav mymusic_wm.wav 10"
        echo "  (There will be a beep in the music every 10 seconds)"
        echo "###########################################################"
        exit -1
fi

# generate a sine wave
sox -n -c2 -r 44100 wm.wav synth 1 sine 500

# make output file
cp $INPUT $OUTPUT

# calculate values
LENGTH=$(sox $INPUT -n stat 2>&1 | grep Length | awk {'print $3'} | cut -d"." -f1)
RATE=$(( $LENGTH / $WMRATE ))

# make splits in loops
for i in $( eval echo {1..$RATE} ) ; do
    START=$(( $i * $WMRATE ))
    END=$(( $START + 1 ))
    sox "|sox $OUTPUT -p trim 0 $START" \
        wm.wav \
        "|sox $INPUT -p trim $END $LENGTH" \
        wmouttemp.wav
    cp wmouttemp.wav $OUTPUT
done

# remove temp files
rm wmouttemp.wav
rm wm.wav
