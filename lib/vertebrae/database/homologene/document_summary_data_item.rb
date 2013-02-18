require 'rexml/element'

module Vertebrae
module Database
module HomoloGene
	class DocumentSummaryDataItem

		public

		attr_reader :gid
		attr_reader :tid

		attr_accessor :symbol
		attr_accessor :taxonomy
		attr_accessor :title

		def initialize(root = nil)
			return unless root
			build(root)
		end

		def clone()
			copy = DocumentSummaryDataItem.new()
			copy.gid = gid
			copy.symbol = symbol
			copy.taxonomy = taxonomy
			copy.tid = tid
			copy.title = title

			return copy
		end

		# def symbol()
		# 	return @symbol.clone()
		# end

		# def taxonomy()
		# 	return @taxonomy.clone()
		# end

		# def title()
		# 	return @title.clone()
		# end

		protected

		def build(root)
			root.each_element do |element|
				case element.name
				when "GeneID"
					@gid = element.text.to_i()
				when "Symbol"
					@symbol = element.text
				when "TaxId"
					@tid = element.text.to_i()
				when "TaxName"
					@taxonomy = element.text
				when "Title"
					@title = element.text
				end
			end
		end

		def gid=(gid)
			@gid = gid
		end

		def symbol=(symbol)
			@symbol = symbol
		end

		def tid=(tid)
			@tid = tid
		end

		def taxonomy=(taxonomy)
			@taxonomy = taxonomy
		end

		def title=(title)
			@title = title
		end

	end
end
end
end