class InfoController < ApplicationController
  layout :resolve_layout
  
  def about
  end

  def privacy
  end

  def tos
  end

  def why
  end

  private
  
  def use_https?
    false # Override in other controllers
  end

  def resolve_layout
    case action_name
    when "why"
      "index_layout"
    else
      "application"
    end
  end

end
