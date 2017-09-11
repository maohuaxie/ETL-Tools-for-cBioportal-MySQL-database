#!/usr/bin/bash
#Prepare the tools for emory cbioportal automate process pipeline.
# Exit this script on any error.
set -euo pipefail
cd ~/vcftotal
for i in *[0-9].vcf; 
do 
perl ~/vcf2maf/vcf2maf.pl --input-vcf $i \
--output-maf ${i%.*}.maf \
--tumor-id ${i%.*}-01 \
--vcf-tumor-id Sample1 \
--vcf-normal-id NORMAL \
--custom-enst ~/vcf2maf/data/isoform_overrides_uniprot \
--remap-chain ~/vcf2maf/data/hg19_to_GRCh37.chain; 
done
(head -2 emh-13786.maf && tail -n +3 -q *.maf ) > ~/total.maf # Merge all MAF file into one, emh-13786 was picked for get the header, please note: save 
#total.maf to new directory in order to escape infinite loop.

