module ApiResponder
  # Api lib to translate response messages
  module Translate
    def translate_exception(exception, version = nil)
      class_name = exception.record.class.name.underscore
      errors = exception.record.errors.messages

      errors.each_with_object({}) do |(attr_name, messages), memo|
        defaults = defaults(attr_name, class_name, version)
        attr_name = I18n.t defaults.shift, default: defaults
        memo[attr_name.to_sym] = messages
      end
    end

    private

    def defaults(attr_name, class_name, version)
      [].tap do |defaults|
        if version
          defaults << :"#{version}.attributes.#{class_name}.#{attr_name}"
          defaults << :"#{version}.attributes.#{attr_name}"
        end

        defaults << :"attributes.#{class_name}.#{attr_name}"
        defaults << :"attributes.#{attr_name}"
        defaults << attr_name.to_s
      end
    end
  end
end
