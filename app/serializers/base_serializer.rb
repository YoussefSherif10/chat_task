class BaseSerializer
    include FastJsonapi::ObjectSerializer
  
    def serialized_json
      super.tap do |json|
        json_hash = JSON.parse(json)
        remove_ids(json_hash['data'])
        json.replace(json_hash.to_json)
      end
    end
  
    private
  
    def remove_ids(data)
      if data.is_a?(Hash)
        data.delete('id')
        remove_relationship_ids(data['relationships'])
      elsif data.is_a?(Array)
        data.each do |obj|
          obj.delete('id')
          remove_relationship_ids(obj['relationships'])
        end
      end
    end
  
    def remove_relationship_ids(relationships)
      return unless relationships
  
      relationships.each_value do |relationship_data|
        if relationship_data['data'].is_a?(Array)
          relationship_data['data'].each { |rel| rel.delete('id') }
        elsif relationship_data['data'].is_a?(Hash)
          relationship_data['data'].delete('id')
        end
      end
    end
  end
  