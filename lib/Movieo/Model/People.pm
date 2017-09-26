class Movieo::Model::People {
	has $.dbh is required;

	method people-list {
		my $sql = qq:to/END/;
		SELECT;
		END

		my $sth = $!dbh.prepare($sql);
		$sth.execute;
		my @people = $sth.allrows(:array-of-hash);
		return @people;
	}

	method person-info(Int $id) {
		my $sql = qq:to/END/;
		SELECT;
		END

		my $sth = $!dbh.prepare($sql);
		$sth.execute;

		my $person = $sth.row(:hash);
		return $person;
	}

	method person-edit(Int $id) {
		my $sql = qq:to/END/;
		SELECT;
		END

		my $sth = $!dbh.prepare($sql);
		$sth.execute;

		my $person = $sth.row(:hash);
		return $person;
	}

	method person-update(Int $id, $title, $overview) {
		my $sql = qq:to/END/;
		SELECT;
		END

		my $sth = $!dbh.prepare($sql);
		$sth.execute;
	}

	method person-add(:$title, :$overview, :$releaseyear?) {
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
		my $personid = $sth.row();
		return $personid;
		}
	}

}
