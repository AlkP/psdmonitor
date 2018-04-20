class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def update_sort(name)
    session[name] = {} if session[name].nil?
    if params['sort'] != session[name]['sort']
      session[name] = {}
      session[name]['sort']  = params['sort'].to_sym
      session[name]['index'] = 'asc'
      return
    end
    session[name]['index'] = session[name]['index'] == 'asc' ? 'desc' : 'asc'
  end
end
