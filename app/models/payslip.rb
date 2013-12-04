class Payslip < ActiveRecord::Base
  
  belongs_to :user
  mount_uploader :payslip, FileUploader

  PAYMONTH_REX = /\AT(1[0-2]|0[1-9]|[1-9])\.(\d{4})\z/
  validates :paymonth, format: { with:  PAYMONTH_REX }
  validates :user_id, uniqueness: { scope: :paymonth }

  before_validation :correct_paymonth

  scope :by_paymonth, ->(paymonth) { where(paymonth: paymonth) unless paymonth.nil? }
  def last_month_payslip?
    if paymonth =~ PAYMONTH_REX
      today = Date.today
      month = today.month == 1 ? 12 : today.month - 1
      year = today.year == 1 ? today.year - 1 : today.year
      return true if month == $1.to_i && year == $2.to_i
    end
    false
  end

  private
  def correct_paymonth 
    if paymonth =~ /\AT([1-9])\.(\d{4})\z/
      self.paymonth = "T0#{$1}.#{$2}"
    end
  end

  class << self
    HEAD_ROWS = 8
    def import_payslip_for staff, payslip
      detected_staff = false
      delete_rows = []
      payslip[0].sheet_data.each_with_index do |row, index|
        if index >= HEAD_ROWS 
          if row[1].try(:value).try(:strip) == staff.uid
            detected_staff = true
          else
            delete_rows << index
          end
        end
      end
      if detected_staff
        delete_rows.each_with_index { |row, i| payslip.worksheets[0].delete_row(row - i) }
        payslip.worksheets[0].sheet_data.length.times do |i|
          payslip.worksheets[0].change_row_fill(i, "ffffff")
        end
        if detected_staff
          payslip_path = "/tmp/#{staff.display_name}.xlsx"
          payslip.write payslip_path
          build_payslip_for staff, payslip_path, payslip[0].sheet_name
        end
      end
    end

    def import_payslips payslip_path
      User.all.each do |staff|
        payslip = RubyXL::Parser.parse payslip_path
        import_payslip_for staff, payslip if staff.uid
      end
    end

    def build_payslip_for user, payslip_path, month
      unless month =~ PAYMONTH_REX
        today = Date.today
        month = today.month == 1 ? 12 : today.month - 1
        year = today.month == 1 ? today.year - 1 : today.year
        month = "T#{month}.#{year}"
      end
      user.payslips.create paymonth: month, payslip: File.open(payslip_path)
    end

    def send_payslip_mail paymonth
      if paymonth =~ PAYMONTH_REX
        Payslip.by_paymonth(paymonth).each do |payslip|
          UserMailer.delay.send_payslip(payslip)
        end
      end
    end

    def paymonths
      Payslip.order("created_at DESC").map(&:paymonth).uniq
    end
  end
end
