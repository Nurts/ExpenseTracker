require 'gchart'
class PagesController < ApplicationController

    def home
      @newchart = Gchart.pie_3d(:data => [20,10,15,5,50], :title => 'SDRuby Fu level', :size => '400x200', :labels => ['matt', 'rob', 'patrick', 'ryan', 'jordan'])
    end
end
  