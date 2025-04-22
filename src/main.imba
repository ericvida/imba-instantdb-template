const INSTANT_APP_ID = "REPLACE_WITH_YOUR_PUBLIC_APP_ID" 
import 'imba/preflight.css'
import * as PH from 'imba-phosphor-icons'
import {init, tx, id} from '@instantdb/core'
import _schema from './schema.imba'

# Instant DB class
global.DB = init({ appId: INSTANT_APP_ID, _schema});

# FRONT-END APP STATE
global.FE = {
	user: null
	tasks: [],
}

global css @root
	$icon-size: 28px
	div.row d:flex gap:1em
	div.col d:vflex gap:1em
	input c:gray9 px:10px rd:5px fs:16px flg:1 bxs:xs, inner py:5px h:$icon-size
	button c:gray9 bg:gray1 @hover:yellow3 rd:5px fs:16px h:$icon-size px:1em d:hcc
		&.icon p:0px size: $icon-size
	div.card max-width:600px bg:white rd:xl shadow:lg, md p:2em d:vflex jc:space-between ta:left gap:1em

tag app
	css d:vtc
	waiting_login = false
	magic_code = ''
	email_input = ''
	sentCode = false
	def mount
		subscribe!
	def subscribe
		DB.subscribeAuth do(auth)
			console.log('Auth state changed:', auth)
			if auth.error
				console.log 'Error during authentication'
			elif auth.user
				FE.user = auth.user
				waiting_login = false
				imba.commit!
				if FE.user
					console.log FE.user.id
					const query = 
						tasks: 
							$:
								where: 
									"$users.id": FE.user.id
					console.log('Executing query:', query)
					const unsub = DB.subscribeQuery query, do(resp)
						console.log('Query response:', resp)
						if resp.error
							console.error('Uh oh!', resp.error.message)
						elif resp.data
							if resp.data.tasks
								FE.tasks = resp.data.tasks or [] 
								imba.commit!
							else
								console.warn('Unexpected response structure:', resp)
						else
							console.warn('Unexpected response:', resp)
				else
					console.warn('User is not logged in. Skipping query.')
			else
				waiting_login = true
				FE.user = null
				imba.commit!

	def sendMagicCode
		if !email_input
			console.error('Email is required to send a magic code.')
			return
		console.log email_input, 'clicked login'
		await DB.auth.sendMagicCode({ email: email_input })
		sentCode = true
		imba.commit!

	def logout
		console.log 'clicked logout'
		await DB.auth.signOut()
		FE.user = null
		imba.commit!

	def signIn
		if !email_input or !magic_code
			console.error('Both email and code are required to sign in.')
			return
		await DB.auth.signInWithMagicCode({ email: email_input, code: magic_code })
		sentCode = false

	<self>
		css bg:gray1 inset:0 d:vcc gap:2em
		<h1 [fs:xx-large ff:mono]> "Imba ❤ InstantDB"
		<div.card>
			
			unless FE.user
				<div.col>
					if INSTANT_APP_ID is 'REPLACE_WITH_YOUR_PUBLIC_APP_ID'
						<p> 'Please set your InstantDB App ID on line 1 in src/main.imba'
					else
						if sentCode
							<p> "Check your email for the magic code."
							<div.row>
								<input [] type="text" bind=magic_code placeholder="Enter magic code">
								<button @click.signIn> "Login"
						else
							<p> "Please enter your email and click 'get code' to receive a magic code."
							<div.row>
								<input [w:auto] type="text" bind=email_input placeholder="Enter your email">
								<button[px:1em] @click.sendMagicCode> "get code"
			else
				<div.row [d:hcr]>
					<p> "Crush it {FE.user.email.split('@').shift!}!"
					<button @click.logout> "logout"
				<add-task>
				<task-list>

tag add-task
	@observable task_input = ''
	def saveTask task
		if !FE.user
			console.error 'Cannot save task: No FE.user is logged in.'
			return
		console.log "there is id {FE.user.id}"
		await DB.transact [
			tx.tasks[id()].update(	
				content: task_input
				createdAt: Date.now()
			).link({$users: FE.user.id}) # link the task to the logged in user
		]
		task_input = ''
		imba.commit!
	<self>
		<div.row>
			<input bind=task_input @keydown.enter.saveTask placeholder="Add a task">
			<button.icon @click.saveTask >
				css d:flex jc:center p:5px
				<svg src=PH.PLUS [size:18px fill:indigo4]>

tag task-list
	task_content = ''
	taskID = ''
	
	def editTask task
		task_content = "{task.content}"
		taskID = task.id
	
	def deleteTask task
		DB.transact [tx.tasks[task.id].delete()]
		task_content = ''
		taskID = ''
		imba.commit!
	def saveTask task
		DB.transact
			[
				tx.tasks[task.id].update(
					content: task_content
				)
			]
		task_content = ''
		taskID = ''
		imba.commit!
	<self>
		css d:vflex gap:0.5em
		for task in FE.tasks
			if taskID is ''
				<div>
					css d:flex gap:1em
					<span[ff:serif flg:1]> "{task.content}"
						css bg:gray0 px:1em rd:md
					css button d:flex jc:center p:5px
					<button.icon @click=editTask(task)>
						<svg src=PH.PENCIL [size:18px fill:indigo4]>
					<button.icon @click=deleteTask(task)>
						<svg src=PH.TRASH [size:18px fill:indigo4]>
						
			elif taskID is task.id
				<div>
					css d:flex gap:1em
					<input [flg:1] bind=task_content>
					<button.icon @click=saveTask(task) [d:flex d:hcc]>
						<svg src=PH.FLOPPY_DISK [size:18px fill:indigo4]>

imba.mount <app>