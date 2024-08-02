module Utils
    module GenerateNumbers
        def self.generate_number(entity:)
            highest_number = entity.where.not(number: nil).order(number: :desc).first.try(:number)
            highest_number ? highest_number + 1 : 1
        end
    end
end