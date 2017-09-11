# -*- coding: utf-8 -*-
"""
Created on Mon Sep 11 17:59:30 2017

@author: maohuaxie
"""

# -*- coding: utf-8 -*-
"""
Created on Mon Sep 11 08:25:43 2017

@author: maohuaxie
"""
# this code for parsing all the bwa-mem.allvariantcallers.final.hg19_multianno.txt files across the 
#(Q:/Pathology and EML/CLINICAL SPECIMENS/2016 and Q:/Pathology and EML/CLINICAL SPECIMENS/2017) directory and subdirectory.
import shutil
import os
import glob
print(os.getcwd())
root_dir=("Q:/Pathology and EML/CLINICAL SPECIMENS/2017")
#==============================================================================
# print(os.listdir(root_dir))
root = next(os.walk(root_dir))[0]
# print("roots= ",root)
dirs =  next(os.walk(root_dir))[1]
# print("dirs= ",dirs)
# file = next(os.walk(root_dir))[2]
# print("file= ",file)
#==============================================================================


for dr in dirs:
    subdir=os.path.join(root,dr)
    os.chdir(subdir)
    sdr = next(os.walk(subdir))[1]
    for ssdir in sdr:
        if ssdir =="Alt_Alignment":
             ssubdir=os.path.join(subdir,ssdir)
             os.chdir(ssubdir)
             for file in glob.iglob("*bwa-mem.allvariantcallers.final.hg19_multianno.txt"):
                        #src = os.path.join(ssubdir, file)  
                       dst = "D:/bioinformatics/copytxt"   
                       shutil.copy(file, dst)
        gsubdir=os.path.join(subdir,ssdir)
        gsdr=next(os.walk(gsubdir))[1]
        for gssdir in gsdr:
            if gssdir =="Alt_Alignment":
                sssubdir=os.path.join(gsubdir,gssdir)
                os.chdir(sssubdir)
                for file in glob.iglob("*bwa-mem.allvariantcallers.final.hg19_multianno.txt"):
                        #src = os.path.join(ssubdir, file)  
                       dst = "D:/bioinformatics/copytxt"   
                       shutil.copy(file, dst)
            ggsubdir=os.path.join(gsubdir,gssdir)
            ggsdr=next(os.walk(ggsubdir))[1]
            for ggssdir in ggsdr:
                if ggssdir =="Alt_Alignment":
                    ssssubdir=os.path.join(gsubdir,gssdir)
                    os.chdir(ssssubdir)
                    for file in glob.iglob("*bwa-mem.allvariantcallers.final.hg19_multianno.txt"):
                        #src = os.path.join(ssubdir, file)  
                       dst = "D:/bioinformatics/copytxt"   
                       shutil.copy(file, dst)
