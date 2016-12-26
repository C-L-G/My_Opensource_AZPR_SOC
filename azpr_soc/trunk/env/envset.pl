#!/usr/bin/perl -w
#****************************************************************************************************	
#-----------------Copyright (c) 2016 C-L-G.FPGA1988.lichangbeiju. All rights reserved------------------
#
#		    --		    It to be define		   --
#		    --			  ...			   --
#		    --			  ...			   --
#		    --			  ...			   --
#**************************************************************************************************** 
#File Information
#**************************************************************************************************** 
#File Name	    : envset.pl
#Project Name	: azpr_soc
#Description	: The environment sets.
#Github Address : https://github.com/C-L-G/scripts/script_header.txt
#License	    : CPL
#**************************************************************************************************** 
#Version Information
#**************************************************************************************************** 
#Create Date	: 2016-07-01 17:00
#Author	        : lichangbeiju
#Modify Date	: 2016-12-26 14:20
#Last Author	: lichangbeiju
#**************************************************************************************************** 
#Change History(latest change first)
#yyyy.mm.dd - Author - Your log of change
#**************************************************************************************************** 
#2016.12.26 - lichangbeiju - Modify the script base on gt5232&gt5238.
#2016.07.03 - lichangbeiju - Add the File information and the version info.
#2016.07.02 - lichangbeiju - The initial version.
#----------------------------------------------------------------------------------------------------


##***************************************************************************************************
## 1.Get the pwd directory
##***************************************************************************************************

##---------------------------------------------------------------------------------------------------
## l.1 get the pwd directory
##---------------------------------------------------------------------------------------------------
$root_dir = $ENV{PWD};
print "$root_dir\n";
# find the last /xxx and delete it[delete the /env].
# $1 = /env
$root_dir =~ s/\/(\w+)$//;

print "$root_dir\n";


##---------------------------------------------------------------------------------------------------
## l.2 open and write the env file
##---------------------------------------------------------------------------------------------------

$file_name = "azpr_soc.env";
if(-e $file_name){
    print "$file_name has exist,it will be deleted.\n";
    system "rm -f $file_name";
}

#use > decide the next print operate : to cover the content
#
open (ENV_FILE,"> $file_name") or die "cannot open the $file_name for writing : $!";


#write the file
#the 1st print will cover all of the content
print ENV_FILE "$! bin/csh/ -f\n";
#
print ENV_FILE "setenv azpr_soc $root_dir\n";
#set path : set the command search path such as runn
print ENV_FILE "set path = (\$azpr_soc/env \$azpr_soc/digital/bin \$path)\n";

#the user command define
print ENV_FILE "alias cdenv \`cd \$root_dir\/env\`\n";
print ENV_FILE "alias cdbin \`cd \$azpr_soc\/digital/bin\`\n";
print ENV_FILE "alias cdrtl \`cd \$azpr_soc\/digital/rtl\`\n";
print ENV_FILE "alias cdtb  \`cd \$azpr_soc\/digital/verif/tb\`\n";
print ENV_FILE "alias cdtc  \`cd \$azpr_soc\/digital/verif/tc\`\n";

print ENV_FILE "source /tool/sge/default/common/setting.csh\n\n" 

close (ENV_FILE) or die "cannot close $file_name : $!";ss



