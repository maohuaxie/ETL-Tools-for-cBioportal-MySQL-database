# -*- coding: utf-8 -*-
"""
Created on Tue Sep 12 09:47:14 2017

@author: maohuaxie
"""

# -*- coding: utf-8 -*-
"""
Created on Tue Sep 12 08:53:59 2017

@author: maohuaxie
"""

import pandas as pd
import os
import glob
print(os.getcwd())
root_dir=("D:/bioinformatics/copytxtm")
os.chdir(root_dir)
for file in glob.iglob("*.txt"):
    dfhead=pd.read_table("D:/bioinformatics/vcfcom/combined.txt")
    df = pd.read_table(file, header= None, comment="#")
    dfcombined=pd.concat([dfhead, df], ignore_index=True)
    dfcombined.to_csv(r"D:/bioinformatics/vcfcom/" + file, sep='\t', index=False, header=True)
