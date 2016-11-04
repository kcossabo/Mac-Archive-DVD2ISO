# Mac-Archive-DVD2ISO
Bash script to archive old CDs and DVDs to ISO files on the HDD
#  Kevin Cossaboon
#  kevin@cossaboon.net
#  Developed on OS X 10.11.6
# 
#    Application to archive CD/DVD to ISO files, with a text file of the files in the ISO
#
#    Use is to move data from CD/DVD   to diskdrive ISO files, and have a text file to search
#    the files in the ISO to know where the files are
# Special Thank you to;
# 
# http://www.theinstructional.com Disk Management From the Command-Line, Part 3 for the tip
# 	hdiutil
# 	
# Andrew Harsh on http://osxdaily.com for the tip
# 	pointing me to dd command
# 
# Zan Lynx on http://stackoverflow.com for the tip
# 	to use # and % operators in Bash to extract filenames
# 	
# http://tldp.org Advanced Bash-Scripting Guide
# 
# AleksanderKseniya on http://unix.stackexchange.com for the tip
# 		read -n1 -r -p "Press space to continue..." key
# 
# david_ross on http://www.linuxquestions.org for the tip
# 	ls -lR | awk {'print $5" "$6" "$7" "$8" "$9'}
# 
