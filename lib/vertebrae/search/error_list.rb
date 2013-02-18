require 'rexml/element'

module Vertebrae
module Search
	class ErrorList

		public

		def initialize(root = nil)
			return unless root
			build(root)
		end

		def clone()
			copy = ErrorList.new()
			copy.missing_fields = missing_fields
			copy.missing_phrases = missing_fields

			return copy
		end

		def missing_fields()
			if not @missing_fields
				return Array.new()
			end

			copy = Array.new(@missing_fields.length)

			@missing_fields.each.with_index do |field, i|
				copy[i] = field.clone()
			end

			return copy
		end

		def missing_phrases()
			if not @missing_phrases
				return Array.new()
			end
			
			copy = Array.new(@missing_phrases.length)

			@missing_phrases.each.with_index do |phrase, i|
				copy[i] = phrase.clone()
			end

			return copy
		end

		protected

		def build(root)
			root.each_element do |element|
				case element.name
				when "FieldNotFound"
					@missing_fields ||= Array.new()
					@missing_fields << element.text
				when "PhraseNotFound"
					@missing_phrases ||= Array.new()
					@missing_phrases << element.text
				else
					# Handle Error!
				end
			end
		end

	end
end
end