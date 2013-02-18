require 'rexml/element'

module Vertebrae
module Search
	class WarningList

		public

		def initialize(root = nil)
			return unless root
			build(root)
		end

		def clone()
			copy = WarningList.new()
			copy.ignored_phrases = ignored_phrases
			copy.messages = messages
			copy.missing_phrases = missing_phrases

			return copy
		end

		def ignored_phrases()
			if not @ignored_phrases
				return Array.new()
			end

			copy = Array.new(@ignored_phrases.length)

			@ignored_phrases.each.with_index do |phrase, i|
				copy[i] = phrase.clone()
			end

			return copy
		end

		def messages()
			if not @messages
				return Array.new()
			end

			copy = Array.new(@messages.length)

			@messages.each.with_index do |message, i|
				copy[i] = message.clone()
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
				when "PhraseIgnored"
					@ignored_phrases ||= Array.new()
					@ignored_phrases << element.text
				when "OutputMessage"
					@messages ||= Array.new()
					@messages << element.text
				when "QuotedPhraseNotFound"
					@missing_phrases ||= Array.new()
					@missing_phrases << element.text
				else
					# Handle Error!
				end
			end
		end

		def ignored_phrases=(ignored_phrases)
			@ignored_phrases = ignored_phrases
		end

		def messages=(messages)
			@messages = messages
		end

		def missing_phrases(missing_phrases)
			@missing_phrases = missing_phrases
		end

	end
end
end