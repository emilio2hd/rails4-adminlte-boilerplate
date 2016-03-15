admin = User.new(id: -1,
                 name: 'Administrador',
                 username: 'admin',
                 password: 'admin',
                 password_confirmation: 'admin'
                )

unless User.where(username: admin.username).exists?
  admin.save!
end