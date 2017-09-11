import os
os.chdir("D:/bioinformatics/copyvcf3")
for f in os.listdir():
    f_name,f_ext = os.path.splitext(f)
    f1=f_name.split('-')[0]
    f2=f_name.split('-')[1]
    newname='{}-{}{}'.format(f1,f2,f_ext)
    os.rename(f,newname)
    
