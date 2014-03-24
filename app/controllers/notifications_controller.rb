class NotificationsController < ApplicationController
  before_action :valid_params
  
  def hipchat
    client = HipChat::Client.new(@token)
    client[@room].send('deploy', message)
    render :text => 'ok'
  end

  private

  def valid_params
    @token = params['token']
    @room = params['room']
    @branch = params['branch']
    @url = params['url']

    unless @token and @room and @branch and @url
      render :text => 'Bad Request', :status => 400 
    end
  end

  def message
    "#{@branch} is deployed to <a href='#{@url}'>#{@url}</a>"
  end
end
