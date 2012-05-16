depth=$1
mix_rate=$2
del_len=$3
count=$4
out_f=$5
bwa=path_to_bwa
ref

out=$out_f/d${depth}_m${mix_rate}_l${del_len}
mkdir $out

for $i in `seq 1 $count`
do
		mkdir $out/$i
		cd $out/$i
		ruby $simulate_del $mix_rate $depth $del_len
		$bwa aln -f normal.bam $ref out_normal
		$bwa aln -f tumor.bam $ref out_tumor
		sh $mutation_call $out/$i/normal.bam $out/$i/tumor.bam $out/$i
done

