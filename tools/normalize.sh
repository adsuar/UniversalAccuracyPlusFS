#!/bin/bash

# We get the descriptions file name
DESCRIPTIONS=$1
# We get the samples file name
SAMPLES=$2

# We create the new samples transposed file name
SAMPLES_transposed=".."`echo "$SAMPLES" | cut -d'.' -f3`.trans.`echo "$SAMPLES" | cut -d'.' -f4`

echo "DESCRIPTIONS FILE: $DESCRIPTIONS"
echo "SAMPLES FILE: $SAMPLES"
echo "NEW SAMPLES FILE: $SAMPLES_transposed"

# Transpose samples
# We call to our python routine to transpose the CSV samples file into a model
# that we can merge with the descriptions file.
./routines/transpose.py $SAMPLES $SAMPLES_transposed

# We change the name of each sample so we can merge both files easily.
sed -i 's/_neg.mzdata//g' $SAMPLES_transposed
sed -i 's/neg.mzdata//g' $SAMPLES_transposed

# We substitute unknown for an empty value
sed -i 's/unknown//g' $SAMPLES_transposed
sed -i 's/unknown//g' $DESCRIPTIONS

# We transform the cancer stage into numeric values
sed -i 's/stage 0/1/I' $DESCRIPTIONS
sed -i 's/Stage IIIA/9/I' $DESCRIPTIONS
sed -i 's/Stage IIIB/10/I' $DESCRIPTIONS
sed -i 's/Stage IIIC/11/I' $DESCRIPTIONS
sed -i 's/Stage IV/12/I' $DESCRIPTIONS
sed -i 's/stage IA\/IIA/4/I' $DESCRIPTIONS
sed -i 's/stage IA\/IIB/5/I' $DESCRIPTIONS
sed -i 's/stage IB/6/I' $DESCRIPTIONS
sed -i 's/Stage IIA/7/I' $DESCRIPTIONS
sed -i 's/Stage IIB/8/I' $DESCRIPTIONS
sed -i 's/stageIIIA/9/I' $DESCRIPTIONS
sed -i 's/stage ia/3/I' $DESCRIPTIONS
sed -i 's/stage i/2/I' $DESCRIPTIONS

# We transform the gender into numeric values
sed -i 's/,m,/,0,/I' $DESCRIPTIONS
sed -i 's/,f,/,1,/I' $DESCRIPTIONS

# We transform the cancer histology into numeric values
sed -i 's/,x,/,0,/I' $DESCRIPTIONS
sed -i 's/,y,/,1,/I' $DESCRIPTIONS
