class InfoController < ApplicationController
  
  def about
  end

  def privacy
  end

  def tos
  end
  
  private
  
  def use_https?
    false # Override in other controllers
  end
end
