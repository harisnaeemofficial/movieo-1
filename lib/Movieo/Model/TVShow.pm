class Movieo::Model::TVShow {
	has $.dbh is required;

	method tvshow-list {
		my $sql = qq:to/END/;
		SELECT;
		END

		my $sth = $!dbh.prepare($sql);
		$sth.execute;
		my @tvshows = $sth.allrows(:array-of-hash);
		return @tvshows;
	}

	method tvshow-info(Int $id) {
		my $sql = qq:to/END/;
		SELECT;
		END

		my $sth = $!dbh.prepare($sql);
		$sth.execute;

		my $tvshow = $sth.row(:hash);
		return $tvshow;
	}

	method tvshow-edit(Int $id) {
		my $sql = qq:to/END/;
		SELECT;
		END

		my $sth = $!dbh.prepare($sql);
		$sth.execute;

		my $tvshow = $sth.row(:hash);
		return $tvshow;
	}

	method tvshow-update(Int $id, $title, $overview) {
		my $sql = qq:to/END/;
		SELECT;
		END

		my $sth = $!dbh.prepare($sql);
		$sth.execute;
	}

	method tvshow-add(:$title, :$overview, :$releaseyear?) {
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
