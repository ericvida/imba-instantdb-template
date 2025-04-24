import {init, id as guid} from '@instantdb/core'
import {ClientIDB} from 'instantdb-imba'

class App
	db\ClientIDB
	user = undefined
	todos = []

	def constructor
		connect(imba.locals.appId) if imba.locals.appId

	def connect appID
		db = new ClientIDB(init({appId: appID}), guid)

		db.auth.listen
			onauth: do(user) 
				user = user
				imba.commit!
				return if user == null

				# save app id
				imba.locals.appId = appID

				# subsribe to user's todos
				db.subscribe 
					name: 'user.todos'
					query: 
						$users: 
							$:
								where:
									id: user.id
							todos:{}

					# when user's todos are updated
					onupdate: do(data) 
						todos = data.$users[0].todos
						imba.commit!

			onerror: do(err) console.log err
		

	def send email
		db.auth.send
			email: email
			# onsuccess: do(res) console.log res
			# onerror: do(err) console.log err
	
	def login email, code
		db.auth.login
			email: email
			code: code
			# onsuccess: do(res) console.log res
			# onerror: do(err) console.log err

	def logout
		db = undefined
		delete imba.locals.appId
		db.unsubscribe 'user.todos'
		db.auth.logout!

	def toggle idx
		todos[idx].completed = !todos[idx].completed
		db.write
			records:
				table: 'todos'
				action: 'update'
				id: todos[idx].id
				data:
					completed: todos[idx].completed
			# onsuccess: do(res) console.log res
			onerror: do(err) console.log err

	def create text
		let todo = {text: text, completed: false}
		todos.push(todo)
		db.write
			records:
				table: 'todos'
				action: 'create'
				data: todo
				links:
					user: user.id
			# onsuccess: do(res) console.log res
			onerror: do(err) console.log err

	def delete idx
		let todo = todos[idx]
		todos.slice(idx,1)
		db.write
			records:
				table: 'todos'
				action: 'delete'
				id: todo.id
			# onsuccess: do(res) console.log res
			onerror: do(err) console.log err

export default new App!