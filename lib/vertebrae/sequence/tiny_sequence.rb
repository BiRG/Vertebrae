require 'rexml/element'

module Vertebrae
module Sequence
	class TinySequence

		public

		attr_reader :gi
		attr_reader :length
		attr_reader :tid

		def initialize(root = nil)
			return unless root
			build(root)
		end

		def clone()
			copy = TinySequence.new()
			copy.accession = accession
			copy.definition = definition
			copy.gi = gi
			copy.length = length
			copy.local = local
			copy.sequence = sequence
			copy.sid = sid
			copy.taxonomy = taxonomy
			copy.tid = tid

			return copy
		end

		def accession()
			if not @accession
				return String.new()
			end
			return @accession.clone()
		end

		def definition()
			if not @definition
				return String.new()
			end
			return @definition.clone()
		end

		def local()
			if not @local
				return String.new()
			end
			return @local
		end

		def sequence()
			if not @sequence
				return String.new()
			end
			return @sequence.clone()
		end

		def sid()
			if not @sid
				return String.new()
			end
			return @sid.clone()
		end

		def taxonomy()
			if not @taxonomy
				return String.new()
			end
			return @taxonomy.clone()
		end

		protected

		def build(root)
			root.each_element do |element|
				case element.name
				when "TSeq_accver"
					@accession = element.text
				when "TSeq_defline"
					@definition = element.text
				when "TSeq_gi"
					@gi = element.text.to_i()
				when "TSeq_length"
					@length = element.text.to_i()
				when "TSeq_local"
					@local = element.text
				when "TSeq_orgname"
					@taxonomy = element.text
				when "TSeq_sequence"
					@sequence = element.text
				when "TSeq_sid"
					@sid = element.text
				when "TSeq_taxid"
					@tid = element.text.to_i()
				when "TSeq_type"
					@type = element.attribute("value").value
				end
			end
		end

		def accession=(accession)
			@accession = accession
		end

		def definition=(definition)
			@definition = definition
		end

		def gi=(gi)
			@gi = gi
		end

		def length=(length)
			@length = length
		end

		def local=(local)
			@local = local
		end

		def sequence=(sequence)
			@sequence = sequence
		end

		def sid=(sid)
			@sid = sid
		end

		def taxonomy=(taxonomy)
			@taxonomy = taxonomy
		end

		def tid=(tid)
			@tid = tid
		end

	end
end
end