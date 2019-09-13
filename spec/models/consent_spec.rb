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

require "rails_helper"

RSpec.describe Consent, type: :model do
  subject(:consent) { build :consent }

  it { is_expected.to be_valid }

  it { is_expected.to validate_uniqueness_of(:key).case_insensitive }
  it { is_expected.to validate_presence_of(:key) }

  context "when a consent is updated" do
    let(:user_consent) { create :user_consent, :consented }
    let(:consent) { user_consent.consent }

    # rubocop:disable Lint/AmbiguousBlockAssociation
    it { expect { consent.update(title_en: "A new thing") }.to change { user_consent.reload.up_to_date } }
    it { expect { consent.update(title_en: "A new thing") }.to change { user_consent.reload.updated_at } }
    # rubocop:enable Lint/AmbiguousBlockAssociation
  end
end
