use Bailador;
use Movieo::IoC;


class Movieo {
	submethod TWEAK(|) {
		container setup-ioc();
		
		get		'/' => sub {
			template 'index.html', :layout('landing-page.html');
		};

		get		'/movie'	=> {
			service => 'ControllerMovie',
			to			=> 'movie-list'
		}

		get		'/movie/info/:id'	=> {
			service => 'ControllerMovie',
			to			=> 'movie-info'
		}

		get		'/movie/edit/:id'	=> {
			service => 'ControllerMovie',
			to			=> 'movie-edit'
		}

		post	'/movie/edit/:id'	=> {
			service => 'ControllerMovie',
			to			=> 'movie-update'
		}

		get		'/movie/add'	=> sub {
			template '/movie/add/index.html';
		}

		post	'/movie/add'	=> {
			service => 'ControllerMovie',
			to			=> 'movie-add'
		}


		get		'/tvshow'	=> {
			service => 'ControllerTVShow',
			to			=> 'tvshow-list'
		}

		get		'/tvshow/info/:id'	=> {
			service => 'ControllerTVShow',
			to			=> 'tvshow-info'
		}

		get		'/tvshow/edit/:id'	=> {
			service => 'ControllerTVShow',
			to			=> 'tvshow-edit'
		}

		post	'/tvshow/edit/:id'	=> {
			service => 'ControllerTVShow',
			to			=> 'tvshow-update'
		}

		get		'/tvshow/add'	=> sub {
			template '/tvshow/add/index.html';
		}

		post	'/tvshow/add'	=> {
			service => 'ControllerTVShow',
			to			=> 'tvshow-add'
		}


		get		'/people'	=> {
			service => 'ControllerPeople',
			to			=> 'people-list'
		}

		get		'/people/info/:id'	=> {
			service => 'ControllerPeople',
			to			=> 'person-info'
		}

		get		'/people/edit/:id'	=> {
			service => 'ControllerPeople',
			to			=> 'person-edit'
		}

		post	'/people/edit/:id'	=> {
			service => 'ControllerPeople',
			to			=> 'person-update'
		}

		get		'/people/add'	=> sub {
			template '/people/add/index.html';
		}

		post	'/people/add'	=> {
			service => 'ControllerPeople',
			to			=> 'person-add'
		}



		static-dir / (.*) / => 'assets/';
	}

	method start {
  	baile;
  }
}
