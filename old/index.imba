const INSTANT_APP_ID = "REPLACE_WITH_YOUR_PUBLIC_APP_ID" 
const LOCAL_DB_NAME = "instantdb-imba-template"
import {ClientIDB} from './lib/instantdb-imba/index.imba'
import 'imba/preflight.css'
import * as PH from 'imba-phosphor-icons'
import {init, tx, id} from '@instantdb/core'
class dataSYNC
	def constructor
		local = imba.locals(LOCAL_DB_NAME)
		local.user
		local.tasks
		local.login? # null = waiting, yes, no
		local.sentCode? # yes, no
		local.error
		local.loading
		local.email_input

global.DATA = new dataSYNC()
class InstantAPI
	def constructor
		DATA.instant = init({ appId: INSTANT_APP_ID});
	def subscribe
		DATA.instant.subscribeAuth do(auth)
			console.log('Auth state changed:', auth)
			if auth.error
				console.log 'Error during authentication'
			elif auth.user
				DATA.local.user = auth.user
				DATA.local.login? = yes
				imba.commit!
				if DATA.local.user
					console.log DATA.local.user.id
					const query = 
						tasks: 
							$:
								where: 
									"$users.id": DATA.local.user.id
					console.log('Executing query:', query)
					const unsub = DATA.instant.subscribeQuery query, do(resp)
						console.log('Query response:', resp)
						if resp.error
							console.error('Uh oh!', resp.error.message)
						elif resp.data
							if resp.data.tasks
								DATA.local.tasks = resp.data.tasks or [] 
								imba.commit!
							else
								console.warn('Unexpected response structure:', resp)
						else
							console.warn('Unexpected response:', resp)
				else
					console.warn('User is not logged in. Skipping query.')
			else
				DATA.local.login? = true
				DATA.local.user = no
				imba.commit!
	def sendMagicCode
		if !DATA.local.email_input
			console.error('Email is required to send a magic code.')
			return
		console.log DATA.local.email_input, 'clicked login'
		await DATA.instant.auth.sendMagicCode({ email: DATA.local.email_input })
		DATA.local.sentCode? = true
		imba.commit!
	def logout
		console.log 'clicked logout'
		await DATA.instant.auth.signOut()
		DATA.local.user = no
		# FIXME -  after logout the email_input value is false, must be fixed.
		DATA.local.email_input = ''
		imba.commit!
	def loginWithCode magic_code
		if !DATA.local.email_input or !magic_code
			console.error('Both email and code are required to sign in.')
			return
		await DATA.instant.auth.signInWithMagicCode({ email: DATA.local.email_input, code: magic_code })
		DATA.local.email_input = false
		DATA.local.sentCode? = false
global.API = new InstantAPI()


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
	magic_code = ''
	@observable email_input = if DATA.local.email_input isnt '' then DATA.local.email_input else ''
	@autorun def persistEmailInput
		DATA.local.email_input = email_input
	def mount
		DATA.local.email_input
		API.subscribe!
	
	<self>
		css bg:gray1 inset:0 d:vcc gap:2em
		<h1 [fs:xx-large ff:mono]> "Imba ❤ InstantDB"
		<div.card>
			
			unless DATA.local.user
				<div.col>
					if INSTANT_APP_ID is 'REPLACE_WITH_YOUR_PUBLIC_APP_ID'
						<p> 'Please set your InstantDB App ID on line 1 in src/index.imba'
					else
						if DATA.local.sentCode?
							<p> "Check your email for the magic code."
							<div.row>
								<input [] type="text" bind=magic_code placeholder="Enter magic code">
								<button @click=API.loginWithCode(magic_code)> "Login"
						else
							<p> "Please enter your email and click 'get code' to receive a magic code."
							<div.row>
								<input [w:auto] type="text" bind=email_input placeholder="Enter your email">
								<button[px:1em] @click=API.sendMagicCode!> "get code"
			else
				<div.row [d:hcr]>
					<p> "Crush it {DATA.local.user.email.split('@').shift!}!"
					<button @click=(API.logout!, email_input = '')> "logout"
				<add-task>
				<task-list>

tag add-task
	@observable task_input = ''
	def saveTask task
		if !DATA.local.user
			console.error 'Cannot save task: No DATA.local.user is logged in.'
			return
		console.log "there is id {DATA.local.user.id}"
		await DATA.instant.transact [
			tx.tasks[id()].update(	
				content: task_input
				createdAt: Date.now()
			).link({$users: DATA.local.user.id}) # link the task to the logged in user
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
		DATA.instant.transact [tx.tasks[task.id].delete()]
		task_content = ''
		taskID = ''
		imba.commit!
	def saveTask task
		DATA.instant.transact
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
		for task in DATA.local.tasks
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
					<input [flg:1] bind=task_content @keydown.enter.saveTask(task)>
					<button.icon @click=saveTask(task) [d:flex d:hcc]>
						<svg src=PH.FLOPPY_DISK [size:18px fill:indigo4]>

imba.mount <app>