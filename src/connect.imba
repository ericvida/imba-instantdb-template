import app from './app.imba'

export default tag Connect
	appId = 'ed1679e7-7a85-4d3f-9842-4ed0b9de8644'

	def connect
		await app.connect(appId)

	<self>
		css d:grid jac:center h:100vh
		<div> "AppId"
			css ta:center fs:20px
		<input.input bind=appId>
			css w:340px ta:center mt:10px
		<button.button @click=connect> 'Connect'
			css w:100px mx:auto mt:10px