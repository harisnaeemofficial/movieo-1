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
			to			=> 'list'
		}

		get		'/movie/info/:id'	=> {
			service => 'ControllerMovie',
			to			=> 'info'
		}

		get		'/movie/edit/:id'	=> {
			service => 'ControllerMovie',
			to			=> 'edit'
		}

		post	'/movie/edit/:id'	=> {
			service => 'ControllerMovie',
			to			=> 'update'
		}

		get		'/movie/add'	=> sub {
			template '/movie/add/index.html';
		}

		post	'/movie/add'	=> {
			service => 'ControllerMovie',
			to			=> 'add'
		}


		get		'/tvshow'	=> {
			service => 'ControllerTVShow',
			to			=> 'list'
		}

		get		'/tvshow/info/:id'	=> {
			service => 'ControllerTVShow',
			to			=> 'info'
		}

		get		'/tvshow/edit/:id'	=> {
			service => 'ControllerTVShow',
			to			=> 'edit'
		}

		post	'/tvshow/edit/:id'	=> {
			service => 'ControllerTVShow',
			to			=> 'update'
		}

		get		'/tvshow/add'	=> sub {
			template '/tvshow/add/index.html';
		}

		post	'/tvshow/add'	=> {
			service => 'ControllerTVShow',
			to			=> 'add'
		}


		get		'/people'	=> {
			service => 'ControllerPeople',
			to			=> 'list'
		}

		get		'/people/info/:id'	=> {
			service => 'ControllerPeople',
			to			=> 'info'
		}

		get		'/people/edit/:id'	=> {
			service => 'ControllerPeople',
			to			=> 'edit'
		}

		post	'/people/edit/:id'	=> {
			service => 'ControllerPeople',
			to			=> 'update'
		}

		get		'/people/add'	=> sub {
			template '/people/add/index.html';
		}

		post	'/people/add'	=> {
			service => 'ControllerPeople',
			to			=> 'add'
		}



		static-dir / (.*) / => 'assets/';
	}

	method start {
  	baile;
  }
}
