require 'rexml/attribute'
require 'rexml/element'
require 'vertebrae/homologene/document_summary_data_item'

module Vertebrae
module Database
module HomoloGene
	class DocumentSummary

		public

		attr_reader :uid

		attr_accessor :caption
		attr_accessor :description
		attr_accessor :data_list
		attr_accessor :title

		def initialize(root = nil)
			return unless root
			build(root)
		end

		def clone()
			copy = DocumentSummary.new()
			copy.caption = caption
			copy.description = description
			copy.data_list = data_list
			copy.title = title
			copy.uid = uid

			return copy
		end

		# def caption()
		# 	return @caption.clone()
		# end

		# def description()
		# 	return @description.clone()
		# end

		# def data_list()
		# 	if not @data_list
		# 		return Array.new()
		# 	end

		# 	copy = Array.new(@data_list.length)

		# 	@data_list.each.with_index do |item, i|
		# 		copy[i] = item.clone()
		# 	end

		# 	return copy
		# end

		# def title()
		# 	return @title.clone()
		# end

		protected

		def build(root)
			@uid = root.attribute("uid").value.to_i()

			root.each_element do |element|
				case element.name
				when "Caption"
					@caption = element.text
				when "Description"
					@description = element.text
				when "HomoloGeneDataList"
					@data_list ||= Array.new()
					element.each_element do |item|
						@data_list << DocumentSummaryDataItem.new(item)
					end
				when "Title"
					@title = element.text
				else
					# Handle Error!
				end
			end
		end

		def caption=(caption)
			@caption = caption
		end

		def description=(description)
			@description = description
		end

		def data_list=(data_list)
			@data_list = data_list
		end

		def title=(title)
			@title = title
		end

		def uid=(uid)
			@uid = uid
		end

	end
end
end	
end