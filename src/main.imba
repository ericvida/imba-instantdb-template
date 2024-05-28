const INSTANT_APP_ID = "" # replace with your instantdb app id

import {init, tx, id} from '@instantdb/core'

const db = init({ appId: INSTANT_APP_ID });

const query = { notes: {} }; # replace users with your instantdb collection

let noteDB = {}

const unsub = db.subscribeQuery { notes: {} }, do(resp)
	if (resp.error)
		console.error('Uh oh!', resp.error.message);
	if (resp.data)
		noteDB = resp.data.notes
		imba.commit!

tag dictionary
	editable = ''
	editableID = ''
	def editNote note
		editable = "{note.content}"
		editableID = note.id
	def deleteNote note
		L 'delete', editableID
		db.transact [tx.notes[editableID].delete()]
		editable = ''
		editableID = ''
		imba.commit!
	def saveNote note
		db.transact
			[
				tx.notes[note.id].update {
					content: editable
					}
			]
		editable = ''
		editableID = ''
		imba.commit!
	<self>
		for note in noteDB
			if editableID is ''
				<div>
					css d:hgrid m:10px g:10px
					<span[ff:serif]> "{note.content}"
					<button @click=editNote(note)> 'edit'
			elif editableID is note.id
				<div>
					css d:hgrid m:10px g:10px gtc:300px 50px 1fr
					<input bind=editable>
						css c:gray9 px:5px w:auto
					<button @click=saveNote(note)> 'save'
					<button @dblclick=deleteNote(note)> 'delete (2click)'
	css button
		bg:gray1 @hover:yellow4
		c:gray9
		px:5px rd:5px fs:14px

tag add-note
	@observable editable = ''
	@computed get preview
		return editable
	def saveNote note
		db.transact
			[
				tx.notes[id()].update 
					content: editable
			]
		editable = ''
		imba.commit!
	<self>
		<div>
			css d:hgrid m:10px g:10px gtc:200px 1fr
			<input bind=editable>
			<button @click.saveNote> "add"
tag app
	css d:vtc
	<self>
		<h1> "Imba ❤ InstantDB"
		<add-note>
		<dictionary>

imba.mount <app>
