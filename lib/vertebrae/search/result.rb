require 'rexml/document'
require 'rexml/element'
require 'vertebrae/search/error_list'
require 'vertebrae/search/translation_set'
require 'vertebrae/search/translation_stack'
require 'vertebrae/search/warning_list'

module Vertebrae
module Search
	class Result

		public

		attr_reader :count
		attr_reader :maximum
		attr_reader :key
		attr_reader :start

		def initialize(xml)
			build(xml)
		end

		def environment()
			return @environment.clone()
		end

		def error()
			return @error.clone()
		end

		def error_list()
			return @error_list.clone()
		end

		def has_error?()
			return @has_error
		end

		def has_warning?()
			return @has_warning
		end

		def id_list()
			copy = Array.new(@id_list.length)

			@id_list.each.with_index do |id, i|
				copy[i] = id
			end

			return copy
		end

		def translation()
			return @translation.clone()
		end

		def translation_set()
			return @translation_set.clone()
		end

		def translation_stack()
			return @translation_stack.clone()
		end

		def warning_list()
			return @warning_list.clone()
		end

		protected

		def build(xml)
			document = REXML::Document.new(xml)
			root = document.root

			root.each_element do |element|
				case element.name
				when "Count"
					@count = element.text.to_i()
				when "ErrorList"
					@has_error = true
					@error_list = ErrorList.new(element)
				when "ERROR"
					@has_error = true
					@error = element.text
				when "IdList"
					@id_list ||= Array.new()
					element.each_element do |i|
						@id_list << i.text.to_i()
					end
				when "QueryKey"
					@key = element.text.to_i()
				when "QueryTranslation"
					@translation = element.text
				when "RetMax"
					@maximum = element.text.to_i()
				when "RetStart"
					@start = element.text.to_i()
				when "TranslationSet"
					@translation_set = TranslationSet.new(element)
				when "TranslationStack"
					@translation_stack = TranslationStack.new(element)
				when "WarningList"
					@has_warning = true
					@warning_list = WarningList.new(element)
				when "WebEnv"
					@environment = element.text
				else
					# Handle Error!
				end
			end
		end

	end
end
end