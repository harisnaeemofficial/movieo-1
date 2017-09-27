use Bailador;

class Movieo::Movie::Controller {
	has $.model;

	method list {
		my @movies = $.model.list();
		template 'movie/index.html', @movies;
	}

	method info($id) {
		my $movie = $.model.info($id.Int);
		template 'movie/info/index.html', $movie; 
	}

	method edit($id) {
		my $movie = $.model.edit($id.Int);
		template 'movie/edit/index.html', $movie; 
	}

	method update($id) {
		my %param	= request.params();

		my $title			= %param<title>;
		my $overview	= %param<overview>;

		my $movie = $.model.update($id.Int, $title, $overview);

		return redirect 'movie/info/$id'; 
	}

	method add() {
		my %param	= request.params();
		my $title			= %param<title>;
		my $overview	= %param<overview>;
		my $releaseyear	= %param<releaseyear>;

		my $movie = $.model.add(:$title, :$overview, :$releaseyear);
		return redirect "info/$movie"; 
	}
}
