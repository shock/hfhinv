Ransack.configure do |config|
  config.add_predicate 'flag_equals',
    arel_predicate: 'eq',
    formatter: proc { |v| (v.downcase == 'true') ? 1 : 0 },
    validator: proc { |v| v.present? },
    type: :string
end
