use Bailador;

class Movieo::Movie {

	method routes() {

		get		'/movie'	=> {
			service => 'MovieController',
			to			=> 'list'
		}

		get		'/movie/info/:id'	=> {
			service => 'MovieController',
			to			=> 'info'
		}

		get		'/movie/edit/:id'	=> {
			service => 'MovieController',
			to			=> 'edit'
		}

		post	'/movie/edit/:id'	=> {
			service => 'MovieController',
			to			=> 'update'
		}

		get		'/movie/add'	=> sub {
			template '/movie/add/index.html';
		}

		post	'/movie/add'	=> {
			service => 'MovieController',
			to			=> 'add'
		}
	}
}
