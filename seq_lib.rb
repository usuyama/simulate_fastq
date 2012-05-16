class Variant
		attr_reader :type, :ref_pos, :length, :str, :seq
		attr_accessor :hap_pos
		def initialize(pos, str)
				@str = str
				@ref_pos = pos
				@hap_pos = pos
				if /(\w)=>(\w)/ =~ str
						@type = :snp
						@seq = $2
						@length = 1
				elsif /\+(\w+)/ =~ str
						@type = :ins
						@seq = $1
						@length = $1.length
				elsif /-(\w+)/ =~ str
						@type = :del
						@seq = $1
						@length = $1.length
				end
		end
		def inspect
				"#{@ref_pos}, #{@hap_pos} " + @str
		end
end

class Haplotype
		attr_reader :variants, :seq, :punc
		def initialize(vars=[])
				@variants = vars.sort {|a,b| a.ref_pos <=> b.ref_pos }
				gen_seq
				gen_punc
		end

		def inspect
				@seq
		end

		def gen_punc
				@punc = []
				for v in @variants
						if v.type == :snp
								next	
						elsif v.type == :ins
								@punc.push([:is, v.hap_pos])
								@punc.push([:ie, v.hap_pos+v.length])
						elsif v.type == :del
								@punc.push([:ds, v.hap_pos])
								@punc.push([:de, v.hap_pos+v.length])
						end
				end
		end

		def change_hap_pos(start, length)
				start.upto(@variants.size-1) do |i|
						@variants[i].hap_pos += length
				end
		end

		def gen_seq
				@seq = REF.dup
				i = 0
				for v in @variants
						i += 1
						if v.type == :snp
								@seq[v.hap_pos-1] = v.seq
						elsif v.type == :ins
								@seq = @seq[0..v.hap_pos-1] + v.seq + @seq[v.hap_pos..@seq.size-1]
								change_hap_pos(i, v.length)
						elsif v.type == :del
								@seq = @seq[0..v.hap_pos-1] + @seq[v.hap_pos+v.length..@seq.size-1]
								change_hap_pos(i, -v.length)
						end
				end	
		end


		def gen_read
				pos = rand(REF.length-READ_SIZE-1)
				read = @seq[pos, READ_SIZE]
				0.upto(read.size-1) do |i|
						if(rand() < ERROR_RATE)
								alt = read[i,1]
								while(alt==read[i,1])
										alt = DNA[rand(4)]
								end
								read[i] = alt
						end
				end
				[read, "+"*READ_SIZE]
		end
end
