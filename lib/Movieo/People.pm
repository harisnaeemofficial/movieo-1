use Bailador;

class Movieo::People {
	
	method routes() {
		get		'/people'	=> {
			service => 'PeopleController',
			to			=> 'list'
		}

		get		'/people/info/:id'	=> {
			service => 'PeopleController',
			to			=> 'info'
		}

		get		'/people/edit/:id'	=> {
			service => 'PeopleController',
			to			=> 'edit'
		}

		post	'/people/edit/:id'	=> {
			service => 'PeopleController',
			to			=> 'update'
		}

		get		'/people/add'	=> sub {
			template '/people/add/index.html';
		}

		post	'/people/add'	=> {
			service => 'PeopleController',
			to			=> 'add'
		}
	}
}
