module Devise
  module Orm
    module CouchrestModel
      module Schema

        def find_for_authentication(conditions)
          conditions = filter_auth_params(conditions.dup)
          (case_insensitive_keys || []).each { |k| conditions[k].try(:downcase!) }
          (strip_whitespace_keys || []).each { |k| conditions[k].try(:strip!) }
          find(:conditions => conditions)
        end

        def find(*args)
          options = args.extract_options!

          if options.present?
            raise "You can't search with more than one condition yet =(" if options[:conditions].keys.size > 1
            find_by_key_and_value(options[:conditions].keys.first, options[:conditions].values.first)
          else
            id = args.flatten.compact.uniq.join
            find_by_key_and_value(:id, id)
          end
        end

        private

        def find_by_key_and_value(key, value)
          if key == :id
            get(value)
          else
            send("by_#{key}", {:key => value, :limit => 1}).first
          end
        end
      end
    end
  end
end
