import app from './app.imba'

export default tag Login
	step = 1
	email = ''
	code = ''

	def send
		let res = await app.send(email)
		step = 2 if res

	def login
		let res = await app.login(email,code)

	<self>
		css d:grid jac:center h:100vh
		
		<div> if step == 1
			css d:vflex
			<div> "Email"
				css ta:center fs:20px
			<input.input bind=email>
				css w:250px ta:center mt:10px
			<button.button @click=send> 'Send code'
				css w:100px mx:auto mt:10px

		<div> if step == 2
			css d:vflex
			<div> "Code"
				css ta:center fs:20px
			<input.input bind=code>
				css w:140px ta:center mt:10px mx:auto
			<button.button @click=login> 'Login'
				css w:100px mx:auto mt:10px

		