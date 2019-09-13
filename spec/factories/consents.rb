# frozen_string_literal: true

# == Schema Information
#
# Table name: consents
#
#  id                   :bigint(8)        not null, primary key
#  content_translations :jsonb
#  key                  :citext           not null, indexed
#  title_translations   :jsonb
#  uuid                 :uuid             indexed
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_consents_on_key   (key) UNIQUE
#  index_consents_on_uuid  (uuid) UNIQUE
#

FactoryBot.define do
  factory :consent do
    sequence(:key) {|n| "consent#{n}" }
  end
end
