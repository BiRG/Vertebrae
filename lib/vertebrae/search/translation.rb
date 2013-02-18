require 'rexml/element'

module Vertebrae
module Search
	class Translation

		public

		def initialize(root = nil)
			return unless root
			build(root)
		end

		def clone()
			copy = Translation.new()
			copy.from = from
			copy.to = to

			return copy
		end

		def from()
			return @from.clone()
		end

		def to()
			return @to.clone()
		end

		protected

		def build(root)
			root.each_element do |element|
				case element.name
				when "From"
					@from = element.text
				when "To"
					@to = element.text
				else
					# Handle Error!
				end
			end
		end

		def from=(from)
			@from = from
		end

		def to=(to)
			@to = to
		end

	end
end
end