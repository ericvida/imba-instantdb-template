import app from './app.imba'

export default tag Todos

	def create
		app.create($newtodo.value)
		$newtodo.value = ''

	<self>
		css d:grid jac:center h:100vh pos:relative
		<div>
			css d:hflex mb:20px
			<input$newtodo .input>
			<button.button @click=create> 'Add Todo'
				css ml:10px
		for todo, idx in app.todos
			<div>
				css d:hflex
				<input type='checkbox' checked=todo.completed @change=app.toggle(idx)>
				<div> todo.text
					css ml:10px
				<div @click=app.delete(idx)> '❌'
					css ml:10px cursor:pointer
		
		<button.button @click=app.logout> 'Logout'
			css pos:absolute top:10px right:10px