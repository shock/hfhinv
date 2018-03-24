# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Creating default admin user"
begin
  if Rails.env.development?
    admin_params = HashObj.new(email: 'admin@cchfh.org', password: 'password', password_confirmation: 'password')
  else
    admin_params = HashObj.new(email: 'admin@cchfh.org', password: 'cchfhrocks!', password_confirmation: 'cchfhrocks!')
  end
  AdminUser.create!(admin_params)
rescue ActiveRecord::RecordInvalid
  puts "Admin user with email #{admin_params.email} already exists, skipping..."
end

if ENV['RESET_ALL_SEEDS']=='true'
  puts "Destroying existing Items, ItemTypes, UseOfItems and Departments for integrity"
  Item.destroy_all
  ItemType.destroy_all
  Department.destroy_all
  UseOfItem.destroy_all
  Donor.where(first_name: "Anonymous", last_name: "Donor", phone: "5555555555", city: "Norman", zip: "73069").destroy_all
end

DEPARTMENTS = {
  "Appliances" => [
    {name: "Washer", code: "Washer", notes: "Include maker and color, Note if GAS"},
    {name: "Dryer", code: "Dryer", notes: "Include maker and color, Note if GAS"},
    {name: "Refrigerator", code: "Fridge", notes: "Include maker and color, Note if GAS"},
    {name: "Freezer", code: "Freezer", notes: "Include maker and color, Note if GAS"},
    {name: "Stove", code: "Stove", notes: "Include maker and color, Note if GAS, has oven?, etc"},
    {name: "Cooktop", code: "Cooktop", notes: "Include maker and color, Note if GAS"},
    {name: "Wall Oven", code: "Oven", notes: "Include maker and color, Note if GAS"},
    {name: "Hood", code: "Hood", notes: "Include maker and color, Note if GAS"},
    {name: "Microwave", code: "Micro", notes: "Include maker and color, Note if GAS, Over the Range or Countertop?"},
    {name: "Small Appliance", code: "SmApp", notes: "brief description"},
    {name: "Water Heater", code: "WHeater", notes: "Include maker and color, Note if GAS"},
    {name: "Heater", code: "Heater", notes: "Include maker and color, Note if GAS"},
    {name: "A/C", code: "AC", notes: "Include maker and color, Note if GAS"},
    {name: "Fireplace", code: "Fireplace", notes: "Include maker and color, Note if GAS"},
    {name: "Fan", code: "Fan", notes: "describe (box, wire cage, size)"},
  ],
  "Furniture" => [
    {name: "Kitchen/Dining Table", code: "Table", notes: "Note Leafs and Chairs"},
    {name: "Coffee Table", code: "CoTable", notes: "note glass, shape (rectangle, square, round)"},
    {name: "Side Table", code: "SiTable", notes: "note material, color, style/shape"},
    {name: "Nightstand", code: "Night", notes: "note material, color, style/shape"},
    {name: "Entertainment Center", code: "EnCenter", notes: "note if TV Armiore, Console, or Boxy; color"},
    {name: "Hutch/China Cabinet", code: "Hutch", notes: "Note shelves, style, color, parts"},
    {name: "Buffet/Credenza", code: "Buffet", notes: "note size, style"},
    {name: "Dining/Office Chair", code: "Chair", notes: "note style (if unique)"},
    {name: "Arm Chair", code: "ArmChair", notes: "note color, style (antique, xl, etc), with ottoman?"},
    {name: "Couch", code: "Couch", notes: "note color/pattern, with ottoman?"},
    {name: "Loveseat", code: "Loveseat", notes: "note color/pattern, with ottoman?"},
    {name: "Sofa Bed", code: "SofaBed", notes: "note color/pattern, bed size"},
    {name: "Recliner", code: "Recliner", notes: "note color/pattern"},
    {name: "Recliner Couch", code: "ReCouch", notes: "note style, color/pattern"},
    {name: "Ottoman", code: "Otto", notes: "note color/pattern"},
    {name: "Rocker", code: "Rocker", notes: "brief description"},
    {name: "Trunk", code: "Trunk", notes: "note color, size, material"},
    {name: "Chest", code: "Chest", notes: "note color, size, material"},
    {name: "Dresser", code: "Dresser", notes: "Note drawers, details, additional parts (hutch, etc)"},
    {name: "Desk", code: "Desk", notes: "note office or home, material (wood, metal, glass, particle board)"},
    {name: "Bookshelf", code: "Book", notes: "Note height and quality (solid wood, particle board)"},
    {name: "Shelf", code: "Shelf", notes: "Note dimensions, finish, and any mounting hardware"},
    {name: "Stool", code: "Stool", notes: "brief description"},
    {name: "Daybed", code: "Daybed", notes: "brief description"},
    {name: "Bunkbed", code: "Bunkbed", notes: "brief description, drawers?, etc"},
    {name: "Rack", code: "Rack", notes: "brief description, type, color, etc"},
    {name: "Storage", code: "Storage", notes: "brief description, type, color, etc"},
    {name: "Futon", code: "Futon", notes: "brief description, frame type, color, etc"},
    {name: "File Cabinet", code: "File", notes: "note color, # of drawers, etc"},
    {name: "Wardrobe", code: "Wardrobe", notes: "note dimensions, finish, drawers, etc"},
    {name: "Buffet", code: "Buffet", notes: "note finish, # of drawers, etc"},
    {name: "Bench", code: "Bench", notes: "note type, color, materials, etc"},
  ],
  "Bedframes" => [
    {name: "Twin", code: "Twin", notes: "note trundle or storage, style, material (metal, wood, particleboard, etc)"},
    {name: "Full", code: "Full", notes: "note trundle or storage, style, material (metal, wood, particleboard, etc)"},
    {name: "Queen", code: "Queen", notes: "note trundle or storage, style, material (metal, wood, particleboard, etc)"},
    {name: "King", code: "King", notes: "note storage, style, material (metal, wood, particleboard, etc)"},
    {name: "Cal King", code: "CKing", notes: "note storage, style, material (metal, wood, particleboard, etc)"},
    {name: "Bunk Bed", code: "Bunkbed", notes: "note trundle or storage, style, material (metal, wood, particleboard, etc)"},
    {name: "Loft Bed", code: "Loftbed", notes: "note trundle or storage, style, material (metal, wood, particleboard, etc)"},
    {name: "Day Bed", code: "Daybed", notes: "note trundle or storage, style, material (metal, wood, particleboard, etc)"},
    {name: "Metal Bedframe", code: "Metal", notes: "note size (Twin, Full, Queen, King, Cal King)"},
  ],
  "Bedframes (Head/Foot Only)" => [
    {name: "Twin", code: "HTwin", notes: "note trundle or storage, style, material (metal, wood, particleboard, etc)"},
    {name: "Full", code: "HFull", notes: "note trundle or storage, style, material (metal, wood, particleboard, etc)"},
    {name: "Queen", code: "HQueen", notes: "note trundle or storage, style, material (metal, wood, particleboard, etc)"},
    {name: "King", code: "HKing", notes: "note storage, style, material (metal, wood, particleboard, etc)"},
    {name: "Cal King", code: "CHKing", notes: "note storage, style, material (metal, wood, particleboard, etc)"},
  ],
  "Building Materials" => [
    {name: "Interior Door", code: "IntDoor", notes: "note hollow/solid, decorative/slab, dimensions"},
    {name: "Exterior Door", code: "ExtDoor", notes: "note material, decorative/slab, dimensions"},
    {name: "Storm Door", code: "Storm", notes: "note dimensions"},
    {name: "Screen Door", code: "Screen", notes: "note dimensions, frame material"},
    {name: "Window - Vinyl Framed", code: "VWindow", notes: "include color of frame, dimensions"},
    {name: "Window - Metal Framed", code: "MWindow", notes: "include dimensions"},
    {name: "Window - Wooden Framed", code: "WWindow", notes: "include dimensions, approx age (antique, new, etc)"},
    {name: "Shingles (in package)", code: "Shingle", notes: "include color of frame, dimensions"},
    {name: "Plywood", code: "Plywood", notes: "include dimensions"},
    {name: "Sheetrock", code: "Sheetrock", notes: "include dimensions, approx age (antique, new, etc)"},
    {name: "Lumber", code: "Lumber", notes: "brief description if relevant"},
  ],
  "Hardware" => [
    {name: "Door - Knob/Handle", code: "DoorKnob", notes: "note color, interior/exterior, keys/lock"},
    {name: "Door - Deadbolt", code: "Deadbolt", notes: "note color, keys"},
    {name: "Door - Lock Set", code: "DoorSet", notes: "note color, keys"},
    {name: "Door - Hinges", code: "DoHinge", notes: "note color, amount in bag"},
    {name: "Door - Knocker", code: "Knock", notes: "note size, color"},
    {name: "Door - Peephole", code: "Peep", notes: "note size, color"},
    {name: "Drawer Knob/Handle", code: "DrKnob", notes: "note style, amount in bag"},
    {name: "Drawer Hinges", code: "DrHinge", notes: "note color, amount in bag"},
    {name: "Drawers", code: "Drawer", notes: "note size, color"},
    {name: "Cabinet Door", code: "CabDoor", notes: "note dimensions, color, special features"},
  ],
  "Lighting" => [
    {name: "Table Lamp", code: "TLamp", notes: "note height, design"},
    {name: "Floor Lamp", code: "FLamp", notes: "note height, design"},
    {name: "Chandelier", code: "Chand", notes: "note color and details (shades, globes, crystals, etc)"},
    {name: "Ceiling Fixture", code: "CLight", notes: "note flush mount, hanging, etc"},
    {name: "Wall Fixture", code: "WLight", notes: "note amount of bulbs, style"},
    {name: "Exterior Fixture", code: "ExtLight", notes: "note if sconce, post, or garden light; note if solar, motion sensor"},
    {name: "Fluorescent Fixture", code: "FlLight", notes: "Note # and type/length of bulbs needed"},
    {name: "Ceiling Fan", code: "Fan", notes: "Note # of Blades"},
  ],
  "Plumbing & Fixtures" => [
    {name: "Bathroom Sink", code: "BathSink", notes: "include color, style (wall mount, pedestal, undermount, etc), if faucet is attached"},
    {name: "Pedestal Sink", code: "PedSink", notes: "include if attached to base"},
    {name: "Kitchen Sink", code: "KitSink", notes: "include single or double sink, material (stainless steel, cast iron, brass, etc), if faucet is attached"},
    {name: "Bathroom Vanity", code: "Vanity", notes: "include colors, style, and approximate size"},
    {name: "Kitchen Faucet", code: "KitFaucet", notes: "include color, style (with or without sprayer, etc)"},
    {name: "Bathroom Faucet", code: "BathFaucet", notes: "include color, style (polished brass, nickel, dark bronze, etc)"},
    {name: "Toilet", code: "Toilet", notes: "note special features (button on top of tank, missing seat, etc)"},
  ],
  "Sports/Outdoors" => [
    {name: "Bicycle", code: "Bike", notes: "include make and model or description"},
    {name: "Exercise Equipment", code: "ExerEquip", notes: "include maker and model or description"},
    {name: "Lawn and Garden", code: "LawnGarden", notes: "describe item"},
    {name: "Sports Equipment", code: "Sports", notes: "include maker and model or description"},
    {name: "Patio Furniture", code: "Patio", notes: "describe item"},
    {name: "Grill", code: "Grill", notes: "note type: gas/charcoal"},
  ],
  "Cabinets" => [
    {name: "Cabinet", code: "Cabinet", notes: "note dimensions and type"},
    {name: "Kitchen", code: "KCabinet", notes: "note dimensions; upper, lower?"},
    {name: "Bathroom", code: "BCabinet", notes: "note dimensions; under sink? upper?"},
    {name: "Medicine Cabinet", code: "MedCab", notes: "brief description"},
    {name: "Storage", code: "SCabinet", notes: "brief description"},
    {name: "Countertop", code: "Counter", notes: "note material, color, dimensions"},
  ],
  "Electrical" => [
    {name: "Wiring", code: "Wiring", notes: "note type and length or amount"},
    {name: "Boxes", code: "ElecBox", notes: "note if standard or accessory"},
    {name: "Receptacles", code: "ElectRecep", notes: "note color and any non-standard features"},
    {name: "Accessories", code: "ElecAcc", notes: "brief description"},
  ],
  "Tools" => [
    {name: "Hand Tool", code: "HandTool", notes: "brief description, if unique"},
    {name: "Power Tool", code: "PowerTool", notes: "note maker and type, or describe"},
    {name: "Lawn Mower", code: "Mower", notes: "describe (HP, electric/gas)"},
  ],
  "Electronics" => [
    {name: "Radio", code: "Radio", notes: "include maker, style"},
    {name: "Alarm Clock", code: "AlarmClock", notes: "include maker, style"},
    {name: "CD Player", code: "CDPlayer", notes: "include maker, style"},
    {name: "DVD Player", code: "DVDPlayer", notes: "include maker, style"},
    {name: "VHS Player", code: "VHSPlayer", notes: "include maker, style"},
    {name: "Cassette Player", code: "CassettePlayer", notes: "include maker, style"},
    {name: "Digital Camera", code: "DigitalCamera", notes: "include maker, style"},
    {name: "Polaroid Camera", code: "PolaroidCamera", notes: ""},
    {name: "Video Camera", code: "VideoCamera", notes: "include maker, style"},
    {name: "Speakers", code: "Speakers", notes: "brief description"},
    {name: "Sound System", code: "SoundSys", notes: "include maker, number of parts"},
    {name: "TV", code: "TV", notes: "include maker, style, remote?"},
    {name: "Video Game System", code: "VidGameSys", notes: "include maker, amount of controllers/games"},
    {name: "Laptop", code: "Laptop", notes: "include maker and model"},
    {name: "Computer Accessories", code: "CompAcc", notes: "brief description"},
  ],
  "Housewares" => [
    {name: "Books", code: "", notes: ""},
    {name: "Plates", code: "Plate", notes: "brief description if possible"},
    {name: "Bowls", code: "Bowl", notes: "brief description if possible"},
    {name: "Cups", code: "Cup", notes: "brief description if possible"},
    {name: "Mugs", code: "Mug", notes: "brief description if possible"},
    {name: "Stemware", code: "Stem", notes: "brief description if possible"},
    {name: "Serving", code: "Serving", notes: "brief description if possible"},
    {name: "Cookware", code: "Cooking", notes: "brief description if possible"},
    {name: "Luggage", code: "Luggage", notes: "brief description if possible"},
    {name: "Kitchen Decor", code: "KDecor", notes: "brief description if possible"},
    {name: "Living Room Decor", code: "LDecor", notes: "brief description if possible"},
    {name: "Bathroom Decor", code: "BDecor", notes: "brief description if possible"},
    {name: "Outdoor Decor", code: "ODecor", notes: "brief description if possible"},
    {name: "Bedroom Decor", code: "RDecor", notes: "brief description if possible"},
    {name: "China Set", code: "China", notes: "brief description if possible"},
    {name: "Music", code: "", notes: ""},
  ],
  "Miscellaneous" => []
}

puts "Creating Departments and Item Types"
DEPARTMENTS.each do |name, item_type_attrs|
  department = Department.find_or_create_by(name: name)
  item_type_attrs.each do |item_type_attr|
    item_type_attr[:department_id] = department.id
    item_type_attr[:notes] = item_type_attr[:notes].capitalize
    ItemType.find_or_create_by(item_type_attr)
  end
end

puts "Creating UseOfItems"
UseOfItem::USES_OF_ITEM.each do |name|
  UseOfItem.find_or_create_by(name: name)
end

unless Donor.where(first_name: "Anonymous", last_name: "Donor", phone: "5555555555", city: "Norman", zip: "73069").count > 0
  puts "Creating Anonymous Donor"
  Donor.create(first_name: "Anonymous", last_name: "Donor", city: "Norman", state: "OK", zip: "73069", phone: "555-555-5555")
end

puts "Database seeding successful"