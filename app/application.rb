class Application

  @@items = ["Apples","Carrots","Pears", "Figs"] #class variable holding stuff
  @@cart = []

  def call(env) #still havnt had env explained
    resp = Rack::Response.new #responses to request (basically 'puts')
    req = Rack::Request.new(env) #requests, basically gets.chomp(, but for urls?)

    if req.path.match(/items/) #iteration to resp.write each item in the list
      @@items.each do |item|
        resp.write "#{item}\n"
      end

    elsif req.path.match(/search/)
      search_term = req.params["q"] #backwards hash assignment
      resp.write handle_search(search_term) #abstracted code, below. finds item if in the list, else resp.writes out a 'nope' message

    elsif req.path.match(/cart/)
      if @@cart.length == 0
        resp.write "Your cart is empty"
      else
        @@cart.each do |item_in_cart|
          resp.write "#{item_in_cart}\n"
        end
      end

    elsif req.path.match(/add/)
      add_term = req.params["item"]
      resp.write add_item(add_term)

    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term) #checks @@items to see if the search term in the url matches one of the items.
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end

  def add_item(add_term)
    if @@items.include?(add_term)
      @@cart << add_term
      return "added #{add_term}\n"
    else
      return "We don't have that item"
    end
  end

end
