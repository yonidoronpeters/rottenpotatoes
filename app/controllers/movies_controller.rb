class MoviesController < ApplicationController

  #Rails.logger = Logger.new(STDOUT)
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    if ! params[:ratings].present? && session[:params].present?; flash.keep; redirect_to session[:params]; end
    
    if ! session[:params].present?
      session[:params] = Hash.new; session[:params][:ratings] = Hash.new
      @all_ratings.each { |key| session[:params][:ratings][key] = '1' }
    end #new session
    
    @sort_by = params[:sort] || session[:sort]
    if params[:sort] != session[:sort]; session[:sort] = @sort_by; end
    
    @ratings = (params[:ratings].present? ? params[:ratings].keys : session[:params][:ratings].keys)

    if @sort_by == 'title'
      @title = 'hilite'
      @movies = Movie.where('rating' => @ratings).order('title ASC')
    elsif @sort_by == 'release_date'
      @release_date = 'hilite'
      @movies = Movie.where('rating' => @ratings).order('release_date ASC')
    else
      @movies = Movie.where('rating' => @ratings)
    end
    session[:params] = params
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
