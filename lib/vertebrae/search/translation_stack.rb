require 'rexml/element'
require 'vertebrae/search/term_set'

module Vertebrae
module Search
	class TranslationStack

		public

		def initialize(root = nil)
			return unless root
			build(root)
		end

		def clone()
			copy = TranslationStack.new()
			copy.operators = operators
			copy.terms = terms
		end

		def operators()
			if not @operators
				return Array.new()
			end

			copy = Array.new(@operators.length)

			@operators.each.with_index do |operator, i|
				copy[i] = operator.clone()
			end

			return copy
		end

		def terms()
			if not @terms
				return Array.new()
			end
			
			copy = Array.new(@terms.length)

			@terms.each.with_index do |term, i|
				copy[i] = term.clone()
			end

			return copy
		end

		protected

		def build(root)
			root.each_element do |element|
				case element.name
				when "OP"
					@operators ||= Array.new()
					@operators << element.text
				when "TermSet"
					@terms ||= Array.new()
					@terms << TermSet.new(element)
				else
					# Handle Error!
				end
			end
		end

		def operators=(operators)
			@operators = operators
		end

		def terms=(terms)
			@terms = terms
		end

	end
end
end