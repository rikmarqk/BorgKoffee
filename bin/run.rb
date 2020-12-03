require_relative '../config/environment'
require 'colorize'

class AppCLI
    def welcome
        puts "\n\nW e l c o m e  t o  B o r g K o f f e e"
    end
    def create_user
        puts "E n t e r  y o u r  N a m e: "
        name = gets.chomp
        puts "E n t e r  y o u r  B i r t h d a y: "
        dob = gets.chomp
        puts "E n t e r  y o u r  E m a i l: "
        email = gets.chomp
        @user = User.create(name: name, date_of_birth: dob, email: email)
    end

    def login
        puts "E n t e r  y o u r  E m a i l:"
        email = gets.chomp
        User.all.find do |u|
            if u.email == email
                puts "\nW e l c o m e  B a c k ,  #{u.name}"
            end
        end
    end

    def create_drink
        puts "\n\nW h a t  i s  t h e  n a m e  o f  y o u r  c u s t o m  d r i n k ?"
        name = gets.chomp
        puts "\n\nW h a t  k i n d  o f  c o f f e e  i s  t h i s ?"
        category = gets.chomp
        puts "\n\nW h a t  s e a s o n  i s  i t  f o r ?"
        season = gets.chomp
        puts "\n\nN a m e  y o u r  p r i c e ."
        price = gets.chomp
        @coffee = Coffee.create(name: name, category: category, season: season, price: price)
        puts "\n\nT h e r e  y o u  g o ,  o n e  d e l i c i o u s  #{@coffee.name}"
    end

    def login_or_new
        prompt = TTY::Prompt.new
        v = prompt.select("\n\nL e t ' s   d i s c o v e r  y o u r  n e w  f a v o r i t e  C o f f e e !") do |menu|
            menu.choice "L o g i n", 1
            menu.choice "N e w  U s e r\n\n", 2
        end
        prompt
        if v == 2
            create_user
            puts "W E L C O M E  #{@user.name.green}"
        else
            login
        end
    end

    def main_menu
        prompt = TTY::Prompt.new
        x = prompt.select("\n\nW h a t  w o u l d  y o u  l i k e  t o  d o ?") do |menu|
            menu.choice "M a k e  m y  o w n  d r i n k", 1
            menu.choice "G e t  a  d r i n k  s u g g e s t i o n", 2
            menu.choice "L e t  m e  s e l e c t  a  d r i n k\n\n", 3
        end
        prompt
        if x == 1
            create_drink
        elsif x == 2
            suggest_drink
        else
            menu
        end
    end

    def suggest_drink
        sugg = []
        Coffee.all.each_with_index do |c|
            sugg << "#{c.name} for #{c.price}"
        end
        drink = sugg.sample
        puts "\nH o w  a b o u t  a(n)  #{drink.green} ?"
        prompt = TTY::Prompt.new
        x = prompt.select("\n\nH o w  d o e s  t h a t  s o u n d ?") do |menu|
            menu.choice "S o u n d s  g r e a t ,  I ' l l  t a k e  i t", 1
            menu.choice "W h a t  e l s e  y a  g o t ?", 2
            menu.choice "N e v e r m i n d", 3
        end
        prompt
        if x == 1
            puts "E x c e l l e n t ,  h o w  m a n y  w o u l d  y o u  l i k e ?"
            quantity = gets.chomp
            total = quantity ** price
            puts "Your total is #{total}"
        elsif x == 2
            suggest_drink
        else
            main_menu
        end

    end

    def menu
        Coffee.all.each_with_index do |c|
            p "#{c.name} - #{c.price}"
        end
    end


    def run
        welcome       
        login_or_new
        main_menu
    end

end
AppCLI.new.run

