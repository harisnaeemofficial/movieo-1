use Bailador;

class Movieo::Controller::People {
	has $.model;

	method people-list {
		my @people = $.model.people-list();
		template 'people/index.html', @people;
	}

	method person-info($id) {
		my $person = $.model.person-info($id.Int);
		template 'people/info/index.html', $person; 
	}

	method person-edit($id) {
		my $person = $.model.person-edit($id.Int);
		template 'people/edit/index.html', $person; 
	}

	method person-update($id) {
		my %param	= request.params();

		my $title			= %param<title>;
		my $overview	= %param<overview>;

		my $person = $.model.person-update($id.Int, $title, $overview);

		return redirect 'people/info/$id'; 
	}

	method person-add() {
		my %param	= request.params();
		my $title			= %param<title>;
		my $overview	= %param<overview>;
		my $releaseyear	= %param<releaseyear>;

		my $person = $.model.people-add(:$title, :$overview, :$releaseyear);
		return redirect "info/$person"; 
	}
}
