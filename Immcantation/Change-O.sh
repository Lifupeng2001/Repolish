##IGHC.fasta
cd ~/Dandelion/germlines/imgt_human_IGHC.fasta 


# Download and extract IgBLAST
VERSION="1.22.0"
wget https://ftp.ncbi.nlm.nih.gov/blast/executables/igblast/release/${VERSION}/ncbi-igblast-${VERSION}-x64-linux.tar.gz
tar -zxf ncbi-igblast-${VERSION}-x64-linux.tar.gz
cp ncbi-igblast-${VERSION}/bin/* ~/mambaforge/envs/Change-O/bin
#Download reference databases and setup IGDATA directory
fetch_igblastdb.sh -o ~/mambaforge/envs/Change-O/share/igblast
cp -r ncbi-igblast-${VERSION}/internal_data ~/mambaforge/envs/Change-O/share/igblast
cp -r ncbi-igblast-${VERSION}/optional_file ~/mambaforge/envs/Change-O/share/igblast

#Build IgBLAST database from IMGT reference sequences
fetch_imgtdb.sh -o ~/mambaforge/envs/Change-O/share/germlines/imgt
imgt2igblast.sh -i ~/mambaforge/envs/Change-O/share/germlines/imgt -o ~/mambaforge/envs/Change-O/share/igblast

cat IMGT_Human_IGHV.fasta IMGT_Human_IGKV.fasta IMGT_Human_IGLV.fasta > imgt_human_ig_v.fasta
cp IMGT_Human_IGHD.fasta imgt_human_ig_d.fasta
cat IMGT_Human_IGHJ.fasta IMGT_Human_IGKJ.fasta IMGT_Human_IGLJ.fasta > imgt_human_ig_j.fasta
cat IMGT_human_IGHC_fixed.fasta IMGT_Human_IGKC.fasta IMGT_Human_IGLC.fasta > imgt_human_ig_c.fasta

sed '
/J-REGION/s/|IGLJ-C\/OR18\*01|/|IGLJ-C\/OR18\*01_J|/g
/C-REGION/s/|IGLJ-C\/OR18\*01|/|IGLJ-C\/OR18\*01_C|/g
' ~/mambaforge/envs/Change-O/bin/imgt_human_ig_c.fasta > ~/mambaforge/envs/Change-O/bin/imgt_human_ig_c_fixed.fasta

#V segment database
edit_imgt_file.pl imgt_human_ig_v.fasta > ~/mambaforge/envs/Change-O/share/igblast/fasta/imgt_human_ig_v.fasta
makeblastdb -parse_seqids -dbtype nucl -in ~/mambaforge/envs/Change-O/share/igblast/fasta/imgt_human_ig_v.fasta \
    -out ~/mambaforge/envs/Change-O/share/igblast/database/imgt_human_ig_v
#D segment database
edit_imgt_file.pl IMGT_Human_IGHD.fasta > ~/mambaforge/envs/Change-O/share/igblast/fasta/imgt_human_ig_d.fasta
makeblastdb -parse_seqids -dbtype nucl -in ~/mambaforge/envs/Change-O/share/igblast/fasta/imgt_human_ig_d.fasta \
    -out ~/mambaforge/envs/Change-O/share/igblast/database/imgt_human_ig_d
#J segment database
edit_imgt_file.pl imgt_human_ig_j.fasta > ~/mambaforge/envs/Change-O/share/igblast/fasta/imgt_human_ig_j.fasta
makeblastdb -parse_seqids -dbtype nucl -in ~/mambaforge/envs/Change-O/share/igblast/fasta/imgt_human_ig_j.fasta \
    -out ~/mambaforge/envs/Change-O/share/igblast/database/imgt_human_ig_j
#Constant region database
edit_imgt_file.pl imgt_human_ig_c_fixed.fasta > ~/mambaforge/envs/Change-O/share/igblast/fasta/imgt_human_ig_c.fasta
makeblastdb -parse_seqids -dbtype nucl -in ~/mambaforge/envs/Change-O/share/igblast/fasta/imgt_human_ig_c.fasta \
    -out ~/mambaforge/envs/Change-O/share/igblast/database/imgt_human_ig_c


#重新注释
AssignGenes.py igblast -s filtered_contig.fasta -b ~/mambaforge/envs/Change-O/share/igblast \
   --organism human --loci ig --format blast
MakeDb.py igblast \
  -i filtered_contig_igblast.fmt7 \
  -s filtered_contig.fasta \
  -r ~/mambaforge/envs/Change-O/share/germlines/imgt/human/vdj/ \
  --10x filtered_contig_annotations.csv \
  --extended \
  -o filtered_contig_db.tsv


#分离IGH/IGL
ParseDb.py select -d combined_filtered_contig_db.tsv -f locus -u "IGH" \
        --logic all --regex --outname heavy
ParseDb.py select -d combined_filtered_contig_db.tsv -f locus -u "IG[LK]" \
        --logic all --regex --outname light

output（heavy_parse-select.tsv，light_parse-select.tsv）


#克隆型聚类
DefineClones.py -d heavy_parse-select.tsv --act set --model ham \
    --norm len --dist 0.08425864538140848
output= "heavy_parse-select_clone-pass.tsv"

#根据轻链数据校正克隆组
light_cluster.py -d heavy_parse-select_clone-pass.tsv -e light_parse-select.tsv \
        -o BCR_heavy_final_clone-pass.tsv

##与germline做比对
CreateGermlines.py -d BCR_final_Change-O.tsv -g dmask --cloned \
    -r IMGT_Human_IGHV.fasta IMGT_Human_IGHD.fasta IMGT_Human_IGHJ.fasta