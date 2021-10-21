class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    if not params.has_key?(:ratings) && not params.has_key(:sort_by)
      @ratings_to_show = session[:ratings_to_show]
      @movies = Movie.with_ratings(@ratings_to_show).order(session[:sort_by])
      if session[:sort_by] == 'title'
        @head_title_hilite = 'hilite p-3 mb-2 bg-warning text-dark'
      elsif session[:sort_by] == 'release_date'
        @head_release_hilite = 'hilite p-3 mb-2 bg-warning text-dark'
      end
    end
    if(params.has_key?(:ratings))
      @ratings_to_show = params[:ratings].stringify_keys
      @ratings_to_show = @ratings_to_show.transform_keys{|key| key.upcase}.keys
      session[:ratings_to_show] = @ratings_to_show
    else
      @ratings_to_show = {}
    end
    if params.has_key?(:sort_by)
      @movies = Movie.with_ratings(@ratings_to_show).order(params[:sort_by])
      if params[:sort_by] == 'title'
        @head_title_hilite = 'hilite p-3 mb-2 bg-warning text-dark'
      elsif params[:sort_by] == 'release_date'
        @head_release_hilite = 'hilite p-3 mb-2 bg-warning text-dark'
      end
      session[:sort_by] = params[:sort_by]
    else
      @movies = Movie.with_ratings(@ratings_to_show)
    end
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
