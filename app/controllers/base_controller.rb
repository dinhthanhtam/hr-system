class BaseController < ApplicationController

  before_filter :load_parents
  before_filter :create_object, only: [:new, :create]
  before_filter :initialize_search, :load_objects, :save_search,  only: [:index]
  before_filter :load_object, only: [:show, :edit, :update, :destroy]
  class_attribute :_model_name
  helper_method :model, :model_name, :model_symbol

  authorize_resource

  def self.model_name(model_name=nil)
    self._model_name = model_name if model_name
    (_model_name || controller_name.classify).to_s
  end

  def self.model_symbol
    model_name.underscore.to_sym
  end

  def model
    self.class.model_name.constantize
  end

  def model_name
    self.class.model_name
  end

  def model_symbol
    self.class.model_symbol
  end

  def set_session_locale
    session[:locale] = :en
  end

protected
  def initialize_search
    if params[:clear]
      params.delete(:search)
      session[controller_path][:search].delete(action_name) rescue nil
    elsif !params[:search] && (session[controller_path][:search][action_name] rescue nil)
      params[:search] = session[controller_path][:search][action_name]
    end
    params[:search] || ((defaults = controller_name.underscore.send(action_name) rescue nil) && params[:search] = defaults)
  end

  def ordering(search)
    model
  end

  def load_objects
    instance_variable_set("@#{model_name.underscore.pluralize}", (@instances = (@search = ordering(params[:search]).search(params[:search])).page(params[:page]).per(params[:per_page])))
  end

  def save_search
    [controller_path, :search].inject(session) { |s, k| s[k] || (s[k]={}) }[action_name] = params[:search] if params[:search]
  end

  def create_object
    @instance = model.new(params[model_symbol]||{}) rescue nil
    instance_variable_set("@#{model_name.underscore}", @instance)
  end

  def load_object
    @instance = model.find(params[:id]) rescue nil
    instance_variable_set("@#{model_name.underscore}", @instance)
  end
  
  def load_parents
    params.each do |k,v|
      if /^(?<parent_model_name>.+)_id$/ =~ k
        parent_instance = parent_model_name.classify.constantize.find(params["#{parent_model_name}_id"]) rescue nil
        instance_variable_set("@#{parent_model_name}", parent_instance)
      end
    end
  end
end
