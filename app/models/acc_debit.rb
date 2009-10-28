# == Schema Information
# Schema version: 78
#
# Table name: accounts
#
#  id        :integer(11)     not null, primary key
#  name      :string(255)     default(""), not null
#  is_credit :boolean(1)      not null
#  position  :integer(11)     not null
#

class AccDebit < Account
    def balance
        return total_debit - total_credit;
    end
end
