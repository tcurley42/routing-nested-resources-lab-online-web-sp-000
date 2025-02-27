class SongsController < ApplicationController

  def index
    if params[:artist_id]
      begin
        @songs = Artist.find(params[:artist_id]).songs
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "Artist not found"
        redirect_to artists_path
        return
      end
    else
      @songs = Song.all
    end
  end

  def show
    if params[:artist_id]
      begin
        @artist = Artist.find(params[:artist_id])
        @song = @artist.songs.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "Song not found"
        redirect_to artist_songs_path(@artist)
        return
      end
    else
      @song = Song.find(params[:id])
    end
  end

  def new
    @song = Song.new
  end

  def create
    @song = Song.new(song_params)

    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
    @song = Song.find(params[:id])
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist_name)
  end
end

