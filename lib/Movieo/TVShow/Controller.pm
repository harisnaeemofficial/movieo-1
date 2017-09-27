use Bailador;

class Movieo::TVShow::Controller {
	has $.model;

	method list {
		my @tvshows = $.model.list();
		template 'tvshow/index.html', @tvshows;
	}

	method info($id) {
		my $tvshow = $.model.info($id.Int);
		template 'tvshow/info/index.html', $tvshow; 
	}

	method edit($id) {
		my $tvshow = $.model.edit($id.Int);
		template 'tvshow/edit/index.html', $tvshow; 
	}

	method update($id) {
		my %param	= request.params();

		my $title			= %param<title>;
		my $overview	= %param<overview>;

		my $tvshow = $.model.update($id.Int, $title, $overview);

		return redirect 'tvshow/info/$id'; 
	}

	method add() {
		my %param	= request.params();
		my $title			= %param<title>;
		my $overview	= %param<overview>;
		my $releaseyear	= %param<releaseyear>;

		my $tvshow = $.model.add(:$title, :$overview, :$releaseyear);
		return redirect "info/$tvshow"; 
	}
}
