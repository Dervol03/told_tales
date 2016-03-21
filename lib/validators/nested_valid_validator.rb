# Expects the specified attribute to be a nested record of any kind. Unless the
# latter is valid, an error will be added to the attribute.
class NestedValidValidator < ActiveModel::EachValidator
  # Validates the nested record.
  #
  # @param [ActiveRecord::Base] record asking for validation.
  # @param [String, Symbol] attribute to be validated.
  # @param [ActiveModel] nested_record to check for validity
  def validate_each(record, attribute, nested_record)
    unless nested_record && nested_record.valid?
      record.errors.add(attribute, I18n.t(:invalid))
    end
  end
end # NestedValidValidator
