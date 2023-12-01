unless User.exists?
  User.create(
    email: 'admin@synonym.com',
    username: 'admin',
    password: "$dm!nhola123",
    password_confirmation: "$dm!nhola123",
    admin: true
  )
end  

unless Word.exists?
  Word.create(
    reference: 'good'
  )
end

unless Synonym.exists?
  Synonym.create(
    reference: 'fine',
    word_id: 1,
    status: 1
  )
end
