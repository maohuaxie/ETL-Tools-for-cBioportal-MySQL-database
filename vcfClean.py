# -*- coding: utf-8 -*-
"""
Created on Tue Sep 12 08:53:59 2017

@author: maohuaxie
"""

import pandas as pd
import numpy as np 
import os
import glob
print(os.getcwd())
root_dir=("D:/bioinformatics/copytxt")
os.chdir(root_dir)
for file in glob.iglob("*.txt"):
    df = pd.read_table(file, comment="#")
    df=df[df['Pipeline']=="bwa-mem->varscan"]
    df=df[['Chr', 'Start', 'End', 'Ref', 'Alt', 'Qual', 'Filters','Info', 'Format', 'Sample1',
       'Sample2']]
    #df['Sample1']=df['Sample1'].str.findall(r'(?<=\()[^(]*(?=\))')
    df.rename(columns={'Chr':'CHROM','End':'ID','Ref':'REF','Alt':'ALT','Qual':'QUAL','Filters':'FILTER','Info':'INFO','Format':'FORMAT'}, inplace=True)
    df['ID']=np.zeros(len(df))
    df['Sample1']=df['Sample1'].apply(lambda st: st[st.find("(")+1:st.find(")")])
    df['Sample2']=df['Sample2'].apply(lambda st: st[st.find("(")+1:st.find(")")])
    df.to_csv(r"D:/bioinformatics/copytxtm/" + file, sep='\t', index=False, header=True)
