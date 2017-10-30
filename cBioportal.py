
# load libraries
import pandas as pd
import numpy as np
import math
import sys


def get_mutation_data(gene):
    """
    connect to cBioPortal API and request the MUTATION dataset
    containing provided gene of interest
    input is gene
    output is the panda dataframe
    """

    request = 'http://www.cbioportal.org/webservice.do?cmd=getProfileData&genetic_profile_id=gbm_tcga_mutations&id_type=gene_symbol&gene_list=%s&case_set_id=gbm_tcga_cnaseq'%(gene)
    mut_data = pd.read_table(request, skiprows=2, sep='\t', header=None) #first two extra lines are skipped
    return mut_data


def get_cna_data(gene):
    """
    connect to cBioPortal API and request the Copy_Number_Alternation(CNA) dataset
    containing provided gene of interest
    input is gene
    output is the panda dataframe
    """


    request = 'http://www.cbioportal.org/webservice.do?cmd=getProfileData&genetic_profile_id=gbm_tcga_gistic&id_type=gene_symbol&gene_list=%s&case_set_id=gbm_tcga_cnaseq'%(gene)
    cna_data = pd.read_table(request,skiprows=2, sep='\t', header=None) #first two extra lines are skipped
    return cna_data


def mutation_cal(mut_data):
    """
    calculate the number of cases contain gene mutation
    input: gene mutation data frame; return value of get_mutation_data() function
    output: number of patient, list of patient index that contains gene mutation
    """

    total_col = mut_data.shape[1]
    mut_patient_list = []
    for i in range(2, total_col):
        try:
            # NaN denotes normal
            math.isnan(mut_data.ix[1, i])
        except:
            # the specific patient index contains mutation
            mut_patient_list.append(i)
    return total_col-2, mut_patient_list


def cna_cal(cna_data):
    """
    calculate the number of cases contain Copy Number Alteration (cna)
    input: gene cna data frame; return value of get_cna_data() function
    output: number of patient, list of patient index that contains cna
    """

    total_col = cna_data.shape[1]
    cna_patient_list = []
    for i in range(2, total_col):
        # -2 denotes both copies of the gene are deleted;
        # 2 denotes multiple copies of the gene
        if (cna_data.ix[1, i] == '-2' or cna_data.ix[1, i] == '2'):
             cna_patient_list.append(i)
    return total_col-2, cna_patient_list

def main():
    # the program only can handle up to three genes of interest (arguments)

    # case1: no gene or too many genes are provided
    if (len(sys.argv)==1 or len(sys.argv)>4):
        print ("Please input gene(s) of interest (up to three genes)")

    # case2: one gene is provided
    elif (len(sys.argv) ==2):
        try:
            gene = str(sys.argv[1]).upper()
            mut_data = get_mutation_data(gene)
            sample_size, mut_patient_list = mutation_cal(mut_data)
            cna_data = get_cna_data(gene)
            sample_size, cna_patient_list = cna_cal(cna_data)
            print('{} is mutated in {}% of all cases.'.format(gene, round(len(mut_patient_list)/sample_size*100)))
            print('{} is copy number altered in {}% of all cases.'.format(gene, round(math.ceil(len(cna_patient_list)/sample_size*100))))

            total_case = np.union1d(mut_patient_list, cna_patient_list)
            print('\nTotal % of cases where {} is altered by either mutation or copy number alternation: {}% of all cases.'.format(gene, round(int(len(total_case)/sample_size*100))))
        except:
                print('invalid gene input {}'.format(str(sys.argv[1])))

    # case3: 1-3 genes are provided
    else:
        gene_set_cases = []
        total_case = -1
        for i in range (1, len(sys.argv)):
            try:
                gene = str(sys.argv[i]).upper()
                mut_data = get_mutation_data(gene)
                sample_size, mut_patient_list = mutation_cal(mut_data)
                cna_data = get_cna_data(gene)
                sample_size, cna_patient_list = cna_cal(cna_data)
                total_case = np.union1d(mut_patient_list, cna_patient_list)
                print('{} is altered in {}% of cases.'.format(gene, round(len(total_case)/sample_size*100)))
                gene_set_cases = np.union1d(gene_set_cases, total_case)
                total_case = sample_size
            except:
                print('invalid gene input {}'.format(str(sys.argv[i])))
        print('\nThe gene set is altered in {}% of all cases.'.format(int(len(gene_set_cases)/total_case*100)))
    return

if __name__ == "__main__":
    main()
