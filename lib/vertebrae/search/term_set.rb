require 'rexml/element'

module Vertebrae
module Search
	class TermSet

		public

		attr_reader :count

		def initialize(root = nil)
			return unless root
			build(root)
		end

		def clone()
			copy = TermSet.new()
			copy.count = count
			copy.exploded = exploded
			copy.field = field
			copy.term = term

			return copy
		end

		def exploded?()
			return @exploded
		end

		def field()
			return @field.clone()
		end

		def term()
			return @term.clone()
		end

		protected

		def build(root)
			root.each_element do |element|
				case element.name
				when "Count"
					@count = element.text.to_i()
				when "Explode"
					if element.text == "Y"
						@exploded = true
					else
						@exploded = false
					end
				when "Field"
					@field = element.text
				when "Term"
					@term = element.text
				else
					# Handle Error!
				end
			end
		end

		def count=(count)
			@count = count
		end

		def exploded=(exploded)
			@exploded = exploded
		end

		def field=(field)
			@field = field
		end

		def term=(term)
			@term = term
		end

	end
end
end