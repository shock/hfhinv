module HasFlags
  extend ActiveSupport::Concern

  included { include FlagShihTzu }

  class_methods do
    def flag_ransacker(flag_name, flag_col = 'flags')
      ransacker(flag_name) do |parent|
        Arel::Nodes::InfixOperation.new('&', parent.table[flag_col], flag_mapping[flag_col][flag_name])
      end
    end
  end
end

