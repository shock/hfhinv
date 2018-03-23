# Code we only want to run when in the Rails console.

# This needs to be required in your console starter (.irbrc or .pryrc).
# eg.:
#
# console_init = File.join Dir.getwd, 'config', 'console.rb'
# if File.exist?(console_init)
#   puts "Loading #{console_init}"
#   require console_init
# end


# For pry console, include the following in .pryrc
#
# if defined? Hirb
#   # Slightly dirty hack to fully support in-session Hirb.disable/enable toggling
#   Hirb::View.instance_eval do
#     def enable_output_method
#       @output_method = true
#       @old_print = Pry.config.print
#       Pry.config.print = proc do |*args|
#         Hirb::View.view_or_page_output(args[1]) || @old_print.call(*args)
#       end
#     end
#
#     def disable_output_method
#       Pry.config.print = @old_print
#       @output_method = nil
#     end
#   end
#
#   Hirb.enable
#   old_print = Pry.config.print
#   Pry.config.print = proc do |*args|
#     Hirb::View.view_or_page_output(args[1]) || old_print.call(*args)
#   end
#
# end

require 'hirb'

silence_warnings { Object.const_set( "RAILS_CONSOLE", true ) }
puts "Initializing Hfhinv Rails console."

# Set the acts_as_audited user so we can track changes made from the console.
Thread.current[:audited_user] = "Rails Console"

module HfhinvConsoleHelpers
  def self.simple_time(time)
    if time.is_a?(Time)
      time.strftime("%Y-%m-%d %H:%M:%S").slice(2..-1)
    else
      time.strftime("%Y-%m-%d").slice(2..-1)
    end
  end

  # module Album
  #   # =====================
  #   # = Console Shortcuts =
  #   # =====================

  #   # =======================
  #   # = Hirb Helper methods =
  #   # =======================
  #   def p_cnt; photos.count; end
  #   def p_approved; HfhinvConsoleHelpers.simple_time(photographer_approved_at) rescue "nil"; end
  #   def c_approved; HfhinvConsoleHelpers.simple_time(customer_approved_at) rescue "nil"; end
  # end

  module AdminUser
    # =====================
    # = Console Shortcuts =
    # =====================

    # =======================
    # = Hirb Helper methods =
    # =======================
    def last_sign_in_at; HfhinvConsoleHelpers.simple_time(super) rescue "nil"; end
  end

  module Donation
    # =====================
    # = Console Shortcuts =
    # =====================

    # =======================
    # = Hirb Helper methods =
    # =======================
    def p; pickup? ? "T" : "F"; end
    def p_date; HfhinvConsoleHelpers.simple_time(pickup_date) rescue "nil"; end
    def d_id; donor_id; end
  end

  module Item
    # =====================
    # = Console Shortcuts =
    # =====================

    # =======================
    # = Hirb Helper methods =
    # =======================
    def d_id; donation_id; end
    def item_type_desc; item_type.description; end
    def use; use_of_item_name; end

  end

  module ActiveRecord
    extend ActiveSupport::Concern

    module ClassMethods
      def [](id)
        find(id)
      end
    end

    def to_s
      output = []
      self.attributes.sort{|a,b|a.first <=> b.first}.each do |a|
        output << "#{'%30s' % a.first}: #{a.last}"
      end
      output * "\n"
    end

    # General Hirb Helper methods
    def created; HfhinvConsoleHelpers.simple_time(created_at) rescue "nil"; end
    def updated; HfhinvConsoleHelpers.simple_time(updated_at) rescue "nil"; end
  end

  module HirbView
    extend ActiveSupport::Concern
    included do
      class << self
        alias :orig_render_output :render_output

        def render_output(*args)
          ::ActiveRecord::Base.logger.with_level(:warn) do
            orig_render_output(*args)
          end
        end
      end
    end
  end

end

class Object
  def self.descendants
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end

  # Hirb Printer shortcut
  def hp(*args)
    puts Hirb::Helpers::AutoTable.render(*args)
  end

  # Hirb resizer and helper reloader shortcut
  def hr
    Hirb::View.resize

    # Event.send(:include, HfhinvConsoleHelpers::Event)
    # Album.send(:include, HfhinvConsoleHelpers::Album)
    # Photo.send(:include, HfhinvConsoleHelpers::Photo)
    # Portfolio.send(:include, HfhinvConsoleHelpers::Portfolio)
    # PromoCode.send(:include, HfhinvConsoleHelpers::PromoCode)
    # Review.send(:include, HfhinvConsoleHelpers::Review)

    silence_warnings {
      # Shortcut aliases for common AR classes
      # Object.const_set "A", Audit
      # Object.const_set "AA", ArchivedAudit
      Object.const_set "AC", ActiveAdmin::Comment
      Object.const_set "DO", Donor
      Object.const_set "DA", Donation
      Object.const_set "DP", Department
      Object.const_set "IT", ItemType
      Object.const_set "I",  Item
      Object.const_set "AU", AdminUser
    }
    true
  end

  def hirb_off
    Hirb.enable :pager=>false
    Hirb.enable :formatter=>false
  end

  def hirb_on
    Hirb.enable :pager=>true
    Hirb.enable :formatter=>true
    # Hirb::View.send(:include, HfhinvConsoleHelpers::HirbView)
  end

  def reload
    ActionDispatch::Reloader.cleanup!
    ActionDispatch::Reloader.prepare!
    hr
    true
  end

end

hirb_on
hr unless Rails.env.test?

# require 'pry'
