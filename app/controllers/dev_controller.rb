class DevController < ApplicationController
  layout 'grid', only: [:grid]

  def grid; end
end
