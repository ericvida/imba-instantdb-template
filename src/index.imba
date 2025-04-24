import Connect from './connect.imba'
import Login from './login.imba'
import Todos from './todos.imba'
import app from './app.imba'
import './css.imba'

tag App
	<self>
		<Connect> if !app.db
		<Login> if app.user == null
		<Todos> if app.user

imba.mount <App>