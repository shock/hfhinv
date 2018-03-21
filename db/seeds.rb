# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
begin
  if Rails.env.development?
    admin_params = HashObj.new(email: 'inventory@cchfh.org', password: 'password', password_confirmation: 'password')
  else
    admin_params = HashObj.new(email: 'inventory@cchfh.org', password: 'Periwinkle', password_confirmation: 'Periwinkle')
  end
  AdminUser.create!(admin_params)
rescue ActiveRecord::RecordInvalid
  puts "Admin user with email #{admin_params.email} already exists, skipping..."
end

DEPARTMENTS = {
  "Appliances" => ["Washer or Dryer", "Refrigerator", "Freezer", "Range/Oven/Cooktop", "Microwave"],
  "Furniture" => ["Bed/Frame", "Sofa", "Chair", "Dining Table", "Dresser", "End/Coffee Table", "Desk/Office",
    "Entertainment Center", "Buffet/Chest/Storage"],
  "Building Materials" => ["Lumber/Plywood/Sheetroock", "Flooring/Molding", "Brick/Block/Stone",
    "Doors", "Windows", "Tile", "Insulation", "Ductwork", "Paint"],
  "Hardware" => ["Fasteners/Nails", "Fasteners/Screws", "Hinges", "Knobs/Pulls"],
  "Lighting" => ["Lamps", "Chandelier", "Ceiling Fixture", "Wall Fixture", "Exterior Light", "Flourescent Fixture",
    "Ceiling Fan"],
  "Plumbing Fixtures" => ["Sink", "Toilet", "Tub", "Shower", "Hose/Pipe", "Accessories"],
  "Sports/Outdoors" => ["Exercise Equipment", "Lawn and Garden", "Sports Equipment", "Patio Furniture"],
  "Cabinets" => ["Kitchen", "Bathroom", "Storage", "Counter Tops"],
  "Electrical" => ["Wiring", "Boxes/Receptacles/Etc", "Accessories"],
  "Tools" => ["Hand Tools", "Power Tools"],
  "Electronics" => ["TV", "Audio", "Computer/Accessories"],
  "Housewares" => ["Books", "Music", "Plates", "Bowls", "Serving", "Luggage", "Decoration"],
  "Miscellaneous" => []
}

DEPARTMENTS.each do |name, types|
  department = Department.find_or_create_by(name: name)
  types.each do |type_name|
    ItemType.find_or_create_by(department_id: department.id, name: type_name)
  end
end

USES_OF_ITEMS = ["Inventory", "Recycle", "Donate", "Use In Store", "Discard"]
USES_OF_ITEMS.each do |name|
  UseOfItem.find_or_create_by(name: name)
end