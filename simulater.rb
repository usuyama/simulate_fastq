require "./seq_lib.rb"
@region = "chr21:17438150-17438299"
@chr = "chr21"
LEFT_POS = 17438150
REF  = "TTAATTCCATCAGGATCCTTAATTATCCTTTGCTACATAATGTAATATATGCAGTTTCTAGGGATCAGGATGTGGAAAATTTTGGAGGACCATCTATCTGTCACCTAAGAGGAAATAACTCAGAAGAGGCTGTTGAAACCAAAAAGCAA"
DNA = ["A", "T", "G", "C"]
ERROR_RATE = 0.01
READ_SIZE=75
a = ARGV[0].to_f
N = ARGV[1].to_i
@fn = [0.5, 0.5]
@ft = [0.5, 0.5-a, a/2.0, a/2.0]
p @fn
p @ft

@h1 = Haplotype.new
@h2 = Haplotype.new([Variant.new(83,"-GGA")])
@h3 = Haplotype.new([Variant.new(86,"-GGA")])
@h4 = Haplotype.new([Variant.new(83,"T=>A")])
@hn = [	@h1, @h4]
@ht = [	@h1, @h4, @h2,@h3]



p @hn
p @ht
@normal_reads = []
N.times do 
		r = rand()
		i = 0
		th = 0.0
		1.upto(@fn.size()) do
				th += @fn[i]
				if th > r
						break
				else	
						i += 1
				end
		end
		@normal_reads.push(@hn[i].gen_read())
end

@tumor_reads = []
N.times do 
		r = rand()
		i = 0
		th = 0.0
		1.upto(@ft.size()) do
				th += @ft[i]
				if th > r
						break
				else	
						i += 1
				end
		end
		@tumor_reads.push(@ht[i].gen_read())
end


File.open("out_normal", "w") do |f|
		@count = 0
		for r in @normal_reads.sort {|a,b| a<=>b }
				f.write("@seq#{@count+=1}\n#{r[0]}\n+seq#{@count}\n#{r[1]}\n")
		end
end

File.open("out_tumor", "w") do |f|
		@count = 0
		for r in @tumor_reads.sort {|a,b| a<=> b}
				f.write("@seq#{@count+=1}\n#{r[0]}\n+seq#{@count}\n#{r[1]}\n")
		end
end
