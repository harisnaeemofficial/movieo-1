class Movieo::TVShow::Model {
	has $.dbh is required;

	method list {
		my $sql = qq:to/END/;
		SELECT;
		END

		my $sth = $!dbh.prepare($sql);
		$sth.execute;
		my @tvshows = $sth.allrows(:array-of-hash);
		return @tvshows;
	}

	method info(Int $id) {
		my $sql = qq:to/END/;
		SELECT;
		END

		my $sth = $!dbh.prepare($sql);
		$sth.execute;

		my $tvshow = $sth.row(:hash);
		return $tvshow;
	}

	method edit(Int $id) {
		my $sql = qq:to/END/;
		SELECT;
		END

		my $sth = $!dbh.prepare($sql);
		$sth.execute;

		my $tvshow = $sth.row(:hash);
		return $tvshow;
	}

	method update(Int $id, $title, $overview) {
		my $sql = qq:to/END/;
		SELECT;
		END

		my $sth = $!dbh.prepare($sql);
		$sth.execute;
	}

	method add(:$title, :$overview, :$releaseyear?) {
		my $sql = qq:to/END/;
		SELECT;
		END

		my $sth = $!dbh.prepare($sql);
		$sth.execute;
		my @titles = $sth.allrows();
		if $title eq @titles.any {
			return;
		}
		else {
		my $sql = qq:to/END/;
		SELECT;
		END

		my $sth = $!dbh.prepare($sql);
		$sth.execute;
		my $tvshowid = $sth.row();
		return $tvshowid;
		}
	}
}
