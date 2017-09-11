    
# -*- coding: utf-8 -*-
"""
Created on Mon Sep 11 19:05:10 2017

@author: maohuaxie
"""
import os
os.chdir("D:/bioinformatics/copyvcf3")
for f in os.listdir():
    f_name,f_ext = os.path.splitext(f)
    f1=f_name.split('-')[0]
    f2=f_name.split('-')[1]
    newname='{}-{}{}'.format(f1,f2,f_ext)
    os.rename(f,newname)
    try:
        os.rename(f,newname)
    except WindowsError:
        os.remove(newname)
        os.rename(f, newname)
            
# -*- coding: utf-8 -*-
"""
Created on Mon Sep 11 19:05:10 2017

@author: maohuaxie
"""

import os
os.chdir("D:/bioinformatics/copytxt")
for f in os.listdir():
    f_name,f_ext = os.path.splitext(f)
    f1=f_name.split('-')[0]
    f2=f_name.split('-')[1]
    newname='{}-{}{}'.format(f1,f2,f_ext)
    try:
        os.rename(f,newname)
    except WindowsError:
        os.remove(newname)
        os.rename(f, newname)
        
