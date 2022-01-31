class AwtController < ApplicationController
  def index
    @class_list = CLASS_LIST.select {|key, value| value["wta_score"] == true }
    @awt = get_awt_with_runners
  end
end
