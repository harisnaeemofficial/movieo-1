use Bailador;

class Movieo::Controller::People {
	has $.model;

	method list {
		my @people = $.model.list();
		template 'people/index.html', @people;
	}

	method info($id) {
		my $person = $.model.info($id.Int);
		template 'people/info/index.html', $person; 
	}

	method edit($id) {
		my $person = $.model.edit($id.Int);
		template 'people/edit/index.html', $person; 
	}

	method update($id) {
		my %param	= request.params();

		my $title			= %param<title>;
		my $overview	= %param<overview>;

		my $person = $.model.update($id.Int, $title, $overview);

		return redirect 'people/info/$id'; 
	}

	method add() {
		my %param	= request.params();
		my $title			= %param<title>;
		my $overview	= %param<overview>;
		my $releaseyear	= %param<releaseyear>;

		my $person = $.model.add(:$title, :$overview, :$releaseyear);
		return redirect "info/$person"; 
	}
}
