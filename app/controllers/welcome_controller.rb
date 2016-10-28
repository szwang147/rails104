class WelcomeController < ApplicationController

  def index
    flash[:notice] = "cao!!!"
    flash[:alert] = "wo cao!!!"
  flash[:warning] = "wo you lai le!!!"

end
end
