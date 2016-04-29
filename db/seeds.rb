puts '=> Creating users'
admin = User.find_or_initialize_by({email: 'admin@test.com'}) do |user|
  user.password = '123456'
  user.role = :admin
  user.save
end

user = User.find_or_initialize_by({email: 'user@test.com'}) do |user|
  user.password = '123456'
  user.role = :user
  user.save
end

guest = User.find_or_initialize_by({email: 'guest@test.com'}) do |user|
  user.password = '123456'
  user.role = :guest
  user.save
end

puts '=> Creating users data'
admin.posts.create(title: 'admin post', text: 'text')
admin.devices.create(name: 'admin device')

user.posts.create(title: 'user post', text: 'text')
user.devices.create(name: 'user device')

guest.posts.create(title: 'guest post', text: 'text')
guest.devices.create(name: 'guest device')

