class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @the_ratings = Array.new
    Movie.select(:rating).distinct.each do |movie|
      @the_ratings.push movie.rating
    end
    @ratings = params[:ratings] ? params[:ratings].keys : @the_ratings
    @ratings.delete("hidden")
    @movies = Movie.where(:rating => @ratings)
  end

  def sort
    index
    @the_order = params[:order]
    if !@the_order  
      @the_order = "increase"
    end
    
    @the_keyword = params[:keyword]
    if @the_keyword 
      @movies = @movies.order("#{@the_keyword}#{@the_order == 'increase' ? '' : ' DESC'}")
      @the_order = @the_order == "increase" ? "decrease" : "increase"
    end
    render 'movies/index'
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
