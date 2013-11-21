# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.where("position in (?)", ["Leader", "Subleader", "Member"]).each do |user|
  50.times do |i|
    date = Date.new(rand(2) + 2012, rand(12) + 1, rand(28) + 1)
    report = user.reports.new(title: "Report for some thing", description: "Let wirte some thing here", report_category_id: ReportCategory.all[rand(ReportCategory.count)].id, report_date: date)
    report.save(validate: false) if date < Date.today
  end 
end
