FactoryGirl.define do
  factory :user do
    email "admin@test.com"
    position "Staff"
    password  "123456"
    password_confirmation "123456"
  end

  factory :role_category do
    name "Development"
  end

  factory :role do
    name "Member"
  end

  factory :user_role do
  end

  factory :group do
    name "Group"
  end

  factory :team do
    name "Team"
  end

  factory :report_category do
    name "Coding"
  end

  factory :report do
    user_id 1
    title "Title"
    description "Description"
    report_date Date.today
    week Date.today.cweek
    month Date.today.month
    year Date.today.year
  end

  factory :sticky do
    user_id 1
    report_id 1
  end
end