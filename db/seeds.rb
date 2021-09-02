# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
vlad = User.create({name: 'Vlad', password: '123'})

todos = Todo.create([
    { name: ' Math assignment ', description: 'Complete all math exercises and pass exam ', due: '25/09/2021', tag: 'red', user: vlad}, 
    { name: ' Watch Star Wars ', description: ' Whatch all series again ', due: '2/11/2021', tag: 'green', user: vlad}, 
    { name: ' New home ', description: ' Renew accomodation contract ', due: '1/10/2021', tag: 'red', user: vlad } 
])

john = User.create({name: 'John', password: '456'})

todos = Todo.create([
    {name: ' Buy bio supliment ', description: ' Buy bio sumpliment for the farm ', due: '24/09/2021 13:00', tag: 'purple', user: john },
    {name: ' Test the app ', description: ' App seems fine but needs to be tested before the deadline ', due: '15/09/2021', tag: 'orange', user: john },
    {name: ' Invest in crypto ', description: ' Claim the bonus for the first investment ', due: '16/06/2022', tag: 'yellow', user: john },
    {name: ' Cancel itunes ', description: ' ', due: '1/09/2021', tag: 'green', user: john }
])


# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
