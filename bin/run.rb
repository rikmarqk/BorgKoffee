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
        puts "\n\nT h e r e  y o u  g o ,  o n e  d e l i c i o u s  #{@coffee.name.green}"
        prompt = TTY::Prompt.new
        x = prompt.select("\n\nN o w  w h a t  w o u l d  y o u  l i k e  t o  d o ?") do |menu|
            menu.choice "M a k e  a n o t h e r  D r i n k", 1
            menu.choice "G o  b a c k  t o  H o m e\n\n", 2
        end
        prompt
        if x == 1
            create_drink
        else
            home
        end
    end

    def login_or_new
        prompt = TTY::Prompt.new
        v = prompt.select("\n\nL e t ' s   d i s c o v e r  y o u r  n e w  f a v o r i t e  C o f f e e !") do |menu|
            menu.choice "L o g i n", 1
            menu.choice "N e w  U s e r\n\n", 2
            menu.choice "Q u i t\n\n", 3
        end
        prompt
        if v == 2
            create_user
            puts "W E L C O M E  #{@user.name.green}"
        elsif v == 1
            login
        else
            quit
        end
    end

    def home
        prompt = TTY::Prompt.new
        x = prompt.select("\n\nB o r g K o f f e e  -  H o m e\n") do |menu|
            menu.choice "M a k e  m y  o w n  d r i n k", 1
            menu.choice "G e t  a  d r i n k  s u g g e s t i o n", 2
            menu.choice "L e t  m e  s e e  t h e  m e n u\n\n", 3
            menu.choice "Q u i t\n\n", 4
        end
        prompt
        if x == 1
            create_drink
        elsif x == 2
            suggest_drink
        elsif x == 3
            menu
        else
            quit
        end
    end

    def suggest_drink
        total = 0
        drink = Coffee.all.sample
        puts "\nH o w  a b o u t  a(n) #{drink.name} for #{drink.price} ?"
        prompt = TTY::Prompt.new
        x = prompt.select("\n\nH o w  d o e s  t h a t  s o u n d ?") do |menu|
            menu.choice "S o u n d s  g r e a t ,  I ' l l  t a k e  i t", 1
            menu.choice "W h a t  e l s e  y a  g o t ?\n\n", 2
            menu.choice "R e t u r n  t o  H o m e\n\n", 3
        end
        prompt
        if x == 1
            puts "E x c e l l e n t ,  h o w  m a n y  w o u l d  y o u  l i k e ?"
            quantity = gets.chomp
            total = quantity.to_f * drink.price
            puts "Your total is #{total}"
        elsif x == 2
            suggest_drink
        else
            home
        end
        prompt2 = TTY::Prompt.new
        y = prompt.select("\n\nH o w  d o e s  t h a t  s o u n d ?") do |menu|
            menu.choice "A n o t h e r  S u g g e s t i o n  P l e a s e", 1
            menu.choice "R e t u r n  t o  H o m e\n\n", 2
            menu.choice "Q u i t\n\n", 3
        end
        prompt2
        if y == 1
            puts "E x c e l l e n t ,  h o w  m a n y  w o u l d  y o u  l i k e ?"
            suggest_drink
        elsif y == 2
            home
        else
            quit
        end

    end

    def menu
        puts "W h i c h  c i t y  a r e  l o c a t e d  a t ?"
        location = gets.chomp
        receipt = Receipt.create(location: location)
        coffee_options = Coffee.all.map {|coffee| coffee.name}
        prompt = TTY::Prompt.new
        x = prompt.select("N o w  w h a t  w o u l d  y o u  l i k e  t o  d o ?\n\n", coffee_options)
        prompt
        selected_coffee = Coffee.all.find {|coffee| coffee.name == x}
        puts selected_coffee.name.green
        puts "$"+ selected_coffee.price.to_s
        puts selected_coffee.category
        puts selected_coffee.season
        prompt = TTY::Prompt.new
        x = prompt.select("\n\nH o w  d o e s  t h a t  s o u n d ?") do |menu|
            menu.choice "S o u n d s  g r e a t ,  I ' l l  t a k e  i t", 1
            menu.choice "R e t u r n  t o  M e n u\n\n", 2
            menu.choice "R e t u r n  t o  H o m e\n\n", 3
        end
        prompt
        if x == 1
            puts "E x c e l l e n t ,  h o w  m a n y  w o u l d  y o u  l i k e ?"
            quantity = gets.chomp
            total = quantity.to_f * selected_coffee.price
            p "Y o u r  t o t a l  i s  $#{total}"
            coffee_receipt = CoffeeReceipt.create(coffee_id: selected_coffee.id, receipt_id: receipt.id)
        elsif x == 2
            menu
        else
            home
        end
        prompt2 = TTY::Prompt.new
        y = prompt.select("\n\nW h a t  w o u l d  y o u  l i k e  t o  d o  n e x t ?") do |menu|
            menu.choice "S e e  M e n u  a g a i n", 1
            menu.choice "R e t u r n  t o  H o m e\n\n", 2
            menu.choice "Q u i t\n\n", 3
        end
        prompt2
        if y == 1
            menu
        elsif y == 2
            home
        else
            quit
        end


    end

    def quit
        abort
    end


    def run
        welcome       
        login_or_new
        home
    end

end
AppCLI.new.run

