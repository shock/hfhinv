#= require active_admin/base
#= require admin/select2.min

$ ->
  $('select#item_item_type_id').select2()
  $('select#item_use_of_item_id').select2()
  $('select#item_donation_id').select2()
  $('select#donation_donor_id').select2()
  $('select#item_type_department_id').select2()

