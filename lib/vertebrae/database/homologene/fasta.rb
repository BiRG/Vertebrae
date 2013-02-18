module Vertebrae
module Database
module HomoloGene
	class Fasta

		public

		def initialize(fasta)
			@groups = Hash.new()
			build(fasta)
		end

		def groups()
			copy = Hash.new(@groups.length)

			@groups.each do |key, value|
				copy[key] = value
			end

			return copy
		end

		def has_error?()
			return @has_error
		end

		protected

		def build(fasta)
			header = /(?<=HomoloGene:)[0-9]+(?=.*[\n]+)/
			gi = /(?<=>gi\|)[0-9]+(?=.*[\n]+)/
			error = /<Fetch Error>/

			current_hid = nil

			fasta.lines.each do |line|
				if error.match(line)
					@has_error = true
					current_hid = nil
				end

				match = header.match(line)

				if match
					current_hid = match[0].to_i()
					@groups[current_hid] ||= Array.new()
				end

				match = gi.match(line)

				if match and current_hid
					@groups[current_hid] << match[0].to_i()
				end
			end
		end

	end
end
end
end