# instant.schema.ts

import { i } from '@instantdb/core';

const _schema = i.schema({
	entities: {
			$users: i.entity({
				email: i.string().unique().indexed(),
			}),
			notes: i.entity({
				content: i.string(),
				createdAt: i.date(),
			})
	},
	links: {
			notesAuthor: {
				forward: { on: 'notes', has: 'one', label: 'author' },
				reverse: { on: '$users', has: 'many', label: 'authoredNotes' },
			}
	},
});
### @ts
// This helps Typescript display better intellisense
type _AppSchema = typeof _schema;
interface AppSchema extends _AppSchema {}
const schema: AppSchema = _schema;
export type { AppSchema };
###
export default _schema;
