# frozen_string_literal: true

module Encryptable
  extend ActiveSupport::Concern

  class_methods do
    def default_crypto_options
      {
        encryptor: Lockbox::Encryptor,
        algorithm: "xchacha20",
        key:       :encryption_key
      }
    end

    def blind_index_key
      [Rails.application.credentials.env.blind_index_key].pack("H*")
    end
  end

  def encryption_key
    @encryption_key ||= get_or_generate_encryption_key
  end

  # Gotta clean up the :reek:TooManyStatements
  # rubocop:disable Naming/AccessorMethodName
  def get_or_generate_encryption_key
    if self.class.name == "User"
      return extract_encryption_key if persisted?

      return create_encryption_key
    end
    return extract_encryption_key if defined?(encryption_key_id)

    raise "You need to override an encryption_key method - no direct connection to user_id"
  end
  # rubocop:enable Naming/AccessorMethodName

  def delete_encryption_key
    Vault.logical.delete(encryption_key_id)
  end

  # we might only need this in our User model but it's still part of our encryptable library
  # It's a :reek:UtilityFunction
  def create_encryption_key
    SecureRandom.random_bytes(32).unpack1("H*")
  end

  # this saves our encryption key in Redis so it's persistent
  def save_encryption_key
    raise "Encryption key already exists" if extract_encryption_key

    Vault.logical.write(encryption_key_id, data: {encryption_key: encryption_key})
  end

  # what do return in attribute field when there's no key
  def value_when_no_key
    "[deleted]"
  end

  # we need to override attr_encrypted method so rather than throwing an exception
  # it will return a correct value when no key exists
  # you can also consider overriding encrypt in a similar fashion
  # (although for me it makes sense that no key = you cant edit whats inside)
  # :reek:DuplicateMethodCall happens a lot
  def decrypt(attribute, encrypted_value)
    encrypted_attributes[attribute.to_sym][:operation] = :decrypting
    encrypted_attributes[attribute.to_sym][:value_present] = self.class.not_empty?(encrypted_value)
    self.class.decrypt(attribute, encrypted_value, evaluated_attr_encrypted_options_for(attribute))
  rescue ArgumentError # must specify a key
    value_when_no_key
  end

  def encryption_key_id
    return "secret/data/user_encryption_key_#{uuid}" if self.class.name == "User" && defined?(uuid)

    "secret/data/user_encryption_key_#{user.try(:uuid)}"
  end

  def extract_encryption_key
    @extract_encryption_key ||= Vault.logical.read(encryption_key_id)&.data&.[](:data)&.[](:encryption_key)
  end
end
