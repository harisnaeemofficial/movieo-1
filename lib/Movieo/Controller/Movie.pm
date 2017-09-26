use Bailador;

class Movieo::Controller::Movie {
	has $.model;

	method movie-list {
		my @movies = $.model.movie-list();
		template 'movie/index.html', @movies;
	}

	method movie-info($id) {
		my $movie = $.model.movie-info($id.Int);
		template 'movie/info/index.html', $movie; 
	}

	method edit-movie($id) {
		my $movie = $.model.movie-edit($id.Int);
		template 'movie/edit/index.html', $movie; 
	}

	method movie-update($id) {
		my %param	= request.params();

		my $title			= %param<title>;
		my $overview	= %param<overview>;

		my $movie = $.model.movie-update($id.Int, $title, $overview);

		return redirect 'movie/info/$id'; 
	}

	method movie-add() {
		my %param	= request.params();
		my $title			= %param<title>;
		my $overview	= %param<overview>;
		my $releaseyear	= %param<releaseyear>;

		my $movie = $.model.movie-add(:$title, :$overview, :$releaseyear);
		return redirect "info/$movie"; 
	}
}
