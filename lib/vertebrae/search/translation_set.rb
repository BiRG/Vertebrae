require 'rexml/element'
require 'vertebrae/search/translation'

module Vertebrae
module Search
	class TranslationSet

		public

		def initialize(root = nil)
			return unless root
			build(root)
		end

		def clone()
			copy = TranslationSet.new()
			copy.translations = translations

			return copy
		end

		def translations()
			if not @translations
				return Array.new()
			end
			
			copy = Array.new(@translations.length)

			@translations.each.with_index do |translation, i|
				copy[i] = translation.clone()
			end

			return copy
		end

		protected

		def build(root)
			root.each_element do |element|
				case element.name
				when "Translation"
					@translations ||= Array.new()
					@translations << Translation.new(element)
				else
					# Handle Error!
				end
			end
		end

		def translations=(translations)
			@translations = translations
		end

	end
end
end