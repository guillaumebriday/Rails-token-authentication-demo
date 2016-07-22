class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  # Ce before_action vérifira le token pour chaque requête.
  # Vous pouvez le placer dans les controllers enfants si vous voulez l'authentification
  # pour seulement certaines méthodes
  before_action :authenticate

  protected
  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_or_request_with_http_token do |token, options|
      @current_user = User.find_by(auth_token: token)
    end
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: 'Bad credentials', status: :unauthorized
  end
end
