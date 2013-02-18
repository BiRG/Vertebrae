require 'rexml/document'
require 'rexml/element'
require 'vertebrae/sequence/tiny_sequence'

module Vertebrae
module Sequence
	class TinySequenceSet

		public

		def initialize(xml)
			@has_error = false
			@sequences = Hash.new()
			build(xml)
		end

		def has_error?()
			return @has_error
		end

		def sequences()
			copy = Hash.new()

			@sequences.each do |key, sequence|
				copy[key] = sequence.clone()
			end

			return copy
		end

		protected

		def build(xml)
			begin
				document = REXML::Document.new(xml)
			rescue
				@has_error = true
				return
			end

			root = document.root

			root.each_element do |element|
				case element.name
				when "TSeq"
					sequence = TinySequence.new(element)
					@sequences[sequence.gi] = sequence
				else
					@has_error = true
				end
			end
		end

	end
end
end