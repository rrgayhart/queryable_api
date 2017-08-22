class Provider < ApplicationRecord
  validates_presence_of :provider_name
  scope :max_discharges, ->(max) { where('total_discharges <= ?', max) }
  scope :min_discharges, ->(min) { where('total_discharges >= ?', min) }
  scope :max_average_covered_charges, ->(max) { where('average_covered_charges <= ?', max) }
  scope :min_average_covered_charges, ->(min) { where('average_covered_charges >= ?', min) }
  scope :max_average_medicare_payments, ->(max) { where('average_medicare_payments <= ?', max) }
  scope :min_average_medicare_payments, ->(min) { where('average_medicare_payments >= ?', min) }
  scope :state, ->(s) { where('lower(provider_state) = ?', s.downcase) }

  def self.build_query(queries)
    res = queries.inject(self) do |sum, query|
      sum.send(query[0], query[1])
    end
  end
end
