class Provider < ApplicationRecord
  validates_presence_of :provider_name
  scope :max_discharges, ->(max) { where('total_discharges <= ?', max) }
  scope :min_discharges, ->(min) { where('total_discharges >= ?', min) }
  scope :max_average_covered_charges, ->(max) { where('average_covered_charges <= ?', max) }
  scope :min_average_covered_charges, ->(min) { where('average_covered_charges >= ?', min) }
  scope :max_average_medicare_payments, ->(max) { where('average_medicare_payments <= ?', max) }
  scope :min_average_medicare_payments, ->(min) { where('average_medicare_payments >= ?', min) }
  scope :by_provider_state, ->(s) { where('lower(provider_state) = ?', s.downcase) }
end
