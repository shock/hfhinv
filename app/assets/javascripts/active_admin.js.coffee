#= require active_admin/base
#= require admin/select2.min

process_item_type_selection = ->
  body = $('body')
  if body.hasClass('edit') && body.hasClass('admin_items')
    if check_for_other_item_type()
      notes = $("select#item_item_type_id option:selected").data('notes')
      $('#item_description').attr('placeholder', notes)
    else
      $('#item_description').attr('placeholder', '')

check_for_other_item_type = ->
  selected_val = parseInt($('select#item_item_type_id').val())
  if selected_val < 0
    department_id = 0 - selected_val # invert the negative that we inverted when creating the "Other" option
    department_name = $("select#item_item_type_id option:selected").text().split(' - ')[0]
    $('a.new-item-department-name').text(department_name)
    $('#item_new_item_type_department_id').val(department_id)
    $('div.new-item-form').show()
    return false
  else
    $('div.new-item-form').hide()
    return true

$ ->
  $('select#item_item_type_id').select2()
  $('select#item_use_of_item_id').select2()
  $('select#item_donation_id').select2()
  $('select#donation_donor_id').select2()
  $('select#item_type_department_id').select2()
  process_item_type_selection()


$(document).on 'change', 'select#item_item_type_id', process_item_type_selection
