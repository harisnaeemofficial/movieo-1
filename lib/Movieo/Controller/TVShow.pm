use Bailador;

class Movieo::Controller::TVShow {
	has $.model;

	method tvshow-list {
		my @tvshows = $.model.tvshow-list();
		template 'tvshow/index.html', @tvshows;
	}

	method tvshow-info($id) {
		my $tvshow = $.model.tvshow-info($id.Int);
		template 'tvshow/info/index.html', $tvshow; 
	}

	method edit-tvshow($id) {
		my $tvshow = $.model.tvshow-edit($id.Int);
		template 'tvshow/edit/index.html', $tvshow; 
	}

	method tvshow-update($id) {
		my %param	= request.params();

		my $title			= %param<title>;
		my $overview	= %param<overview>;

		my $tvshow = $.model.tvshow-update($id.Int, $title, $overview);

		return redirect 'tvshow/info/$id'; 
	}

	method tvshow-add() {
		my %param	= request.params();
		my $title			= %param<title>;
		my $overview	= %param<overview>;
		my $releaseyear	= %param<releaseyear>;

		my $tvshow = $.model.tvshow-add(:$title, :$overview, :$releaseyear);
		return redirect "info/$tvshow"; 
	}
}
