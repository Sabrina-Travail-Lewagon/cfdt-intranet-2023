# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
puts "Nettoyage de la base"
Article.destroy_all
Category.destroy_all
User.destroy_all
puts "--- creation de 2 users ---"
users_data = [
  {
    first_name: 'sabrina',
    last_name: 'Test',
    email: 'sabrina@test.com',
    password: '123456',
    role: 'admin',
    photo: Rails.root.join("app/assets/images/sabrina.jpeg").open
  },
  {
    first_name: 'wes',
    last_name: 'Test',
    email: 'wes@test.com',
    password: '123456',
    # si le rôle n'est pas spécifié pour wes, je suppose qu'il sera défini par défaut dans le modèle
    photo: Rails.root.join("app/assets/images/wes.jpeg").open
  }
]
users_data.each do |user_data|
  user = User.create!(
    first_name: user_data[:first_name],
    last_name: user_data[:last_name],
    email: user_data[:email],
    password: user_data[:password],
    role: user_data[:role]
  )

  # Utilisation de Cloudinary pour uploader la photo
  user.photo.attach(io: user_data[:photo], filename: "#{user_data[:first_name]}_photo.jpg", content_type: 'image/jpg')
  user.save!
end
puts '--- users créés ---'
puts "--- Création des catégories ---"
# Création des catégories
# Données pour les catégories
categories_data = [
  {
    nom: 'infos RH',
    image: Rails.root.join("app/assets/images/infos-rh.png").open
  },
  {
    nom: 'infos CSE',
    image: Rails.root.join("app/assets/images/infos-cse.png").open
  }
]
categories_data.each do |category_data|
  category = Category.create!(nom: category_data[:nom])
  # Utilisation d'ActiveStorage pour attacher l'image à la catégorie
  category.image.attach(io: category_data[:image], filename: "#{category_data[:nom]}.png", content_type: 'image/png')
end
puts "--- Catégories crées ---"
