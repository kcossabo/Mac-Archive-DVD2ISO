#!/bin/bash
# 
#  Kevin Cossaboon
#  kevin@cossaboon.net
#  Developed on OS X 10.11.6
# 
#    Application to archive CD/DVD to ISO files, with a text file of the files in the ISO
#
#    Use is to move data from CD/DVD   to diskdrive ISO files, and have a text file to search
#    the files in the ISO to know where the files are
#
#
#
#
#    Variables
#    ---------
#
#    default        -> temp to hold the path to ISO to confirm with user 
#    dup            -> var to add # to file name to make unique ISO Name
#    user1          -> used to stop app after ISO creation, or loop to next
#    id             -> populates with the /dev of the CDRom Drive when inserted
#    out_put_path   -> the path to ISO file strage
#    Volume_Name    -> the mount point in /Volumes where the CD is mounted
#    File_Name      -> File name to use for ISO file
#    File_Name_org  -> Temp var used to prefex file name if needed

#
#
# 
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
# 
# 

#change to directory to hold ISO images

echo "This program will create an ISO of a CD"
echo ""

default="/Volumes/Drobo/CD_Backup"
read -p "Enter the Path to store the CD images[$default]: " out_put_path
out_put_path=${out_put_path:-$default}


# create a file for all files from all CDs
touch $out_put_path/All_ISO.txt



user1="c"

echo "insert CD, or CTL-C to abbort"
echo " "

while [ "$user1" != "e" ]
do
    id=" "
    #####################################################################################
    #                                                                                   #
    # Wait until CD is detected                                                         #
    #                                                                                   #
    #####################################################################################
    
    until [[ "$id" =~ /dev/disk* ]]
        do
            id=$(drutil status |grep -m1 -o '/dev/disk[0-9]*')
        done
    
    # grep -m1
    #    Stop reading a file after num matching lines
    #    So reads the first line 
    # -o
    #    Print only the matched (non-empty) parts of matching lines, 
    #    with each such part on a separate output line.
    # /dev/disk[0-9]*
    #    returns the /dev/diskxx where xx can be any number, matching 0-9 for the first, 
    #    and then the rest
    #
    #    the result is the the first line is matched, with the /dev returned
    

        #####################################################################################
        #                                                                                   #
        # Wait until CD is mounted to /Volume                                               #
        #                                                                                   #
        #####################################################################################

       
        Volume_Name=" "
        until [[ $Volume_Name =~ /Volume* ]]
            do
                Volume_Name=$(df | grep "$id" |grep -o /Volumes.*)
                # double layer Grep
                # first looks through df output for the /dev
                # then pass that line to grep to only include the mount point on /Volume
            done
        
        #####################################################################################
        #                                                                                   #
        # Ask user for file name, offer CD name                                             #
        #                                                                                   #
        #####################################################################################
        

        default=${Volume_Name##*/}
        File_Name=""

       
        read -p "Enter desired filename [$default]: " File_Name
        File_Name=${File_Name:-$default}

        #####################################################################################
        #                                                                                   #
        # modife file name if file exists                                                   #
        #                                                                                   #
        #####################################################################################

       File_Name_org=$File_Name
       dup=1
       while [ -f "$out_put_path/$File_Name.iso" ] 
           do
               let "dup += 1"
               File_Name="$File_Name_org-0$dup"
           done
        
        echo " "
        echo "... file name will be: $File_Name "
        echo "... in the Directory : $out_put_path "
        echo "... in the Volume is : $Volume_Name "
        echo " "
        echo "... excecuting command"
        echo "hdiutil makehybrid -o  "$out_put_path/$File_Name.iso" "$Volume_Name""
        echo " "

# temp to debug
# touch "$out_put_path/$File_Name.iso"
        hdiutil makehybrid -o  "$out_put_path/$File_Name.iso" "$Volume_Name"
# should set a variable to make sure hdiutil exited with no error




        echo " "
        ls -lhR "$Volume_Name" | awk {'print $9" :  "$6" "$7" "$8" :  "$5'} > "$out_put_path/$File_Name.txt"
        echo "########################################################################################" >> $out_put_path/All_ISO.txt
        echo $File_Name.iso >> $out_put_path/All_ISO.txt
        echo "########################################################################################" >> $out_put_path/All_ISO.txt
        ls -lhR "$Volume_Name" | awk {'print $9" :  "$6" "$7" "$8" :  "$5'} >> "$out_put_path/All_ISO.txt"
        echo "... iso is made, ejecting CD"
        drutil eject
        echo " "
        read -n1 -r -p "Insert new CD and Press space to continue... or e to exit" user1
        echo " "

done
echo " "
echo " "
echo "... program ended"
echo " "
